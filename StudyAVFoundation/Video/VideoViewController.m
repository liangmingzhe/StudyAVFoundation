//
//  VideoViewController.m
//  StudyAVFoundation
//
//  Created by 梁明哲 on 2020/12/29.
//

#import "VideoViewController.h"
#import "TZImagePickerController.h"
#import "LMZVideoAVPlayer.h"
#import "LMZVideoProgressView.h"
#define WIDTH   [UIScreen mainScreen].bounds.size.width
#define HEIGHT   [UIScreen mainScreen].bounds.size.height
@interface VideoViewController ()<TZImagePickerControllerDelegate,UINavigationControllerDelegate,LMZVideoAVPlayerProtocol>

@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (nonatomic,strong) LMZVideoAVPlayer *player;
@property (nonatomic,strong) UIImageView *imagePlayer;

@property (nonatomic,strong) LMZVideoProgressView *progressView;
@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 导航栏右侧按键初始化
    [self rightBtnHandle];
    
    //播放进度控制
    self.progressView = [[LMZVideoProgressView alloc] initWithFrame:CGRectMake(10, 400, WIDTH - 20, 50)];
    [self.view addSubview:self.progressView];
    __weak typeof (self)weakSelf = self;
    self.progressView.valueBlock = ^(float value, BOOL isfinished) {
        if (isfinished == YES) {
            [weakSelf.player play];
        }else {
            [weakSelf.player pause];
        }
        //进度条触摸事件处理
        float v = value;
        
        [weakSelf.player seekToVideoPrecent:v completionHandler:^(BOOL finished) {
        
        }];
    };
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}


- (void)rightBtnHandle {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    UIButton *custombtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    [custombtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [view addSubview:custombtn];
    [custombtn setTitle:@"打开" forState:UIControlStateNormal];
    [custombtn addTarget:self action:@selector(selectFileFromSystemAlbum:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = item;
}


#pragma mark:TZImagePickerDelegate
- (void)selectFileFromSystemAlbum:(id)sender {
    TZImagePickerController *pickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    pickerVC.delegate = self;
    [pickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {}];
    
    pickerVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:pickerVC animated:YES completion:nil];
}
//视频选择回调
- (void)imagePickerController:(TZImagePickerController *)picker
        didFinishPickingVideo:(UIImage *)coverImage
                 sourceAssets:(PHAsset *)asset {
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        PHImageManager *manager = [PHImageManager defaultManager];
        [manager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            AVURLAsset *urlAsset = (AVURLAsset *)asset;
            NSURL *url = urlAsset.URL;
            NSData *data = [NSData dataWithContentsOfURL:url];
            NSLog(@"%@",data);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.player = [[LMZVideoAVPlayer alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width *9/16) url:url.absoluteString];
                self.player.playDelegate = self;
                [self.playerView addSubview:self.player];
                
                self.progressView.duration = self.player.totalTime;
                self.progressView.current = self.player.currentTime;
                self.progressView.progressValue = self.player.currentTime/self.player.totalTime;

                
            });
        }];
    }else if(asset.mediaType == PHAssetMediaTypeImage){
        
    }
}

//图片选择回调
- (void)imagePickerController:(TZImagePickerController *)picker
       didFinishPickingPhotos:(NSArray<UIImage *> *)photos
                 sourceAssets:(NSArray *)assets
        isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    self.imagePlayer = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.playerView.frame.size.height)];
    [self.playerView addSubview:self.imagePlayer];
    self.imagePlayer.image = [photos firstObject];
}


- (void)LMZVideoAVPlayerRunning:(CGFloat)currentTime totalTime:(CGFloat)totalTime {
    self.progressView.duration = totalTime;
    self.progressView.current = currentTime;
    self.progressView.progressValue = currentTime/totalTime;
}


@end
