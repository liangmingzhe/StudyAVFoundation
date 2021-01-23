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

@property (weak, nonatomic) IBOutlet RootScrollView *rootScrollView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tailViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;

@end


@implementation LMZVideoEditView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    _rootScrollView.delegate = self;
    self.railTableView = [[RailTableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    self.railTableView.delegate = self;
    self.railTableView.dataSource = self;
    [self.railTableView registerNib:[UINib nibWithNibName:@"LMZRailCell" bundle:nil] forCellReuseIdentifier:kLMZRailCell];
    [self.rootScrollView addSubview:self.railTableView];
    
    [self.railTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_right);
        make.right.equalTo(self.tailView.mas_left);
        make.bottom.equalTo(self);
        make.top.equalTo(self.videoBar.mas_bottom);
    }];
    [self.railTableView reloadData];
    

}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
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

@end
