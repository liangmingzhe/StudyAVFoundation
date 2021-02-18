//
//  AudioViewController.m
//  StudyAVFoundation
//
//  Created by 梁明哲 on 2020/12/31.
//

#import "AudioViewController.h"
#import "AudioFileListViewController.h"
#import "LMZVoiceRecorder.h"
#import "LMZAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "LMZAudioInfo.h"
//#import "MNHTTP.h"

@interface AudioViewController ()<AudioDelegate,LMZRecorderDelegate> {

}
@property (nonatomic ,strong) LMZVoiceRecorder  *recoder;           //录音器
@property (nonatomic ,strong) LMZAudioPlayer    *audioPlayer;       //播放器

@property (nonatomic ,strong) AVURLAsset        *audioAsset;    //音频信息
@property (nonatomic ,strong) AVMetadataItem    *audioMetaDataItem;
@property (nonatomic,strong)  LMZAudioInfo      *audioInfo;  //音频文件信息

@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel    *playTime;
@property (weak, nonatomic) IBOutlet UILabel *filePathLabel;

@end

@implementation AudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self rightBtnHandle];
    self.title = @"音频";
    self.recoder = [[LMZVoiceRecorder alloc] init];
    self.recoder.delegate = self;
    
    self.audioPlayer  = [[LMZAudioPlayer alloc] init];
    self.audioPlayer.delegate = self;
    self.filePathLabel.text = [self.recoder filePath];
    
    self.audioInfo = [[LMZAudioInfo alloc] init];
    
}


- (IBAction)recordWithState:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {

        [self.recoder start];
    }else {
        [self.recoder stop];
    }
}

- (IBAction)playWithState:(UIButton *)sender {
    sender.selected = !sender.selected;
    if(sender.selected == YES) {
        NSString *urlString = self.filePathLabel.text;
        [self.audioPlayer playerAudioWithUrl:[NSURL URLWithString:urlString]];
        float durationSeconds = [self durationWithAudio:urlString];
        self.playTime.text = [NSString stringWithFormat:@"%0.1f/%0.1f",[_audioPlayer playerCurrentTime],durationSeconds];
    }else {
        [self.audioPlayer stop];
    }

}

- (IBAction)deleteAudio:(id)sender {
    [self.audioPlayer stop];
    [self.recoder deleteRecording];
    self.playTime.text = [NSString stringWithFormat:@"0.0s/0.0s"];
}

- (void)rightBtnHandle {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    UIButton *custombtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    [custombtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [view addSubview:custombtn];
    [custombtn setTitle:@"打开" forState:UIControlStateNormal];
    [custombtn addTarget:self action:@selector(openFile) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = item;
    
}
- (void)openFile {
    AudioFileListViewController *vc = [[AudioFileListViewController alloc] init];
    vc.selectFile = ^(NSString * _Nonnull selectFilePath, BOOL isSelectFile) {
        if (isSelectFile == YES) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.filePathLabel.text = selectFilePath;
            });
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma AudioDelegate
- (void)playerCurrentTime:(NSTimeInterval)time {
    self.playTime.text = [NSString stringWithFormat:@"%0.1f/%0.1f",time,[_audioPlayer playerDuration]];
}

#pragma LMZRecorderDelegate
- (void)audioRecorderDidFinishRecording:(LMZVoiceRecorder *)recorder successfully:(BOOL)flag {
    if (flag == YES) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *urlString = self.filePathLabel.text;
            float duration = [self durationWithAudio:urlString];
            self.playTime.text = [NSString stringWithFormat:@"%@/%0.1f",@0.0,duration];
        });
    }
}
//播放结束
- (void)playerDidFinishPlaying:(LMZAudioPlayer *)player successfully:(BOOL)flag {
    if (flag == YES) {
        [self.playBtn setSelected:NO];
    }
}

- (IBAction)saveAudioFile:(UIButton *)sender {
    NSString *timeStamp = [LMZDateManager timeStampWithDate:[NSDate date]];
    [self.recoder saveWithName:timeStamp];
}


//计算音频文件的时长
- (float)durationWithAudio:(NSString *)audioString{
    self.audioAsset =[AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath: audioString] options:nil];
    CMTime audioDuration = self.audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    NSLog(@"%f",audioDurationSeconds);
    return audioDurationSeconds;
}

- (void)setAudioAsset:(AVURLAsset *)audioAsset {
    _audioAsset = audioAsset;
    for (NSString *fmt in [audioAsset availableMetadataFormats]) {
        for (AVMetadataItem *metadataItem in [audioAsset metadataForFormat:fmt]) {
            if ([metadataItem.commonKey isEqualToString:@"title"]) {
                self.audioInfo.song = [NSString stringWithFormat:@"%@",metadataItem.value];
            }else if ([metadataItem.commonKey isEqualToString:@"artist"]){
                self.audioInfo.singer = (NSString *)metadataItem.value;//歌手
            }else if ([metadataItem.commonKey isEqualToString:@"albumName"])
            {
                self.audioInfo.albumName = (NSString *)metadataItem.value;
            }else if ([metadataItem.commonKey isEqualToString:@"artwork"]) {
                NSDictionary *dict=(NSDictionary *)metadataItem.value;
                NSData *data=[dict objectForKey:@"data"];
                self.audioInfo.image=[UIImage imageWithData:data];//图片
            }
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.audioPlayer uninit];
}

@end
