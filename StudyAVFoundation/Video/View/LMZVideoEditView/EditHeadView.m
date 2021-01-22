//
//  EditHeadView.m
//  VideoEdit
//
//  Created by benjaminlmz@qq.com on 2021/1/22.
//

#import "EditHeadView.h"

@implementation EditHeadView


- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [UIColor darkGrayColor];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
