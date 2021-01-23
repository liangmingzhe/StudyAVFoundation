//
//  LMZSandBoxFileManager.m
//  StudyAVFoundation
//
//  Created by benjaminlmz@qq.com on 2021/1/23.
//

#import "LMZSandBoxFileManager.h"
@class LMZFileModel;
@interface LMZSandBoxFileManager ()
@property (nonatomic ,strong)   NSFileManager   *fileManager;
@property (nonatomic ,copy)     NSString        *doMainPath;
@end
@implementation LMZSandBoxFileManager
static LMZSandBoxFileManager *manager;

+ (void)load {
    if (manager == nil) {
        manager = [[LMZSandBoxFileManager alloc] init];
    }
}

+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[LMZSandBoxFileManager alloc] init];
        }
    });
    return manager;
}

- (id)init {
    self = [super init];
    if (self) {
        self.fileManager = [NSFileManager defaultManager];
       self.doMainPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    }
    return self;
}


//---一些无聊的功能
/**
 *  @abstract 修改沙盒中文件的名字。不带后缀，只改名字不改扩展名
 *  @param  filePath            原文件路径
 *  @param  newName              新文件名(不带扩展名)
 *  @param  actionBlock     修改结果    fileModel 文件模型 state : 1 修改成功，0 修改失败   -1 新文件名在目录下已存在  -2 原文件路径为空  -3 新文件名为空 -4 路径下找不带原文件 -5 文件重名   -6 转换失败
 *
 *  @author 梁明者
 *  @date   2021-01-23
 */
+ (void)modifyFileNameWithFilePath:(NSString *)filePath
                           newName:(NSString *)newName
                       actionBlock:(void(^)(int state,LMZFileModel * _Nullable fileModel))actionBlock {
    if ([[LMZSandBoxFileManager sharedInstance] isEmptyOrNil:filePath]) {
        //文件路径或者新名称为nil或为空,直接返回
        actionBlock(-2,nil);
        return;
    }
    if ([[LMZSandBoxFileManager sharedInstance] isEmptyOrNil:filePath]) {
        actionBlock(-3,nil);
        return;

    }
    
    LMZFileModel *fileModel = [[LMZFileModel alloc] init];
    BOOL isExist = [[[LMZSandBoxFileManager sharedInstance] fileManager] fileExistsAtPath:filePath];
    if (isExist == YES) {
        NSString *newPath = [filePath mutableCopy];
        NSString * oldName = [[filePath lastPathComponent] stringByDeletingPathExtension];  //原文件名无扩展名
        
        //旧文件名和新文件名是否重名，如果是重名的直接返回成功无须判断
        if (![oldName isEqualToString:newName]) {
            newPath = [newPath stringByReplacingOccurrencesOfString:oldName withString:newName];
            BOOL isNewPathExist = [[[LMZSandBoxFileManager sharedInstance] fileManager] fileExistsAtPath:newPath];  //新文件名不可以和路径下的文件重名
            if(isNewPathExist == YES) {
                actionBlock(-5,nil);
                return;
            }
            
            NSError *error = nil;
            [[[LMZSandBoxFileManager sharedInstance] fileManager] moveItemAtPath:filePath toPath:newPath error:&error]; //yon
            if (error != nil) {
                //如果转换时发生了错误直接返回失败
                actionBlock(-6,nil);
                return;
            }
        }
        
        fileModel.fileName = [newPath stringByDeletingPathExtension];  //文件名,无扩展名
        fileModel.fileType = [newPath pathExtension];                  //文件类型
        fileModel.filePath = newPath;                                  //文件类型
        actionBlock(YES,fileModel);
    }else {
        actionBlock(-4,nil);
    }
}

/**
 *  @abstract 查询某个文件夹路径下某个类型的文件列表
 *  @param  dirPath     文件夹路径
 *  @param  fileType   文件类型
 *  @return 返回泛型数组包含文件文件
 *
 */
+ (NSArray <LMZFileModel *>*)seekFileWithTargetDirPath:(NSString * _Nullable)dirPath fileType:(NSString *)fileType {
    
    NSMutableArray *fileArray = [NSMutableArray array];
    NSError *error = nil;
    
    NSArray *allFileArray = [[[LMZSandBoxFileManager sharedInstance] fileManager] contentsOfDirectoryAtPath:[[LMZSandBoxFileManager sharedInstance] doMainPath] error:&error];  //目录下所有文件
    if (error != nil) {
        return fileArray;
    }
    [allFileArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *exestr = [obj pathExtension];
        if([exestr isEqualToString:fileType]){
            LMZFileModel *fileModel = [[LMZFileModel alloc] init];
            fileModel.fileName = [obj stringByDeletingPathExtension];
            fileModel.fileType = exestr;
            fileModel.filePath = [NSString stringWithFormat:@"%@/%@",dirPath==nil || [dirPath isEqualToString:@""]?[[LMZSandBoxFileManager sharedInstance] doMainPath]:dirPath,obj];
            [fileArray addObject:[fileModel mutableCopy]];
            fileModel = nil;
        }
    }];
    
    return fileArray;
}


- (BOOL)isEmptyOrNil:(NSString *)string {
    if (string == nil || [string isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

@end


@implementation LMZFileModel

- (id)mutableCopyWithZone:(NSZone *)zone {
    LMZFileModel *cp = [[self.class allocWithZone:zone] init];
    cp.fileName = self.fileName;
    cp.fileType = self.fileType;
    cp.filePath = self.filePath;
    return cp;
}
@end
