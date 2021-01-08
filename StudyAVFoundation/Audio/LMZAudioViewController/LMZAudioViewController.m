//
//  LMZAudioViewController.m
//  StudyAVFoundation
//
//  Created by benjaminlmz@qq.com on 2021/1/7.
//

#import "LMZAudioViewController.h"
#import "LMZRecordActionView.h"
#define WIDTH    [UIScreen mainScreen].bounds.size.width
#define HEIGHT   [UIScreen mainScreen].bounds.size.height
#define kIdr    @"LMZAudioCell"

#import "LMZVoiceRecorder.h"
#import "LMZAudioPlayer.h"

#import "LMZAudioCell.h"
@interface LMZAudioViewController ()<UITableViewDelegate,UITableViewDataSource,LMZRecordActionViewDelegate,LMZRecorderDelegate,LMZRecorderDelegate,AudioDelegate>

@property (weak, nonatomic) IBOutlet UITableView *audioTableview;
@property (nonatomic,strong) NSArray<NSString *> *audioArray;
@property (nonatomic,strong)LMZRecordActionView *lmzRecordActionView;
@property (nonatomic,strong) LMZVoiceRecorder *audioRecoder;
@property (nonatomic,strong) LMZAudioPlayer *audioPlayer;


@end

@implementation LMZAudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.audioArray = @[@"录音1",@"录音2",@"录音3",@"录音4",@"录音5"];
}

- (void)setupUI {

    self.audioTableview.tableFooterView = [[UIView alloc] init];
    [self.audioTableview registerNib:[UINib nibWithNibName:@"LMZAudioCell" bundle:nil] forCellReuseIdentifier:kIdr];
    self.audioTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.lmzRecordActionView = [[[NSBundle mainBundle] loadNibNamed:@"LMZRecordActionView" owner:nil options:nil] lastObject];
    self.lmzRecordActionView.delegate = self;
    [self.lmzRecordActionView setFrame:CGRectMake(0, HEIGHT - 500, WIDTH, 500)];
    [[[[UIApplication sharedApplication] windows] lastObject] addSubview:self.lmzRecordActionView];
    
    //录音
    self.audioRecoder = [[LMZVoiceRecorder alloc] init];
    self.audioRecoder.delegate = self;
    self.audioPlayer  = [[LMZAudioPlayer alloc] init];
    self.audioPlayer.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LMZAudioCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdr forIndexPath:indexPath];
    cell.audioTitle.text = self.audioArray[indexPath.row];
    if(indexPath.row == (self.audioArray.count - 1)){
        
        [cell.bottomLine setHidden:YES];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark::LMZRecordActionViewDelegate
- (void)startRecord:(LMZRecordActionView *)object {
    [self.audioRecoder start];
}

- (void)finishRecord:(LMZRecordActionView *)object {
    [self.lmzRecordActionView setFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [self.audioRecoder stop];
}

- (void)cancelRecord:(LMZRecordActionView *)object {
    
}

- (void)btnCancelClicked:(LMZRecordActionView *)object {
    [self.lmzRecordActionView setFrame:CGRectMake(0, HEIGHT - 500, WIDTH, 500)];
}


#pragma mark::LMZRecorderDelegate



@end
