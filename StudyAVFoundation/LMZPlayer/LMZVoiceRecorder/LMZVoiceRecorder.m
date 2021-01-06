//
//  LMZVoiceRecorder.m
//  StudyAVFoundation
//
//  Created by 梁明哲 on 2020/12/31.
//

#import "LMZVoiceRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAudioSettings.h>
#import "lame.h"
@interface LMZVoiceRecorder()<AVAudioRecorderDelegate>
@property(nonatomic,strong) NSURL *audioUrl;
@property(nonatomic,strong) AVAudioRecorder *recorder;
@end
@implementation LMZVoiceRecorder

- (id)init {
    self = [super init];
    if (self) {
        [self setPramaters];
    }
    return self;
}

- (void)setPramaters {
    NSDictionary *setting = @{
        AVFormatIDKey:@(kAudioFormatLinearPCM),
        AVSampleRateKey:@44100.0f,
        AVNumberOfChannelsKey:@2,
        AVLinearPCMBitDepthKey:@16,
        AVEncoderBitDepthHintKey:@16,
        AVEncoderAudioQualityKey:@(AVAudioQualityLow)
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
    NSString *filePath = [path stringByAppendingPathComponent:@"tmp.wav"];
    return filePath;
}

//开始录音
- (void)start {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    
    [_recorder recordForDuration:15];
    NSLog(@"LMZ: VoiceRocorder - start \n");
}

//暂停录音
- (void)pause {
    [_recorder pause];
    NSLog(@"LMZ: VoiceRocorder - pause \n");
}

//结束录音
- (void)stop {
    [_recorder stop];
    NSLog(@"LMZ: VoiceRocorder - stop \n");
}

//删除录音
- (void)deleteRecording {
    if (_recorder.isRecording == YES) {
        [_recorder stop];
    }
    [_recorder deleteRecording];
}

- (void)saveWithName:(NSString *)fileName {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:@"tmp.wav"];
    NSString *targetPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"wangyu.mp3"]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager moveItemAtPath:filePath toPath:targetPath error:nil];
    
    [self convertToMp3File:filePath targetPath:targetPath withBlock:^(NSString * _Nullable errorInfo) {
        NSLog(@"");
    }];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if ([self.delegate respondsToSelector:@selector(audioRecorderDidFinishRecording:successfully:)]) {
        [self.delegate audioRecorderDidFinishRecording:self successfully:flag];
    }
}


- (void)convertToMp3File:(NSString *)filePath targetPath:(NSString *)targetPath withBlock:(MP3Block)block{
    @try {
        int read, write;
        
        FILE *pcm = fopen([filePath cStringUsingEncoding:1], "rb");     //source 被转换的音频文件位置
        fseek(pcm, 4*1024,SEEK_CUR);                                    //skip file header
        FILE *mp3 = fopen([targetPath cStringUsingEncoding:1], "wb");   //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 44100);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            fwrite(mp3_buffer, write, 1, mp3);
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI操作
            block(exception.name);
        });
        
    }
    @finally {
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI操作
            NSLog(@"MP3生成成功: %@",targetPath);
            block(targetPath);
        });
        
    }
}
@end
