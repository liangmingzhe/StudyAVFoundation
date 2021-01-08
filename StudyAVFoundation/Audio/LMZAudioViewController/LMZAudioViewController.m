//
//  LMZAudioViewController.m
//  StudyAVFoundation
//
//  Created by benjaminlmz@qq.com on 2021/1/7.
//

#import "LMZAudioViewController.h"
#define WIDTH    [UIScreen mainScreen].bounds.size.width
#define HEIGHT   [UIScreen mainScreen].bounds.size.height
#define kIdr    @"LMZAudioCell"
#import "LMZAudioCell.h"
@interface LMZAudioViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *audioTableview;
@property (nonatomic,strong) NSArray<NSString *> *audioArray;

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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LMZAudioCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdr forIndexPath:indexPath];
    cell.audioTitle.text = self.audioArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
