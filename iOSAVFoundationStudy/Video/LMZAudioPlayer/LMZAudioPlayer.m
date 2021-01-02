//
//  LMZAudioPlayer.m
//  StudyAVFoundation
//
//  Created by 梁明哲 on 2020/12/31.
//
/*
 开发笔记:
 1.AVAudioPlayer 播放进度的监听问题
    AVAudioPlayer没有提供播放进度的回调，只提供了 currentTime 和 duration两个参数。这里使用的方式是用NSTimer 定时更新获取进度。
    
 */

#import "LMZAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
@interface LMZAudioPlayer()<AVAudioPlayerDelegate>
@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation LMZAudioPlayer
- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)playerAudioWithUrl:(NSURL *)url {
    NSError *playerError;
    if (self.player) {
        [self.player stop];
        self.player = nil;
    }
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&playerError];
    self.player.delegate = self;
    [self.player setNumberOfLoops:0];
    [self.player setVolume:1];
    [self.player setDelegate:self];
    [self.player prepareToPlay];
    if (self.player == nil) {
        NSLog(@"LMZ:Audio Error:%@",[playerError description]);
    } else {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
        [_player play];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTimeAddProgress) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];  //防止被UITrakingMode干扰
        [self.timer fire];
    }
}

- (NSTimeInterval)playerDuration {
    return [_player duration];
}
- (NSTimeInterval)playerCurrentTime {
    return [_player currentTime];
}


- (void)stop {
    [_player stop];
    if(self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)uninit {
    self.player.delegate = nil;
    self.player = nil;
    if(self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)updateTimeAddProgress {
    if ([self.delegate respondsToSelector:@selector(playerCurrentTime:)]) {
        if (_player != nil) {
            
            [self.delegate playerCurrentTime:_player.currentTime];
            NSLog(@"LMZ: Audio Current Time:%f",_player.currentTime);
            
        }
    }
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"LMZ:Audio Play finish");
    if(self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}




@end
