//
//  LMZAudioViewController.m
//  StudyAVFoundation
//
//  Created by benjaminlmz@qq.com on 2021/1/7.
//

#import "LMZAudioViewController.h"
#define WIDTH    [UIScreen mainScreen].bounds.size.width
#define HEIGHT   [UIScreen mainScreen].bounds.size.height
#define kIdr    @"audio_cell"
@interface LMZAudioViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *audioTableview;
@end

@implementation LMZAudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.audioTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    self.audioTableview.delegate = self;
    self.audioTableview.dataSource = self;
    [self.view addSubview:self.audioTableview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kIdr];
    return cell;
}


@end
