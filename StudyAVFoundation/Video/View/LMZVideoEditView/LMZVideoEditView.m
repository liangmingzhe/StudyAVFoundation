//
//  LMZVideoEditView.m
//  VideoEdit
//
//  Created by benjaminlmz@qq.com on 2021/1/22.
//

#import "LMZVideoEditView.h"
#import "EditHeadView.h"
#import "EditMiddleView.h"
#import "EditTailView.h"
#import "LMZRailCell.h"
#import <Masonry/Masonry.h>
#define kLMZRailCell @"LMZRailCell"
@interface LMZVideoEditView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet EditHeadView *headerView;
@property (weak, nonatomic) IBOutlet EditMiddleView *middleView;
@property (weak, nonatomic) IBOutlet EditTailView *tailView;


@property (strong, nonatomic) UITableView *railTableView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tailViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;

@end


@implementation LMZVideoEditView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.railTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    [self.railTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LMZRailCell class]) bundle:nil] forCellReuseIdentifier:kLMZRailCell];
    [self addSubview:self.railTableView];
    
    [self.railTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_right);
        make.right.equalTo(self.tailView.mas_left);
        make.bottom.equalTo(self);
//        make.top.equalTo();
    }];
    self.railTableView.delegate = self;
    self.railTableView.dataSource = self;
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LMZRailCell *cell = [tableView dequeueReusableCellWithIdentifier:kLMZRailCell];
    if (cell == nil) {
        cell = [[LMZRailCell alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 10)];
        cell.backgroundColor = [UIColor redColor];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
