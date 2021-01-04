//
//  AudioFileListViewController.m
//  StudyAVFoundation
//
//  Created by 梁明哲 on 2021/1/3.
//

#import "AudioFileListViewController.h"
#define kAudioFileCell @"AudioFileCell"
@interface AudioFileListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic ,strong) UITableView *fileTableView;
@property (nonatomic ,strong) NSMutableArray *audioArray;
@property (nonatomic ,strong) NSString *documentPath;
@end

@implementation AudioFileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self checkSandBox];
    [self setupUI];
}

- (void)checkSandBox {
    self.audioArray = [NSMutableArray array];
    self.documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager * fileManger = [NSFileManager defaultManager];
    NSArray *dirArray = [fileManger contentsOfDirectoryAtPath:self.documentPath error:nil];
    NSString * subPath = nil;
    for (NSString * str in dirArray) {
        subPath  = [self.documentPath stringByAppendingPathComponent:str];
        if ([str hasSuffix:@".caf"]|| [str hasSuffix:@".mp3"]||[str hasSuffix:@".m4a"]) {
            [self.audioArray addObject:str];
        }
    }
    NSLog(@"");
}
- (void)setupUI {
    self.fileTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.fileTableView.dataSource = self;
    self.fileTableView.delegate = self;
    [self.view addSubview:self.fileTableView];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAudioFileCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kAudioFileCell];
    }
    cell.textLabel.text = self.audioArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectFile([NSString stringWithFormat:@"%@%@",self.documentPath,self.audioArray[indexPath.row]], YES);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.audioArray.count;
}
@end
