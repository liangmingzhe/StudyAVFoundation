//
//  CameraViewController.m
//  StudyAVFoundation
//
//  Created by 梁明哲 on 2021/1/25.
//

#import "CameraViewController.h"
#import "LMZCameraCapture.h"
#import "LMZVideoEncoder.h"
#import "LMZVideoDecoder.h"
#import "MetalPlayer.h"
#import "OpenGLESPlayerView.h"
@interface CameraViewController ()<LMZCameraCaptureDelegate,LMZVideoEncodeDelegate,H264DecoderDelegate>{
    LMZCameraCapture *lmzCameraCapture;
}
@property (nonatomic ,strong) LMZVideoEncoder *lmzVideoEncoder;
@property (nonatomic ,strong) LMZVideoDecoder *lmzVideoDecoder;
@property (nonatomic ,strong) MetalPlayer *playLayer;
@property (nonatomic ,strong) OpenGLESPlayerView *playerView;
@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //
    //第一步:  初始化摄像头
    [self setupCamera];
    
    //第二步:  创建编码器
    [self setupVideoEncoder];
    
    //第三步:  创建解码器
    [self setupVideoDecoder];
    /*
    self.playLayer = [[MetalPlayer alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 300)];
    [self.view.layer addSublayer:self.playLayer];
     */

    self.playerView = [[OpenGLESPlayerView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.width/2/108*192)];
}

//设置编码器
- (void)setupVideoEncoder {
    self.lmzVideoEncoder = [[LMZVideoEncoder alloc] init];
    self.lmzVideoEncoder.delegate = self;
    self.lmzVideoEncoder.encodeParams = [[EncodeParams alloc] init];
}

//设置解码器
- (void)setupVideoDecoder {
    self.lmzVideoDecoder = [[LMZVideoDecoder alloc] init];
    self.lmzVideoDecoder.delegate = self;
}


//初始化摄像头
- (void)setupCamera {
    lmzCameraCapture = [[LMZCameraCapture alloc] init];
    lmzCameraCapture.delegate = self;
}

//打开摄像头获取数据
- (IBAction)openCamera:(id)sender {
    [self.view.layer addSublayer:self.playerView];
    [lmzCameraCapture run];
}



#pragma mark::LMZ·CameraCaptureDelegate
- (void)videoCaptureOutputCallBack:(CMSampleBufferRef)sampleBuffer {
    // 摄像头视频数据返回
    [self.lmzVideoEncoder videoEncodeInputData:sampleBuffer forceKeyFrame:NO];
}


#pragma mark:LMZVideoEncoderDelegate
- (void)videoEncodeOutputDataCallback:(NSData *)data isKeyFrame:(BOOL)isKeyFrame {
//    NSLog(@"LMZ_DEBUG:Video Data Encode success");
    //sps、pps、
    [self.lmzVideoDecoder decodeNaluData:data];
}

- (void)videoDecodeOutputDataCallback:(CVImageBufferRef)imageBuffer {
//    [self.playLayer inputPixelBuffer:imageBuffer];
    [self.playerView displayWithPixelBuffer:imageBuffer];
    CVPixelBufferRelease(imageBuffer);
}
@end
