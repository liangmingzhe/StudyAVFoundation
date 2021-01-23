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
#import "RailTableView.h"
#import "RootScrollView.h"
NS_ASSUME_NONNULL_BEGIN

@interface LMZVideoEditView : UIView
@property (weak, nonatomic) IBOutlet EditHeadView *headerView;
@property (weak, nonatomic) IBOutlet EditMiddleView *middleView;
@property (weak, nonatomic) IBOutlet EditTailView *tailView;


@property (weak, nonatomic) IBOutlet UIView *videoBar;

@property (strong, nonatomic) RailTableView *railTableView;

@end

NS_ASSUME_NONNULL_END
