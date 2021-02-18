//
//  LMZCameraCapture.m
//  StudyAVFoundation
//
//  Created by 梁明哲 on 2021/1/25.
//

#import "LMZCameraCapture.h"
#import <AVFoundation/AVFoundation.h>
@interface LMZCameraCapture()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCapturePhotoCaptureDelegate>

/** 获取摄像头会话 */
@property (nonatomic, strong) AVCaptureDeviceDiscoverySession *deviceDiscoverySession;
/** 音视频采集任务会话 */
@property (nonatomic ,strong) AVCaptureSession          *captureSession;
/** 音视频捕获任务 */
@property (nonatomic, strong) AVCaptureDeviceInput      *captureDeviceInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput  *captureVideoOutput;
@property (nonatomic, strong) AVCapturePhotoOutput      *capturePhotoOutput;
/** 输出连接 */
@property (nonatomic, strong) AVCaptureConnection       *captureConnection;
/** 分辨率 */
@property (nonatomic, assign) AVCaptureSessionPreset    sessionPreset;
/** 摄像头位置 */
@property (nonatomic, assign) AVCaptureDevicePosition   position;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end
@implementation LMZCameraCapture

- (id)init {
    self = [super init];
    if (self) {
        //1. 获取摄像头
        NSArray *cameras = nil;
        if (@available(iOS 10.0, *)) {
            self.position = AVCaptureDevicePositionFront; //前置摄像头
            self.deviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionUnspecified];
            cameras = self.deviceDiscoverySession.devices;
        } else {
            cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
         
        }
        //选择摄像头
        NSArray *captureDeviceArray = [cameras filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"position == %d",self.position]];
        if (captureDeviceArray.count == 0) {
            NSAssert(1, @"MAVideoCapture::没有获取到摄像头!");
        }
        
        //2. 转换为输入设备
        NSError *errorMessage = nil;
        AVCaptureDevice *device = captureDeviceArray.firstObject;
        self.captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&errorMessage];
        if (errorMessage) {
            NSAssert(1, @"AVCaptureDeviceInput init error!");
        }
        //3.设置输出视频格式
        self.captureVideoOutput = [[AVCaptureVideoDataOutput alloc] init];
        NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange], kCVPixelBufferPixelFormatTypeKey, nil];
        [self.captureVideoOutput setVideoSettings:videoSettings];
        
        //4.设置输出串行队列和数据回调
        dispatch_queue_t outputQueue = dispatch_queue_create("VCVideoCapturerOutputQueue", DISPATCH_QUEUE_SERIAL);
        [self.captureVideoOutput setSampleBufferDelegate:self queue:outputQueue];
        
        self.captureVideoOutput.alwaysDiscardsLateVideoFrames = YES;    // 丢弃延迟的帧
        
        //5.设置抓图输出
        
        
        //6.会话初始化
        self.captureSession = [[AVCaptureSession alloc] init];
        self.captureSession.usesApplicationAudioSession = NO;
        if ([self.captureSession canAddInput:self.captureDeviceInput]) {
            [self.captureSession addInput:self.captureDeviceInput];
        }
        if ([self.captureSession canAddOutput:self.captureVideoOutput]) {
            [self.captureSession addOutput:self.captureVideoOutput];
        }
        if ([self.captureSession canAddOutput:self.captureVideoOutput]) {
            [self.captureSession addOutput:self.captureVideoOutput];
        }

        //设置分辨率
        self.sessionPreset = AVCaptureSessionPreset1920x1080;
        if ([self.captureSession canSetSessionPreset:self.sessionPreset]) {
            [self.captureSession setSessionPreset:self.sessionPreset];
        }
        //设置连接 和视图
        self.captureConnection = [self.captureVideoOutput connectionWithMediaType:AVMediaTypeVideo];
        self.captureConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
        self.captureConnection.videoMirrored = YES;                                                 //是否使用镜像
        self.videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        self.videoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        self.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        int frameRate = 30;
        // 设置帧率
        NSError *error = nil;
        AVFrameRateRange *frameRateRange = [self.captureDeviceInput.device.activeFormat.videoSupportedFrameRateRanges objectAtIndex:0];
        if (frameRate > frameRateRange.maxFrameRate || frameRate < frameRateRange.minFrameRate) {
            NSAssert(1, @"设置的帧率超出了范围");
        }
        
        [self.captureDeviceInput.device lockForConfiguration:&error];
        self.captureDeviceInput.device.activeVideoMinFrameDuration = CMTimeMake(1, frameRate);
        self.captureDeviceInput.device.activeVideoMaxFrameDuration = CMTimeMake(1, frameRate);
        [self.captureDeviceInput.device unlockForConfiguration];
        
    }
    return self;
}


- (void)run {
    [self.captureSession startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if([self.delegate respondsToSelector:@selector(videoCaptureOutputCallBack:)]) {
        [self.delegate videoCaptureOutputCallBack:sampleBuffer];
    }
}
@end

