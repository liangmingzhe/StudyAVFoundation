//
//  MNHTTP.m
//  StudyAVFoundation
//
//  Created by benjaminlmz@qq.com on 2021/1/4.
//

#import "MNHTTP.h"
#import "Request.h"
#import "MNSingleton.h"
@implementation MNHTTP
+ (void)loginWithUser:(NSString *)usr pwd:(NSString *)pwd block:(void (^)(id dic))block{
    Request *rq = [[Request alloc] init];
    [rq setParameter:@"app_key" value:@"8Wa227sQ00S33p4y"];
    [rq setParameter:@"app_secret" value:@"RlA8aCPlsuATT227kKTg003ncP35HYRI"];
    
    [rq setParameter:@"username" value:usr];
    [rq setParameter:@"password" value:pwd];
    [rq setParameter:@"area_code" value:@"TE"];
    [rq setParameter:@"app_type" value:@"iOS"];
    [Request Post:@"https://restts.bullyun.com/api/v1/users/signin" outTime:15 success:^(id success) {
        if ([success[@"code"] intValue] == 2000) {
            [MNSingleton sharedInstance].token = success[@"access_token"];
            [MNSingleton sharedInstance].usr_id = [success[@"user_id"] longLongValue];
        }
        block(success);
    } failure:^(NSError *error) {
        block(error);
    }];
}


// mp3 增
+ (void)uploadMp3File:(NSString *)path block:(void (^)(id dic))block{
    NSData *data = [NSData dataWithContentsOfFile:path];
    Request *rq = [[Request alloc] init];
    [rq setHeader:@"app_key" value:@"8Wa227sQ00S33p4y"];
    [rq setHeader:@"app_secret" value:@"RlA8aCPlsuATT227kKTg003ncP35HYRI"];
    [rq setHeader:@"access_token" value:[MNSingleton sharedInstance].token];
    [rq setParameter:@"name" value:@"ljks"];
    [rq setParameter:@"language" value:@"zh_CN"];
    
    [Request Post:@"https://restts.bullyun.com/api/v3/warning_tone/upload" filePathData:data success:^(id success) {
        NSLog(@"");
        block(success);
    } failure:^(NSError *error) {
        NSLog(@"");
        block(error);
    }];
}

//mp3 查
+ (void)fetchMp3List:(void (^)(id dic))block {
    Request *rq = [[Request alloc] init];
    [rq setHeader:@"app_key" value:@"8Wa227sQ00S33p4y"];
    [rq setHeader:@"app_secret" value:@"RlA8aCPlsuATT227kKTg003ncP35HYRI"];
    [rq setHeader:@"access_token" value:[MNSingleton sharedInstance].token];
    [rq setParameter:@"sn" value:@"MDAhAQEAbGUwMDUzMDAwMDI1YQAA"];
    [rq setParameter:@"page_no" number:@0];
    [rq setParameter:@"page_size" number:@10];
    [Request GET:@"https://restts.bullyun.com/api/v3/warning_tone/list" outTime:15 success:^(id success) {
        NSLog(@"");
        block(success);
    } failure:^(NSError *error) {
        NSLog(@"");
        block(error);
    }];
}

//mp3 删
+ (void)delete:(void (^)(id dic))block {
    Request *rq = [[Request alloc] init];
    [rq setHeader:@"app_key" value:@"8Wa227sQ00S33p4y"];
    [rq setHeader:@"app_secret" value:@"RlA8aCPlsuATT227kKTg003ncP35HYRI"];
    [rq setHeader:@"access_token" value:[MNSingleton sharedInstance].token];
    [rq setParameter:@"sn" value:@"MDAhAQEAbGUwMDUzMDAwMDI1YQAA"];
    [rq setParameter:@"page_no" number:@0];
    [rq setParameter:@"page_size" number:@10];
    [Request GET:@"https://restts.bullyun.com/api/v3/warning_tone/list" outTime:15 success:^(id success) {
        NSLog(@"");
        block(success);
    } failure:^(NSError *error) {
        NSLog(@"");
        block(error);
    }];
}

+ (void)setToneWithSN:(NSString *)sn block:(void (^)(id dic))block {
    Request *rq = [[Request alloc] init];
    [rq setHeader:@"app_key" value:@"8Wa227sQ00S33p4y"];
    [rq setHeader:@"app_secret" value:@"RlA8aCPlsuATT227kKTg003ncP35HYRI"];
    [rq setHeader:@"access_token" value:[MNSingleton sharedInstance].token];
    [rq setParameter:@"sn" value:sn];
    [rq setParameter:@"warningTone_id" value:@"1346078971320790016"];
    
    [Request Post:@"https://restts.bullyun.com/api/v3/warning_tone/set" outTime:15 success:^(id success) {
        NSLog(@"");
        block(success);
    } failure:^(NSError *error) {
        NSLog(@"");
        block(error);
    }];
}

+ (void)deleteToneWithIds:(NSArray *)ids block:(void (^)(id dic))block {
    Request *rq = [[Request alloc] init];
    [rq setHeader:@"app_key" value:@"8Wa227sQ00S33p4y"];
    [rq setHeader:@"app_secret" value:@"RlA8aCPlsuATT227kKTg003ncP35HYRI"];
    [rq setHeader:@"access_token" value:[MNSingleton sharedInstance].token];
    [rq setArrayParameter:@"ids" arrayValue:ids];
    [Request Post:@"https://restts.bullyun.com/api/v3/warning_tone/delete" outTime:15 success:^(id success) {
        NSLog(@"");
        block(success);
    } failure:^(NSError *error) {
        NSLog(@"");
        block(error);
    }];
}
@end
