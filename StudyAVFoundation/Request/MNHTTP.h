//
//  MNHTTP.h
//  StudyAVFoundation
//
//  Created by benjaminlmz@qq.com on 2021/1/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MNHTTP : NSObject
//登录
+ (void)loginWithUser:(NSString *)usr pwd:(NSString *)pwd block:(void (^)(id dic))block;

//上传报警音频
+ (void)uploadMp3File:(NSString *)path block:(void (^)(id dic))block;

//查询报警音频
+ (void)fetchMp3List:(void (^)(id dic))block;

//设置报警音频
+ (void)setToneWithSN:(NSString *)sn block:(void (^)(id dic))block;

//删除音频
+ (void)deleteToneWithIds:(NSArray *)ids block:(void (^)(id dic))block;
@end

NS_ASSUME_NONNULL_END
