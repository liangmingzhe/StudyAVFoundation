//
//  VoiceRecorder.m
//  StudyAVFoundation
//
//  Created by 梁明哲 on 2020/12/31.
//

#import "VoiceRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAudioSettings.h>
@interface VoiceRecorder()<AVAudioRecorderDelegate>
@property(nonatomic,strong) NSURL *audioUrl;
@property(nonatomic,strong) AVAudioRecorder *recorder;
@end
@implementation VoiceRecorder

- (id)init {
    self = [super init];
    if (self) {
        [self setPramaters];
    }
    return self;
}

- (void)setPramaters {
    NSDictionary *setting = @{
        AVFormatIDKey:@(kAudioFormatAppleIMA4),
        AVSampleRateKey:@44100.0f,
        AVNumberOfChannelsKey:@2,
        AVEncoderBitDepthHintKey:@16,
        AVEncoderAudioQualityKey:@(AVAudioQualityHigh)
    };
    NSError *error = nil;
    _audioUrl = [ NSURL URLWithString:[self filePath]];
    self.recorder = [[AVAudioRecorder alloc] initWithURL:_audioUrl settings:setting error:&error];
    self.recorder.delegate = self;
    if (self.recorder) {
        self.recorder.meteringEnabled = YES;
        [self.recorder prepareToRecord];        //准备录音
        NSLog(@"\nLMZ: VoiceRocorder - prepareToRecord \n");
    } else {
        NSLog(@"LMZ: VoiceRocorder Error: %@ [%ld]\n",[error localizedDescription],(long)[error code]);
    }
}
- (NSString *)filePath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:@"voice.caf"];
    return filePath;
}

- (void)start {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    
    [_recorder recordForDuration:15];
    NSLog(@"LMZ: VoiceRocorder - start \n");
}

- (void)pause {
    [_recorder pause];
    NSLog(@"LMZ: VoiceRocorder - pause \n");
}

- (void)stop {
    [_recorder stop];
    NSLog(@"LMZ: VoiceRocorder - stop \n");
}

- (void)deleteRecording {
    if (_recorder.isRecording == YES) {
        [_recorder stop];
    }
    [_recorder deleteRecording];
}


- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if ([self.delegate respondsToSelector:@selector(audioRecorderDidFinishRecording:successfully:)]) {
        [self.delegate audioRecorderDidFinishRecording:self successfully:flag];
    }
}


@end
