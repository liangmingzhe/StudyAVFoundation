//
//  LMZVideoEncoder.h
//  StudyAVFoundation
//
//  Created by 梁明哲 on 2021/1/26.
//

#import <Foundation/Foundation.h>
#import <VideoToolbox/VideoToolbox.h>


@class EncodeParams;
NS_ASSUME_NONNULL_BEGIN



@protocol LMZVideoEncodeDelegate <NSObject>

- (void)videoEncodeOutputDataCallback:(NSData *)data isKeyFrame:(BOOL)isKeyFrame;

@end

@interface LMZVideoEncoder : NSObject

@property (nonatomic ,strong)EncodeParams *encodeParams;    //编码器参数
@property (nonatomic ,weak) id<LMZVideoEncodeDelegate> delegate;

- (BOOL)initEncoder;
- (BOOL)videoEncodeInputData:(CMSampleBufferRef)sampleBuffer forceKeyFrame:(BOOL)forceKeyFrame;

@end


/**
 *  @abstract   编码参数类
 *
 *
 */


typedef NS_ENUM(NSUInteger, LMZVideoEncoderProfileLevel) {
    LMZVideoEncoderProfileLevelBP,
    LMZVideoEncoderProfileLevelMP,
    LMZVideoEncoderProfileLevelHP
};

@interface EncodeParams : NSObject
/** ProfileLevel 编码等级 默认为BP */
@property (nonatomic, assign) LMZVideoEncoderProfileLevel profileLevel;
/** 编码内容的宽度 */
@property (nonatomic, assign) NSInteger encodeWidth;
/** 编码内容的高度 */
@property (nonatomic, assign) NSInteger encodeHeight;
/** 编码类型 */
@property (nonatomic, assign) CMVideoCodecType encodeType;
/** 码率 单位kbps */
@property (nonatomic, assign) NSInteger bitRate;
/** 帧率 单位为fps，缺省为15fps */
@property (nonatomic, assign) NSInteger frameRate;
/** 最大I帧间隔，单位为秒，缺省为240秒一个I帧 */
@property (nonatomic, assign) NSInteger maxKeyFrameInterval;
/** 是否允许产生B帧 缺省为NO */
@property (nonatomic, assign) BOOL allowFrameReordering;
@end
NS_ASSUME_NONNULL_END
