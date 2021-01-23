//
//  LMZLog.m
//  StudyAVFoundation
//
//  Created by benjaminlmz@qq.com on 2021/1/23.
//

#import "LMZLog.h"
@interface LMZLog()

@end
@implementation LMZLog

static LMZLog *lmzLog;

+ (void)load {
    if (lmzLog == nil) {
        lmzLog = [[LMZLog alloc] init];
    }
}

// 单例类方法
+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (lmzLog == nil) {
            lmzLog = [[LMZLog alloc] init];
        }
    });
    return lmzLog;
}


// 沙盒文件查询
- (void)seekAllFileCache {
    
}

/**
 *  操作记录:
 *  1.程序运行后检查文件，路径下文件是否存在:如果不存在就创建一个Plist文件
 *  2.日志写入功能：
 *  3.日志查询功能：将所有操作根据时间进行倒序排列 提供一个入口设置日志的长度默认500条。给出一个分页参数（50条）
 *  4.日志分享功能
 */

//
@end
