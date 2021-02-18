//
//  OpenGLESPlayerView.h
//  StudyAVFoundation
//
//  Created by 梁明哲 on 2021/1/28.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface OpenGLESPlayerView : CAEAGLLayer

- (id)initWithFrame:(CGRect)frame;

- (void)displayWithPixelBuffer:(CVPixelBufferRef)pixelBuffer;
@end

NS_ASSUME_NONNULL_END
