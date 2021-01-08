//
//  LMZRoundButton.m
//  StudyAVFoundation
//
//  Created by benjaminlmz@qq.com on 2021/1/8.
//

#import "LMZRoundButton.h"

@implementation LMZRoundButton

- (id)initRoundBtnWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = frame.size.width / 2;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setBkColor:(UIColor *)bkColor {
    _bkColor = bkColor;
    self.backgroundColor = bkColor;
}
- (void)setTexColor:(UIColor *)texColor {
    _texColor = texColor;
}
@end
