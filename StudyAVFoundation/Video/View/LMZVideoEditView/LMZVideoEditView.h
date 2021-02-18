//
//  LMZVideoEditView.h
//  VideoEdit
//
//  Created by benjaminlmz@qq.com on 2021/1/22.
//

#import <UIKit/UIKit.h>
#import "EditHeadView.h"
#import "EditMiddleView.h"
#import "EditTailView.h"
#import "LMZRailCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface LMZVideoEditView : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet EditHeadView *headerView;
@property (weak, nonatomic) IBOutlet EditMiddleView *middleView;
@property (weak, nonatomic) IBOutlet EditTailView *tailView;


@property (weak, nonatomic) IBOutlet UIView *videoBar;

@property (weak, nonatomic) IBOutlet UITableView *railTableView;


@property (weak, nonatomic) IBOutlet UIScrollView       *rootScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tailViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@end

NS_ASSUME_NONNULL_END
