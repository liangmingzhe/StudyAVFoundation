//
//  LMZAudioPlayer.h
//  StudyAVFoundation
//
//  Created by 梁明哲 on 2020/12/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LMZAudioPlayer;
@protocol AudioDelegate<NSObject>

- (void)playerCurrentTime:(NSTimeInterval)time;
@end


@interface LMZAudioPlayer : NSObject

@property (nonatomic,weak)id <AudioDelegate>delegate;
- (NSTimeInterval)playerDuration;
- (NSTimeInterval)playerCurrentTime;
- (void)playerAudioWithUrl:(NSURL *)url;

- (void)stop;
- (void)uninit;
@end

NS_ASSUME_NONNULL_END
