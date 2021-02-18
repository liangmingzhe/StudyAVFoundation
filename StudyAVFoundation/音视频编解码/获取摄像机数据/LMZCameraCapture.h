//
//  LMZCameraCapture.h
//  StudyAVFoundation
//
//  Created by 梁明哲 on 2021/1/25.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@protocol LMZCameraCaptureDelegate<NSObject>
- (void)videoCaptureOutputCallBack:(CMSampleBufferRef)sampleBuffer;
@end
NS_ASSUME_NONNULL_BEGIN

@interface LMZCameraCapture : NSObject
@property (nonatomic ,weak) id<LMZCameraCaptureDelegate>delegate;

- (void)run;
@end

NS_ASSUME_NONNULL_END
