//
//  LMZVoiceRecorder.h
//  StudyAVFoundation
//
//  Created by 梁明哲 on 2020/12/31.
//

#import <Foundation/Foundation.h>
@class LMZVoiceRecorder;

NS_ASSUME_NONNULL_BEGIN
@protocol LMZRecorderDelegate <NSObject>

- (void)audioRecorderDidFinishRecording:(LMZVoiceRecorder *)recorder successfully:(BOOL)flag;

@end

typedef void (^MP3Block)(NSString * _Nullable errorInfo);

@interface LMZVoiceRecorder : NSObject

@property (nonatomic ,weak)id <LMZRecorderDelegate>delegate;
- (void)start;
- (void)pause;
- (void)stop;
- (void)deleteRecording;
- (NSString *)filePath;
- (void)saveWithName:(NSString *)fileName;

/**
 * @brief:将文件格式转换成mp3
 */
- (void)convertToMp3File:(NSString *)filePath targetPath:(NSString *)targetPath withBlock:(MP3Block)block;

@end

NS_ASSUME_NONNULL_END
