//
//  ViewController.m
//  StudyAVFoundation
//
//  Created by benjaminlmz@qq.com on 2020/10/10.
//

#import "ViewController.h"
#import "FunctionCell.h"
#import "VideoViewController.h"
#import "AudioViewController.h"
#import "LMZAudioViewController.h"
#import "LMZSandBoxFileManager.h"


#define kFunctionCellID @"FunctionCell"
#define kWidth   [UIScreen mainScreen].bounds.size.width
#define kHeight  [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource> {
    NSArray *itemArray;
}
@property (nonatomic ,strong) UICollectionView *functionCollectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupData];
    [self setupUI];
    NSArray<LMZFileModel *> *file = [LMZSandBoxFileManager seekFileWithTargetDirPath:@"" fileType:@"mp3"];
    NSLog(@"%@",file);
    [LMZSandBoxFileManager modifyFileNameWithFilePath:file[0].filePath newName:@"王母娘娘" actionBlock:^(int state, LMZFileModel * _Nullable fileModel) {
        NSLog(@"");
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)setupUI {
    self.title = @"AVFoundation";
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.functionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:layout];
    self.functionCollectionView.backgroundColor = [UIColor whiteColor];
    self.functionCollectionView.delegate = self;
    self.functionCollectionView.dataSource = self;
    [self.view addSubview:self.functionCollectionView];
    [self.functionCollectionView registerNib:[UINib nibWithNibName:@"FunctionCell" bundle:nil] forCellWithReuseIdentifier:kFunctionCellID];
    [self.functionCollectionView reloadData];
}


- (void)setupData {
    itemArray = @[
    @{@"title":@"音频",@"icon":@"audio"},
    @{@"title":@"视频",@"icon":@"video"},
    @{@"title":@"图片",@"icon":@"image"},
    @{@"title":@"日志",@"icon":@"txt"}];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FunctionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFunctionCellID forIndexPath:indexPath];
    cell.title.text = [itemArray[indexPath.row] valueForKey:@"title"];
    cell.icon.image = [UIImage imageNamed:[itemArray[indexPath.row] valueForKey:@"icon"]];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return itemArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake(kWidth /3,100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, (itemArray.count / 3 - 2) * kWidth / 3, 0);//（上、左、下、右）
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        AudioViewController *vc = [[AudioViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row == 1) {
        VideoViewController *vc = [[VideoViewController alloc] init];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }else {
        LMZAudioViewController *vc = [[LMZAudioViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

@end
