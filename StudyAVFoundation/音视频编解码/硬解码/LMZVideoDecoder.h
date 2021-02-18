//
//  LMZVideoDecoder.h
//  StudyAVFoundation
//
//  Created by 梁明哲 on 2021/1/26.
//

#import <Foundation/Foundation.h>
#import <VideoToolbox/VideoToolbox.h>

@protocol H264DecoderDelegate <NSObject>

/** H264解码数据回调 */
- (void)videoDecodeOutputDataCallback:(CVImageBufferRef _Nullable )imageBuffer;

@end

NS_ASSUME_NONNULL_BEGIN

@interface LMZVideoDecoder : NSObject
@property (weak, nonatomic) id<H264DecoderDelegate> delegate;

- (void)decodeNaluData:(NSData *)naluData;
@end

NS_ASSUME_NONNULL_END
