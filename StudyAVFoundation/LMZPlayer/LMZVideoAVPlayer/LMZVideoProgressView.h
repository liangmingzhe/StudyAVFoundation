//
//  LMZVideoProgressView.h
//  StudyAVFoundation
//
//  Created by 梁明哲 on 2021/1/20.
//

#import <UIKit/UIKit.h>
@class LMZVideoProgressView;
NS_ASSUME_NONNULL_BEGIN
typedef  void(^ValueChanged)(float value,BOOL isfinished);

@interface LMZVideoProgressView : UIView
@property (nonatomic,assign) float duration;    //seconds
@property (nonatomic,assign) float current;     //seconds
@property (nonatomic,copy)  ValueChanged valueBlock;

@property (nonatomic,assign) float progressValue;

- (NSString *)textFormatWithValue:(float)value duration:(float)duration;
@end

NS_ASSUME_NONNULL_END
