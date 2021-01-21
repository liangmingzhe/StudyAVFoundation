//
//  LMZVideoAVPlayer.h
//  MNPlayer
//
//  Created by benjaminlmz@qq.com on 2019/10/18.
//  Copyright © 2019 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger,MN_VIDEO_STATE) {
    MN_VIDEO_STATE_PLAY  = 0,
    MN_VIDEO_STATE_PAUSE = 1,
    MN_VIDEO_STATE_STOP  = 2,
    MN_VIDEO_STATE_END   = 3
};
@protocol LMZVideoAVPlayerProtocol<NSObject>
- (void)LMZVideoAVPlayerRunning:(CGFloat)currentTime totalTime:(CGFloat)totalTime;
- (void)LMZVideoAVPlayerPlayState:(MN_VIDEO_STATE)state;
@end
NS_ASSUME_NONNULL_BEGIN

@interface LMZVideoAVPlayer : UIView
@property (nonatomic ,copy) NSString *videoUrl;
@property (nonatomic ,weak) id<LMZVideoAVPlayerProtocol>playDelegate;
@property (nonatomic ,assign) MN_VIDEO_STATE playState;
@property (nonatomic,strong) AVPlayerItem *playerItem;


@property (nonatomic,assign) CGFloat totalTime;

@property (nonatomic,assign) CGFloat currentTime;


- (id)initWithFrame:(CGRect)frame url:(NSString *)url;

- (void)play;
- (void)pause;
- (void)stop;
- (void)seekToVideoPrecent:(CGFloat)precent completionHandler:(void (^)(BOOL finished))completionHandler;


// 获取视频指定时间的封面
- (UIImage *)fetchThumbnailImageWithTime:(CMTime)time;
@end

NS_ASSUME_NONNULL_END
