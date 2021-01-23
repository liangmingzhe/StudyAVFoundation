//
//  RailTableView.m
//  StudyAVFoundation
//
//  Created by 梁明哲 on 2021/1/22.
//

#import "RailTableView.h"
@interface RailTableView ()<UIGestureRecognizerDelegate>

@end
@implementation RailTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.bounces = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    NSLog(@"Debug: RailTableView gestureRecognizer");
//    return YES;
//}
@end
