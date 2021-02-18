//
//  LMZVideoDecoder.m
//  StudyAVFoundation
//
//  Created by 梁明哲 on 2021/1/26.
//

#import "LMZVideoDecoder.h"
#import <VideoToolbox/VideoToolbox.h>
@interface LMZVideoDecoder()
/** sps数据 */
@property (nonatomic, assign) uint8_t *sps;
/** sps数据长度 */
@property (nonatomic, assign) NSInteger spsSize;
/** pps数据 */
@property (nonatomic, assign) uint8_t *pps;
/** pps数据长度 */
@property (nonatomic, assign) NSInteger ppsSize;
/** 解码器句柄 */
@property (nonatomic, assign) VTDecompressionSessionRef decodeSession;
/** 视频解码信息句柄 */
@property (nonatomic, assign) CMVideoFormatDescriptionRef decoderFormatDescription;

@end
@implementation LMZVideoDecoder

- (BOOL)initDecoder {
    if (self.decodeSession) {
        return YES;
    }
    const uint8_t* const parameterSetPointers[2] = {_sps, _pps};
    const size_t parameterSetSizes[2] = {_spsSize, _ppsSize};
    // 根据sps pps创建解码视频参数
    OSStatus status = CMVideoFormatDescriptionCreateFromH264ParameterSets(kCFAllocatorDefault,
                                                                         2,
                                                                         parameterSetPointers,
                                                                         parameterSetSizes,
                                                                         4,
                                                                         &_decoderFormatDescription);
    if (status != noErr) {
        NSLog(@"H264Decoder::CMVideoFormatDescriptionCreateFromH264ParameterSets failed status = %d", (int)status);
        return NO;
    }
    
    // 从sps pps中获取解码视频的宽高信息
    CMVideoDimensions videoDimensions = CMVideoFormatDescriptionGetDimensions(_decoderFormatDescription);
    
    // kCVPixelBufferPixelFormatTypeKey 解码图像的采样格式
    // kCVPixelBufferWidthKey、kCVPixelBufferHeightKey 解码图像的宽高
    // kCVPixelBufferOpenGLCompatibilityKey制定支持OpenGL渲染，经测试有没有这个参数好像没什么差别
    NSDictionary* destinationPixelBufferAttributes = @{
        (id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange),
        (id)kCVPixelBufferWidthKey : @(videoDimensions.width),
        (id)kCVPixelBufferHeightKey : @(videoDimensions.height),
        (id)kCVPixelBufferOpenGLCompatibilityKey : @(YES)
    };
    
    // 设置解码输出数据回调
    VTDecompressionOutputCallbackRecord callBackRecord;
    callBackRecord.decompressionOutputCallback = decodeOutputDataCallback;
    callBackRecord.decompressionOutputRefCon = (__bridge void *)self;
    
    // 创建解码器
    status = VTDecompressionSessionCreate(kCFAllocatorDefault, _decoderFormatDescription, NULL, (__bridge CFDictionaryRef)destinationPixelBufferAttributes, &callBackRecord, &_decodeSession);
    if (status != noErr) {
        NSLog(@"LMZVideoDecoder::VTDecompressionSessionCreate status = %d",(int)status);
    }
    // 解码线程数量
    VTSessionSetProperty(_decodeSession, kVTDecompressionPropertyKey_ThreadCount, (__bridge CFTypeRef)@(1));
    // 是否实时解码
    VTSessionSetProperty(_decodeSession, kVTDecompressionPropertyKey_RealTime, kCFBooleanTrue);

    return YES;
}

/**
 解码NALU数据

 @param naluData NALU数据
 */
- (void)decodeNaluData:(NSData *)naluData {
    uint8_t *frame = (uint8_t *)naluData.bytes;
    uint32_t frameSize = (uint32_t)naluData.length;
    // frame的前4位是NALU数据的开始码，也就是00 00 00 01，第5个字节是表示数据类型，转为10进制后，7是sps,8是pps,5是IDR（I帧）信息
    int nalu_type = (frame[4] & 0x1F);
    
    //    0000 0000 0000 0010 0111 & 0000 0000 0001 1111 = 0000 0000 0000 0000 0111(0007) SPS
    //    0000 0000 0000 0010 0101 & 0000 0000 0001 1111 = 0000 0000 0000 0000 0101(0007) I 帧
        
    
    // 将NALU的开始码替换成NALU的长度信息
    uint32_t nalSize = (uint32_t)(frameSize - 4);
    uint8_t *pNalSize = (uint8_t*)(&nalSize);
    frame[0] = *(pNalSize + 3);
    frame[1] = *(pNalSize + 2);
    frame[2] = *(pNalSize + 1);
    frame[3] = *(pNalSize);
    

    switch (nalu_type)
    {
        case 0x05: // I帧
            NSLog(@"NALU type is IDR frame");
            if([self initDecoder]) {
                [self decode:frame withSize:frameSize];
            }
            
            break;
        case 0x07: // SPS
            NSLog(@"NALU type is SPS frame");
            _spsSize = frameSize - 4;
            _sps = malloc(_spsSize);
            memcpy(_sps, &frame[4], _spsSize);
            
            break;
        case 0x08: // PPS
            NSLog(@"NALU type is PPS frame");
            _ppsSize = frameSize - 4;
            _pps = malloc(_ppsSize);
            memcpy(_pps, &frame[4], _ppsSize);
            break;
            
        default: // B帧或P帧
          
            if([self initDecoder]) {
                [self decode:frame withSize:frameSize];
            }
            break;
    }
}

/**
 解码数据

 @param frame 数据
 @param frameSize 数据长度
 */
- (void)decode:(uint8_t *)frame withSize:(uint32_t)frameSize {
    CMBlockBufferRef blockBuffer = NULL;
    // 创建 CMBlockBufferRef
    OSStatus status  = CMBlockBufferCreateWithMemoryBlock(NULL, (void *)frame, frameSize, kCFAllocatorNull, NULL, 0, frameSize, FALSE, &blockBuffer);
    if(status != kCMBlockBufferNoErr)
    {
        return;
    }
    CMSampleBufferRef sampleBuffer = NULL;
    const size_t sampleSizeArray[] = {frameSize};
    // 创建 CMSampleBufferRef
    status = CMSampleBufferCreateReady(kCFAllocatorDefault, blockBuffer, _decoderFormatDescription , 1, 0, NULL, 1, sampleSizeArray, &sampleBuffer);
    if (status != kCMBlockBufferNoErr || sampleBuffer == NULL)
    {
        return;
    }
    // VTDecodeFrameFlags 0为允许多线程解码
    VTDecodeFrameFlags flags = 0;
    VTDecodeInfoFlags flagOut = 0;
    // 解码 这里第四个参数会传到解码的callback里的sourceFrameRefCon，可为空
    OSStatus decodeStatus = VTDecompressionSessionDecodeFrame(_decodeSession, sampleBuffer, flags, NULL, &flagOut);
    
    if(decodeStatus == kVTInvalidSessionErr)
    {
        NSLog(@"H264Decoder::Invalid session, reset decoder session");
    }
    else if(decodeStatus == kVTVideoDecoderBadDataErr)
    {
        NSLog(@"H264Decoder::decode failed status = %d(Bad data)", (int)decodeStatus);
    }
    else if(decodeStatus != noErr)
    {
        NSLog(@"H264Decoder::decode failed status = %d", (int)decodeStatus);
    }
    // Create了就得Release
    CFRelease(sampleBuffer);
    CFRelease(blockBuffer);
    return;
}


//解码回调函数
static void decodeOutputDataCallback(void *decompressionOutputRefCon, void *sourceFrameRefCon, OSStatus status, VTDecodeInfoFlags infoFlags, CVImageBufferRef pixelBuffer, CMTime presentationTimeStamp, CMTime presentationDuration)
{
    // retain再输出，外层去release
    CVPixelBufferRetain(pixelBuffer);
    LMZVideoDecoder *decoder = (__bridge LMZVideoDecoder *)decompressionOutputRefCon;
    
    if ([decoder.delegate respondsToSelector:@selector(videoDecodeOutputDataCallback:)]) {
        [decoder.delegate videoDecodeOutputDataCallback:pixelBuffer];
    }
}

@end
