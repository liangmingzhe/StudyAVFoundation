//
//  LMZVideoProgressView.m
//  StudyAVFoundation
//
//  Created by 梁明哲 on 2021/1/20.
//

#import "LMZVideoProgressView.h"
@interface LMZVideoProgressView() {
}
@property (nonatomic,strong) UISlider *progressSlider;

@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,assign) BOOL isTouch;
@end
@implementation LMZVideoProgressView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.progressSlider = [[UISlider alloc] initWithFrame:self.bounds];
        [self addSubview:self.progressSlider];
        [self.progressSlider setThumbImage:[UIImage imageNamed:@"play_slider"] forState:UIControlStateNormal];
        [self.progressSlider addTarget:self action:@selector(valueChangedHandle) forControlEvents:UIControlEventValueChanged];
        [self.progressSlider addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];

        [self.progressSlider addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];

        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [self getWidthWithText:@"00:00/00:00" withFontOfSize:13], 30)];
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.layer.cornerRadius = 5;
        self.timeLabel.layer.masksToBounds = YES;
        self.timeLabel.layer.position = CGPointMake(0, 1);
        self.timeLabel.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.timeLabel];
        [self.timeLabel setHidden:YES];
    }
    return self;
}


- (void)valueChangedHandle {
    self.valueBlock(self.progressSlider.value,!self.isTouch);
    self.progressValue = self.progressSlider.value;
}

- (void)touchDown:(UISlider *)sender {
    
    self.isTouch = YES;
}
- (void)touchUp:(UISlider *)sender {
    self.isTouch = NO;
    self.valueBlock(self.progressSlider.value,!self.isTouch);
}


- (void)setProgressValue:(float)progressValue {
    _progressValue = progressValue;
    self.progressSlider.value = progressValue;
    
    self.timeLabel.layer.position = CGPointMake(self.progressSlider.frame.size.width * _progressValue, 1);
    _timeLabel.text = [self textFormatWithValue:self.current duration:self.duration];
}



- (void)drawRect:(CGRect)rect {
    
}

- (void)dealloc {
    
}

- (NSString *)textFormatWithValue:(float)value duration:(float)duration {
    int x = value;
    int y = duration;
    
    NSString *currentTime = @"00:00";
    NSString *totalTime = @"00:00";
    if (x < 60) {
        currentTime = [NSString stringWithFormat:@"00:%02d",x];
    } else if(x > 60 && x < 60*60){
        int xh = x/60;
        int xs = x%60;
        currentTime = [NSString stringWithFormat:@"%02d:%02d",xh,xs];
    }
    
    if (y < 60) {
        totalTime = [NSString stringWithFormat:@"00:%02d",y];
    } else if(y > 60 && y < 60*60){
        int yh = y/60;
        int ys = y%60;
        totalTime = [NSString stringWithFormat:@"%02d:%02d",yh,ys];
    }
    return [NSString stringWithFormat:@"%@/%@",currentTime,totalTime];
}


- (CGFloat)getWidthWithText:(NSString *)text withFontOfSize:(CGFloat)size {
    CGRect rect = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]}
                                     context:nil];
    return rect.size.width;
}
//void CGContextAddRoundRect(CGContextRef context,CGRect rect,CGPathDrawingMode mode,CGFloat radius){
//    float x1=rect.origin.x;
//    float y1=rect.origin.y;
//    float x2=x1+rect.size.width;
//    float y2=y1;
//    float x3=x2;
//    float y3=y1+rect.size.height;
//    float x4=x1;
//    float y4=y3;
//    CGContextMoveToPoint(context, x1, y1+radius);
//    CGContextAddArcToPoint(context, x1, y1, x1+radius, y1, radius);
//
//    CGContextAddArcToPoint(context, x2, y2, x2, y2+radius, radius);
//    CGContextAddArcToPoint(context, x3, y3, x3-radius, y3, radius);
//    CGContextAddArcToPoint(context, x4, y4, x4, y4-radius, radius);
//
//    CGContextClosePath(context);
//    CGContextDrawPath(context, mode); //根据坐标绘制路径
//}
@end
