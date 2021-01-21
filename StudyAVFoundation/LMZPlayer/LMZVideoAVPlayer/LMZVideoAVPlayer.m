//
//  LMZVideoAVPlayer.m
//  MNPlayer
//
//  Created by benjaminlmz@qq.com on 2019/10/18.
//  Copyright © 2019 Tony. All rights reserved.
//

#import "LMZVideoAVPlayer.h"

@interface LMZVideoAVPlayer(){
    CMTime time;
    BOOL isFirstPlay;
}
@property (nonatomic,strong) AVPlayer   *mAvPlayer;
@property (nonatomic,strong) AVURLAsset *avURLAsset;
@property (nonatomic,strong) AVAssetImageGenerator *generator;
@end
@implementation LMZVideoAVPlayer

- (id)init {
    self = [super init];
    if (self) {
        isFirstPlay = YES;
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame url:(NSString *)url{
    self = [super initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    if (self) {
        _videoUrl = url;
        [self initPlayerWithFrame:frame];
        [self addProgressObserver];
        isFirstPlay = NO;
    }
    return self;
}

- (void)initPlayerWithFrame:(CGRect)frame{
    NSURL* url = [NSURL URLWithString:_videoUrl];
    self.playerItem = [AVPlayerItem playerItemWithURL:url];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    self.mAvPlayer = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    AVPlayerLayer* layer = [AVPlayerLayer playerLayerWithPlayer:_mAvPlayer];
    
    layer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    time = kCMTimeZero;
    _currentTime = (CGFloat)time.value/time.timescale;//得到当前的播放时
    _totalTime = (CGFloat)(self.mAvPlayer.currentItem.asset.duration.value / self.mAvPlayer.currentItem.asset.duration.timescale);
    
    NSLog(@"time:%f",_totalTime);
    
    //6.添加到控制器的view的图层上面
    [self.layer addSublayer:layer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideoFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_mAvPlayer.currentItem];
}
- (void)addProgressObserver {
    __weak typeof(self) weakSelf = self;
    __block CGFloat currentTime;
    __block CGFloat totalTime;
    [self.mAvPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        currentTime = CMTimeGetSeconds(time);
        totalTime = CMTimeGetSeconds([weakSelf.mAvPlayer.currentItem duration]);
        if ([weakSelf.playDelegate respondsToSelector:@selector(LMZVideoAVPlayerRunning:totalTime:)]) {
            [weakSelf.playDelegate LMZVideoAVPlayerRunning:currentTime totalTime:totalTime];
        }
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        switch(status){
                case AVPlayerStatusUnknown:
                    NSLog(@"未知错误:%@", playerItem.error);
                    
                    break;
                case AVPlayerStatusReadyToPlay:
                    NSLog(@"准备播放");
                    
                    break;
                case AVPlayerStatusFailed:
                    NSLog(@"播放失败:%@", playerItem.error);
                    break;
                default:
                break;
        }
    } else {
        NSArray *array = playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;;
        NSLog(@"缓存总时长：%0.2f", totalBuffer);
    }
}


/**
 * @brief 视频播放结束
 */
- (void)playVideoFinished:(NSNotification *) notification {
    time = kCMTimeZero;
    [_mAvPlayer seekToTime:time];
    if ([self.playDelegate respondsToSelector:@selector(LMZVideoAVPlayerPlayState:)]) {
        [self.playDelegate LMZVideoAVPlayerPlayState:MN_VIDEO_STATE_END];
    }
}

- (void)play {
    if (isFirstPlay == YES) {
        isFirstPlay = NO;
        [self initPlayerWithFrame:self.bounds];
        [self addProgressObserver];
    }
    [_mAvPlayer play];
    self.playState = MN_VIDEO_STATE_PLAY;
    if ([self.playDelegate respondsToSelector:@selector(LMZVideoAVPlayerPlayState:)]) {
        [self.playDelegate LMZVideoAVPlayerPlayState:MN_VIDEO_STATE_PLAY];
    }
}

- (void)pause {
    [_mAvPlayer pause];
    
//    time = [_mAvPlayer currentTime];
    
    self.playState = MN_VIDEO_STATE_PAUSE;
    
    if ([self.playDelegate respondsToSelector:@selector(LMZVideoAVPlayerPlayState:)]) {
        [self.playDelegate LMZVideoAVPlayerPlayState:MN_VIDEO_STATE_PAUSE];
    }

}

- (void)stop {
    [_mAvPlayer pause];
    time = kCMTimeZero;
    self.playState = MN_VIDEO_STATE_STOP;
    if ([self.playDelegate respondsToSelector:@selector(LMZVideoAVPlayerPlayState:)]) {
        [self.playDelegate LMZVideoAVPlayerPlayState:MN_VIDEO_STATE_STOP];
    }
}

- (void)seekToVideoPrecent:(CGFloat)precent completionHandler:(void (^)(BOOL finished))completionHandler{
    if ([[self.mAvPlayer.currentItem.asset tracksWithMediaType:AVMediaTypeVideo] count] == 0) {
        return;
    }
    float fps = [[[self.mAvPlayer.currentItem.asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] nominalFrameRate];
    
    CMTime time = CMTimeMakeWithSeconds(CMTimeGetSeconds(self.mAvPlayer.currentItem.duration) * precent, fps);
    [self.mAvPlayer seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        self.playState = MN_VIDEO_STATE_PLAY;
        completionHandler(finished);
    }];
}


// 抓取视频封面
- (UIImage *)fetchThumbnailImageWithTime:(CMTime)time {
    if (self.avURLAsset == nil) {
        self.avURLAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:_videoUrl] options:nil];
    }
    if (self.generator == nil) {
        self.generator = [[AVAssetImageGenerator alloc] initWithAsset:self.avURLAsset];
        self.generator.appliesPreferredTrackTransform = YES;
    }
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [self.generator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}
@end
