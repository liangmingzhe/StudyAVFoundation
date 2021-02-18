//
//  LMZVideoEditView.m
//  VideoEdit
//
//  Created by benjaminlmz@qq.com on 2021/1/22.
//

#import "LMZVideoEditView.h"
#import <Masonry/Masonry.h>
#define kLMZRailCell @"LMZRailCell"
@interface LMZVideoEditView()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@end
@implementation LMZVideoEditView

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self addSubview:self.view];
        [self.railTableView registerNib:[UINib nibWithNibName:@"LMZRailCell" bundle:nil] forCellReuseIdentifier:kLMZRailCell];
        [self.railTableView reloadData];
        self.headViewWidthConstraint.constant = [UIScreen mainScreen].bounds.size.width*0.5;
        self.tailViewWidthConstraint.constant = [UIScreen mainScreen].bounds.size.width*0.5;
        self.widthConstraint.constant = self.headViewWidthConstraint.constant + self.tailViewWidthConstraint.constant + [UIScreen mainScreen].bounds.size.width;
    }
    return self;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint point = [scrollView contentOffset];

    NSLog(@"");

}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
}



#pragma mark ========== tableView 代理 ==========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LMZRailCell *cell = [tableView dequeueReusableCellWithIdentifier:kLMZRailCell];
    if (cell == nil) {
        
    }
    return cell;
}


- (UIView *)view {
    if (!_view) {
        _view = [[NSBundle mainBundle] loadNibNamed:@"LMZVideoEditView" owner:self options:nil].lastObject;
    }
    return _view;
}

@end
