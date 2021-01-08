//
//  LMZRecordActionView.m
//  StudyAVFoundation
//
//  Created by benjaminlmz@qq.com on 2021/1/8.
//

#import "LMZRecordActionView.h"
@interface LMZRecordActionView()

@property (weak, nonatomic) IBOutlet UIView *popBackView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UISlider *progressView;
@property (weak, nonatomic) IBOutlet UILabel *audioTimeLabel;


@property (nonatomic ,strong)UILongPressGestureRecognizer *longPressRecognizer;
@end
@implementation LMZRecordActionView
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
    self.longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(recordAudioHandle:)];
    [self.recordButton addGestureRecognizer:self.longPressRecognizer];
    
}
- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setupUI {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.popBackView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.popBackView.bounds;
    self.popBackView.backgroundColor = [UIColor whiteColor];
    maskLayer.path = path.CGPath;
    self.popBackView.layer.mask = maskLayer;
    self.popBackView.userInteractionEnabled = NO;
}
- (void)recordAudioHandle:(UIGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"UIGestureRecognizerStateBegan");
        if ([self.delegate respondsToSelector:@selector(startRecord:)]) {
            [self.delegate startRecord:self];
        }
        self.recordState = ReocordStateStart;
    }
    if (sender.state == UIGestureRecognizerStateCancelled) {
        NSLog(@"UIGestureRecognizerStateCancel");
        if ([self.delegate respondsToSelector:@selector(cancelRecord:)]) {
            [self.delegate cancelRecord:self];
        }
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnd");
        if ([self.delegate respondsToSelector:@selector(finishRecord:)]) {
            [self.delegate finishRecord:self];
        }
        self.recordState = ReocordStateEdit;
    }
}
- (void)setRecordState:(ReocordState)recordState {
    _recordState = recordState;
    if (recordState == ReocordStateEdit) {
        [self.recordText setHidden:YES];
        [self.recordButton setImage:[UIImage imageNamed:@"alert_btn_play"] forState:UIControlStateNormal];
        [self.bkView setHidden:NO];
        [self.popBackView setHidden:NO];
        [self.cancelBtn setHidden:NO];
        [self.finishBtn setHidden:NO];
    }
    else if(recordState == ReocordStateStart) {
        [self.bkView setHidden:NO];
        [self.popBackView setHidden:NO];
        [self.cancelBtn setHidden:NO];
        [self.finishBtn setHidden:NO];
        [self.recordButton setImage:[UIImage imageNamed:@"alert_btn_stop"] forState:UIControlStateNormal];
        [self.recordText setHidden:YES];
    }
    else if(recordState == ReocordStateReady) {
        [self.bkView setHidden:YES];
        [self.popBackView setHidden:YES];
        [self.cancelBtn setHidden:YES];
        [self.finishBtn setHidden:YES];
        
        [self.recordText setHidden:NO];
        [self.recordButton setImage:[UIImage imageNamed:@"alert_btn_start"] forState:UIControlStateNormal];
        
        
    }
}

- (void)setPlaySeconds:(float)playSeconds {
    _playSeconds = playSeconds;
    self.progressView.value = playSeconds/15;
    self.audioTimeLabel.text = [NSString stringWithFormat:@"00:%0f/00:15",_playSeconds];
}

- (IBAction)cancelClicked:(id)sender {
    self.recordState = ReocordStateReady;
    if ([self.delegate respondsToSelector:@selector(btnCancelClicked:)]) {
        [self.delegate btnCancelClicked:self];
    }
}

- (IBAction)playClicked:(id)sender {
    
}

- (IBAction)finishClicked:(id)sender {
    self.recordState = ReocordStateReady;
}

@end
