//
//  VoiceRecorder.h
//  StudyAVFoundation
//
//  Created by 梁明哲 on 2020/12/31.
//

#import <Foundation/Foundation.h>
@class VoiceRecorder;
NS_ASSUME_NONNULL_BEGIN
@protocol LMZRecorderDelegate <NSObject>

- (void)audioRecorderDidFinishRecording:(VoiceRecorder *)recorder successfully:(BOOL)flag;

@end
@interface VoiceRecorder : NSObject

@property (nonatomic ,weak)id <LMZRecorderDelegate>delegate;
- (void)start;
- (void)pause;
- (void)stop;
- (void)deleteRecording;
- (NSString *)filePath;
@end

NS_ASSUME_NONNULL_END
