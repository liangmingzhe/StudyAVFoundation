//
//  LMZVideoEncoder.m
//  StudyAVFoundation
//
//  Created by 梁明哲 on 2021/1/26.
//

#import "LMZVideoEncoder.h"
@interface LMZVideoEncoder()
@property (assign, nonatomic) VTCompressionSessionRef compressionSession;
@end
@implementation LMZVideoEncoder
- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (BOOL)initEncoder{
    if (self.encodeParams == nil) {
        return NO;
    }
    /**
     * @discussion 创建一个编码的会话(Session) ,设置编码的宽、高、编码类型(H.264)、设置回调函数(用于处理编码后的字节流)，最后传入一个编码会话的句柄
     *
     */
    OSStatus status = VTCompressionSessionCreate(NULL,
                                                 (int)self.encodeParams.encodeWidth,
                                                 (int)self.encodeParams.encodeHeight,
                                                 self.encodeParams.encodeType,
                                                 NULL,
                                                 NULL,
                                                 NULL,
                                                 encodeOutputDataCallback,
                                                 (__bridge void *)(self),
                                                 &_compressionSession);
    if (noErr != status) {
        NSLog(@"LMZVideoEncoder::VTCompressionSessionCreate failed! status:%d", (int)status);
        return NO;
    }
    if (NULL == self.compressionSession) {
        return NO;
    }
    if (![self adjustBitRate:self.encodeParams.bitRate]) {
        return nil;
    }
    //设置 H.264协议等级 ProfileLevel，h264的协议等级，不同的清晰度使用不同的ProfileLevel。
    CFStringRef profileRef = kVTProfileLevel_H264_Baseline_AutoLevel;
    status = VTSessionSetProperty(self.compressionSession, kVTCompressionPropertyKey_ProfileLevel, profileRef);
    CFRelease(profileRef);
    if (noErr != status) {
        NSLog(@"LMZVideoEncoder::kVTCompressionPropertyKey_ProfileLevel failed status:%d", (int)status);
        return nil;
    }
    // 设置实时编码输出（避免延迟）
    status = VTSessionSetProperty(self.compressionSession, kVTCompressionPropertyKey_RealTime, kCFBooleanTrue);
    if (noErr != status) {
        NSLog(@"LMZVideoEncoder::kVTCompressionPropertyKey_RealTime failed status:%d", (int)status);
        return nil;
    }

    // 配置是否产生B帧
    status = VTSessionSetProperty(self.compressionSession, kVTCompressionPropertyKey_AllowFrameReordering, self.encodeParams.allowFrameReordering == YES? kCFBooleanTrue:kCFBooleanFalse);
    if (noErr != status) {
        NSLog(@"LMZVideoEncoder::kVTCompressionPropertyKey_AllowFrameReordering failed status:%d", (int)status);
        return nil;
    }
    // 配置关键帧间隔
    status = VTSessionSetProperty(self.compressionSession,
                                  kVTCompressionPropertyKey_MaxKeyFrameInterval,
                                  (__bridge CFTypeRef)@(self.encodeParams.frameRate * self.encodeParams.maxKeyFrameInterval));
    if (noErr != status)
    {
        NSLog(@"LMZVideoEncoder::kVTCompressionPropertyKey_MaxKeyFrameInterval failed status:%d", (int)status);
        return nil;
    }

    status = VTSessionSetProperty(self.compressionSession,
                                  kVTCompressionPropertyKey_MaxKeyFrameIntervalDuration,
                                  (__bridge CFTypeRef)@(self.encodeParams.maxKeyFrameInterval));
    if (noErr != status) {
        NSLog(@"LMZVideoEncoder::kVTCompressionPropertyKey_MaxKeyFrameIntervalDuration failed status:%d", (int)status);
        return nil;
    }
    // 编码器准备编码
    status = VTCompressionSessionPrepareToEncodeFrames(self.compressionSession);

    if (noErr != status)
    {
        NSLog(@"LMZVideoEncoder::VTCompressionSessionPrepareToEncodeFrames failed status:%d", (int)status);
        return nil;
    }
    
    return YES;
}
/**
 * @abstract    编码
 * @param       sampleBuffer   待编码的数据
 * @param       forceKeyFrame  是否强制I帧
 * @return      返回值
 */
- (BOOL)videoEncodeInputData:(CMSampleBufferRef)sampleBuffer forceKeyFrame:(BOOL)forceKeyFrame {
    if (sampleBuffer) {
        CVImageBufferRef pixelBuffer = (CVImageBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
        self.encodeParams.encodeWidth = CVPixelBufferGetWidth(pixelBuffer);
        self.encodeParams.encodeHeight = CVPixelBufferGetHeight(pixelBuffer);
    }else {
        return NO;
    }
    if (NULL == self.compressionSession) {
        [self initEncoder];
        return NO;
    }
    
    if (nil == sampleBuffer) {
        return NO;
    }
    //转换成CVImageBufferRef
    CVImageBufferRef pixelBuffer = (CVImageBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
    NSDictionary *frameProperties = @{(__bridge NSString *)kVTEncodeFrameOptionKey_ForceKeyFrame: @(forceKeyFrame)};
    
    OSStatus status = VTCompressionSessionEncodeFrame(self.compressionSession,
                                                      pixelBuffer,
                                                      kCMTimeInvalid,
                                                      kCMTimeInvalid, (__bridge CFDictionaryRef)frameProperties,
                                                      NULL,
                                                      NULL);
    if (noErr != status) {
        NSLog(@"LMZVideoEncoder::VTCompressionSessionEncodeFrame failed! status:%d", (int)status);
        return NO;
    }
    //解码成功
    return YES;
}


/**
 编码过程中调整码率
 @param bitRate 码率  单位是bps
 @return 结果
 */
- (BOOL)adjustBitRate:(NSInteger)bitRate
{
    if (bitRate <= 0)
    {
        NSLog(@"VEVideoEncoder::adjustBitRate failed! bitRate <= 0");
        return NO;
    }
    OSStatus status = VTSessionSetProperty(self.compressionSession, kVTCompressionPropertyKey_AverageBitRate, (__bridge CFTypeRef)@(bitRate));
    if (noErr != status)
    {
        NSLog(@"VEVideoEncoder::kVTCompressionPropertyKey_AverageBitRate failed status:%d", (int)status);
        return NO;
    }
    
    // 参考webRTC
    int64_t dataLimitBytesPerSecondValue = bitRate * 1.5 / 8;
    CFNumberRef bytesPerSecond = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt64Type, &dataLimitBytesPerSecondValue);
    int64_t oneSecondValue = 1;
    CFNumberRef oneSecond = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt64Type, &oneSecondValue);
    const void* nums[2] = {bytesPerSecond, oneSecond};
    CFArrayRef dataRateLimits = CFArrayCreate(NULL, nums, 2, &kCFTypeArrayCallBacks);
    status = VTSessionSetProperty(_compressionSession, kVTCompressionPropertyKey_DataRateLimits, dataRateLimits);
    if (noErr != status)
    {
        NSLog(@"VEVideoEncoder::kVTCompressionPropertyKey_DataRateLimits failed status:%d", (int)status);
        return NO;
    }
    return YES;
}

/**
 * @abstract    编码回调
 * @function    encodeOutputDataCallback
 * @param       outputCallbackRefCon        输出回调信息参考
 * @param       sourceFrameRefCon           源数据帧参考
 * @param       status                      状态
 * @param       infoFlags                   编码状态信息
 * @param       sampleBuffer                编码后的数据帧
 */
void encodeOutputDataCallback(void * CM_NULLABLE outputCallbackRefCon,
                              void * CM_NULLABLE sourceFrameRefCon,
                              OSStatus status,
                              VTEncodeInfoFlags infoFlags,
                              CM_NULLABLE CMSampleBufferRef sampleBuffer){
    if(status != noErr ||sampleBuffer == nil) {
        NSLog(@"VEVideoEncoder::encodeOutputCallback Error : %d!", (int)status);
        return;
    }
    if (outputCallbackRefCon == nil)
    {
        return;
    }
    if (!CMSampleBufferDataIsReady(sampleBuffer))
    {
        return;
    }
    if (infoFlags & kVTEncodeInfo_FrameDropped)
    {
        NSLog(@"VEVideoEncoder::H264 encode dropped frame.");
        return;
    }
    LMZVideoEncoder *encoder = (__bridge LMZVideoEncoder *)outputCallbackRefCon;
    const char header[] = "\x00\x00\x00\x01";
    size_t headerLen = (sizeof header) - 1;
    NSData *headerData = [NSData dataWithBytes:header length:headerLen];
    // 判断当前帧是否为关键帧
    bool isKeyFrame = !CFDictionaryContainsKey((CFDictionaryRef)CFArrayGetValueAtIndex(CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, true), 0), (const void *)kCMSampleAttachmentKey_NotSync);
    if (isKeyFrame) {
        //是关键帧
        CMFormatDescriptionRef formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer);
        size_t sParameterSetSize, sParameterSetCount;
        const uint8_t *sParameterSet;
        OSStatus spsStatus = CMVideoFormatDescriptionGetH264ParameterSetAtIndex(formatDescription, 0, &sParameterSet, &sParameterSetSize, &sParameterSetCount, 0);
        
        size_t pParameterSetSize, pParameterSetCount;
        const uint8_t *pParameterSet;
        OSStatus ppsStatus = CMVideoFormatDescriptionGetH264ParameterSetAtIndex(formatDescription, 1, &pParameterSet, &pParameterSetSize, &pParameterSetCount, 0);
        if (noErr == spsStatus && noErr == ppsStatus) {

            NSData *sps = [NSData dataWithBytes:sParameterSet length:sParameterSetSize];
            NSData *pps = [NSData dataWithBytes:pParameterSet length:pParameterSetSize];
            NSMutableData *spsData = [NSMutableData data];
            [spsData appendData:headerData];
            [spsData appendData:sps];

            if ([encoder.delegate respondsToSelector:@selector(videoEncodeOutputDataCallback:isKeyFrame:)]) {
                //            00 00 00 01 27 42 00 0D AB 41 81 4F 3E 80
                [encoder.delegate videoEncodeOutputDataCallback:spsData isKeyFrame:isKeyFrame];         //SPS
            }
            
            NSMutableData *ppsData = [NSMutableData data];
            [ppsData appendData:headerData];
            [ppsData appendData:pps];
            
            if ([encoder.delegate respondsToSelector:@selector(videoEncodeOutputDataCallback:isKeyFrame:)]) {
                //           00 00 00 01 28 CE 3C 30
                [encoder.delegate videoEncodeOutputDataCallback:ppsData isKeyFrame:isKeyFrame];         //PPS
            }

        }
    }
    
    CMBlockBufferRef blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer);
    size_t length, totalLength;
    char *dataPointer;
    status = CMBlockBufferGetDataPointer(blockBuffer, 0, &length, &totalLength, &dataPointer);
    if (noErr != status) {
        NSLog(@"VEVideoEncoder::CMBlockBufferGetDataPointer Error : %d!", (int)status);
        return;
    }
    size_t bufferOffset = 0;
    static const int avcHeaderLength = 4;   // 返回的NALU数据前四个字节不是0001的startcode，而是大端模式的帧长度length
    // 循环获取NALU数据
    while (bufferOffset < totalLength - avcHeaderLength) {
        // 读取 NAL 单元长度
        uint32_t nalUnitLength = 0;
        memcpy(&nalUnitLength, dataPointer + bufferOffset, avcHeaderLength);    //每次复制4个字节
        
        // 大端转小端
        nalUnitLength = CFSwapInt32BigToHost(nalUnitLength);
        
        NSData *frameData = [[NSData alloc] initWithBytes:(dataPointer + bufferOffset + avcHeaderLength) length:nalUnitLength];

        NSMutableData *outputFrameData = [NSMutableData data];
        [outputFrameData appendData:headerData];            //head 00 00 00 01
        [outputFrameData appendData:frameData];
        
        bufferOffset += avcHeaderLength + nalUnitLength;    //偏移,取下一组
        //00 00 00 01 21 E1 04 08 EC 46 B1 1A C4 78 8E 6F F5 59 F5 9F 59 FC FE 7D 32 9F FE 7F 3F 9F CF E7 F3 F6 7F 3F 9F FE 7F 3F 9F CF E7 F3 EE 8F AC FE 7F 3F FC FE 7F 3F 9F CF E7 E8 FD 1F CF FF 3F 9F CF E7 F3 EB 3F 47 F1 1E 7F 3F FC FE 7F 3F 9F CF C8 7F 3F 9F FE 7F 3F 9F CF E7 E4 3F 9F AF 9F CF E7 F3 F9 F9 0F DF CF E7 F3 F9 FC FE 2B 4D 9F BF 9F CF E7 F3 F9 FC FA 9B E7 F3 F9 FC FE 7F 11 CA 7F F9 FC FE 7F 3F 9F CF FC BD 64 3F FC FE 7F 3F 9F CF E7 F1 3A 65 F9 FC FE 7F 3F 9F CF E2 3C 47 89 EF E7 F3 F9 FC FE 7F 3F 9F CF E2 7C 47 5F 3F 9F CF E7 F3 F9 FC FE 7F 3F 9F C4 7F CF E7 F1 5E 7F 3F 9F CF E7 F3 F9 FC FF F3 F9 FC FE 7F 3F 9F CF E7 F3 F9 FC FF F3 F9 FC FE 7F 3F 9F CF E7 F3 F9 FC FF F0
        if ([encoder.delegate respondsToSelector:@selector(videoEncodeOutputDataCallback:isKeyFrame:)]) {
            [encoder.delegate videoEncodeOutputDataCallback:outputFrameData isKeyFrame:isKeyFrame];
        }
    }

}

@end



//编码器参数类
@implementation EncodeParams

- (id)init {
    self = [super init];
    if (self) {
        self.bitRate = 1024 * 1024;
        self.frameRate = 15;
        self.encodeWidth = 1920;
        self.encodeHeight = 1080;
        self.profileLevel = LMZVideoEncoderProfileLevelBP;
        self.encodeType = kCMVideoCodecType_H264;
        self.maxKeyFrameInterval = 240;
        self.allowFrameReordering = NO; //是否产生B帧
    }
    return self;
}
@end
