//
//  VideoViewController.m
//  StudyAVFoundation
//
//  Created by 梁明哲 on 2020/12/29.
//

#import "VideoViewController.h"
#import "TZImagePickerController.h"
#import "LMZVideoAVPlayer.h"

@interface VideoViewController ()<TZImagePickerControllerDelegate,UINavigationControllerDelegate,LMZVideoAVPlayerProtocol>

@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (nonatomic,strong) LMZVideoAVPlayer *player;
@property (nonatomic,strong) UIImageView *imagePlayer;
@property (nonatomic,strong) UIButton *playBtn;
@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playBtn.frame = CGRectMake(10, 200, 50, 50);
    [self.view addSubview:self.playBtn];
    
}

#pragma mark:TZImagePickerDelegate
- (IBAction)selectFileFromSystemAlbum:(id)sender {
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


@end
