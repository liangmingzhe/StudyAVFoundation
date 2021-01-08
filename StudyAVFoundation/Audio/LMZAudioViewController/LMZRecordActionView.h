//
//  LMZRecordActionView.h
//  StudyAVFoundation
//
//  Created by benjaminlmz@qq.com on 2021/1/8.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ReocordState){
    ReocordStateReady = 0,
    ReocordStateStart = 1,
    ReocordStateEdit  = 2
};

@class LMZRecordActionView;

@protocol LMZRecordActionViewDelegate<NSObject>
- (void)startRecord:(LMZRecordActionView *_Nullable)object;
- (void)cancelRecord:(LMZRecordActionView *_Nullable)object;
- (void)finishRecord:(LMZRecordActionView *_Nullable)object;


- (void)btnCancelClicked:(LMZRecordActionView *_Nullable)object;
- (void)btnPlayClicked:(LMZRecordActionView *_Nullable)object;
- (void)btnFinishClicked:(LMZRecordActionView *_Nullable)object;
@end

NS_ASSUME_NONNULL_BEGIN

@interface LMZRecordActionView : UIView
@property (weak, nonatomic) IBOutlet UIView *bkView;
@property (weak, nonatomic) IBOutlet UILabel *recordText;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;

@property (assign,nonatomic) float playSeconds;
@property (weak ,nonatomic)id<LMZRecordActionViewDelegate>delegate;

@property (assign ,nonatomic) ReocordState recordState;
@end

NS_ASSUME_NONNULL_END
