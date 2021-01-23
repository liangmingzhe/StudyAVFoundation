//
//  LMZSandBoxFileManager.h
//  StudyAVFoundation
//
//  Created by benjaminlmz@qq.com on 2021/1/23.
//

#import <Foundation/Foundation.h>
@class LMZFileModel;
NS_ASSUME_NONNULL_BEGIN

@interface LMZSandBoxFileManager : NSObject

/**
 *  @abstract 文件管理单例
 *  @return 返回单例对象
 *
 *  @date   2021-01-23
 *  @author 梁明哲
 */
+ (id)sharedInstance;



/**
 *  @abstract 修改沙盒中文件的名字。不带后缀，只改名字不改扩展名
 *  @param  filePath            原文件路径
 *  @param  newName              新文件名(不带扩展名)
 *  @param  actionBlock     修改结果    fileModel 文件模型 state : 1 修改成功，0 修改失败   -1 新文件名在目录下已存在  -2 原文件路径为空  -3 新文件名为空 -4 路径下找不带原文件 -5 文件重名   -6 转换失败
 *
 *  @author 梁明者
 *  @date   2021-01-23
 */
+ (void)modifyFileNameWithFilePath:(NSString *)filePath newName:(NSString *)newName actionBlock:(void(^)(int state,LMZFileModel * _Nullable fileModel))actionBlock;

/**
 *  @abstract 查询某个文件夹路径下某种类型的文件列表
 *  @param  dirPath     文件夹路径
 *  @param  fileType   文件类型
 *  @return 返回泛型数组包含文件文件
 *
 *  @date   2021-01-23
 *  @author 梁明哲
 */
+ (NSArray <LMZFileModel *>*)seekFileWithTargetDirPath:(NSString * _Nullable)dirPath fileType:(NSString *)fileType;
@end


@interface LMZFileModel: NSObject <NSMutableCopying>
@property (nonatomic ,copy) NSString *fileName;
@property (nonatomic ,copy) NSString *filePath;
@property (nonatomic ,copy) NSString *fileType;
@end





NS_ASSUME_NONNULL_END
