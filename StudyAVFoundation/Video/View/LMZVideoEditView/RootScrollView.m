//
//  RootScrollView.m
//  StudyAVFoundation
//
//  Created by 梁明哲 on 2021/1/22.
//

#import "RootScrollView.h"
@interface RootScrollView()<UIGestureRecognizerDelegate>
@end
@implementation RootScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    NSLog(@"Debug: RootScrollView gestureRecognizer");
    return NO;
}


@end
