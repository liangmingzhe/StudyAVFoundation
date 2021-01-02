//
//  AudioViewController.m
//  StudyAVFoundation
//
//  Created by 梁明哲 on 2020/12/31.
//

#import "AudioViewController.h"
#import "VoiceRecorder.h"
#import "LMZAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
@interface AudioViewController ()<AudioDelegate,LMZRecorderDelegate> {
    AVURLAsset        *audioAsset;    //音频信息
}
@property (nonatomic ,strong) VoiceRecorder     *recoder;       //录音器
@property (nonatomic ,strong) LMZAudioPlayer    *player;        //播放器
@property (weak, nonatomic) IBOutlet UILabel    *playTime;


@property (weak, nonatomic) IBOutlet UILabel *filePathLabel;
@end

@implementation AudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.recoder = [[VoiceRecorder alloc] init];
    self.recoder.delegate = self;
    self.player  = [[LMZAudioPlayer alloc] init];
    self.player.delegate = self;
    self.filePathLabel.text = [self.recoder filePath];
    
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
        [self.player playerAudioWithUrl:[NSURL URLWithString:urlString]];
        float durationSeconds = [self durationWithAudio:urlString];
        self.playTime.text = [NSString stringWithFormat:@"%0.1f/%0.1f",[_player playerCurrentTime],durationSeconds];
    }else {
        [self.player stop];
    }

}

- (IBAction)deleteAudio:(id)sender {
    [self.player stop];
    [self.recoder deleteRecording];
    self.playTime.text = [NSString stringWithFormat:@"0.0s/0.0s"];
}

#pragma AudioDelegate
- (void)playerCurrentTime:(NSTimeInterval)time {
    self.playTime.text = [NSString stringWithFormat:@"%0.1f/%0.1f",time,[_player playerDuration]];
}

#pragma LMZRecorderDelegate
- (void)audioRecorderDidFinishRecording:(VoiceRecorder *)recorder successfully:(BOOL)flag {
    if (flag == YES) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *urlString = self.filePathLabel.text;
            float duration = [self durationWithAudio:urlString];
            self.playTime.text = [NSString stringWithFormat:@"%@/%0.1f",@0.0,duration];
        });
    }
}


//计算音频文件的时长
- (float)durationWithAudio:(NSString *)audioString{
    AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath: audioString] options:nil];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    NSLog(@"%f",audioDurationSeconds);
    return audioDurationSeconds;
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player uninit];
}


@end
