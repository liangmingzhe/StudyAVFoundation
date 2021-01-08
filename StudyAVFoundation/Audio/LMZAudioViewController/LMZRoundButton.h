//
//  LMZRoundButton.h
//  StudyAVFoundation
//
//  Created by benjaminlmz@qq.com on 2021/1/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMZRoundButton : UIButton
@property (nonatomic,copy) UIColor *bkColor;
@property (nonatomic,copy) UIColor *texColor;

- (id)initRoundBtnWithFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
