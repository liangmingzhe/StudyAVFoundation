//
//  Request.m
//  HttpRequest
//
//  Created by 梁明哲 on 2017/8/21.
//  Copyright © 2017年 梁明哲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Request.h"

@interface Request (){

}

@end


@implementation Request
    static int timeOut;
    static NSMutableDictionary* HeaderDic;
    static NSMutableDictionary *params;


- (id)init
{
    self = [super init];
    if (self) {
        //初始化代码
        HeaderDic =[[NSMutableDictionary alloc]init];
        params =[[NSMutableDictionary alloc]init];
    }
    
    return self;
}



+ (void)Post:(NSString*)url outTime:(int)outTime success:(void (^)(id))success
        failure:(void (^)(NSError *))failure{
    AFHTTPSessionManager *manager;
    manager = [[AFHTTPSessionManager manager]init];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
//        manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",nil]
    ;
    manager.securityPolicy.validatesDomainName = NO;
    
    manager.securityPolicy.allowInvalidCertificates = NO;
    [manager.requestSerializer setValue:@"zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3" forHTTPHeaderField:@"Accept-Language"];
    //设置请求头
    for (NSString *key in [HeaderDic allKeys] ) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",[HeaderDic objectForKey:key]] forHTTPHeaderField:key];
    }
    //设置请求头
    for (NSString *key in [HeaderDic allKeys] ) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",[HeaderDic objectForKey:key]] forHTTPHeaderField:key];
    }
    NSDictionary *headerDict = @{@"app_key":@"8Wa227sQ00S33p4y",@"app_secret":@"RlA8aCPlsuATT227kKTg003ncP35HYRI"};
    [manager POST:url parameters:params headers:headerDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        return ;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
            NSLog(@"T_T(网络异常):%@", error);
        }
        return ;
    }];
}

+ (void)GET:(NSString*)url outTime:(int)outTime success:(void (^)(id))success
        failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager *manager;
    manager = [[AFHTTPSessionManager manager]init];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
//        manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",nil]
    ;
    manager.securityPolicy.validatesDomainName = NO;
    
    manager.securityPolicy.allowInvalidCertificates = NO;
    [manager.requestSerializer setValue:@"zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3" forHTTPHeaderField:@"Accept-Language"];
    //设置请求头
    for (NSString *key in [HeaderDic allKeys] ) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",[HeaderDic objectForKey:key]] forHTTPHeaderField:key];
    }
    
    //设置请求头
    NSMutableDictionary *headerDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    for (NSString *key in [HeaderDic allKeys] ) {
        [headerDict setValue:[HeaderDic objectForKey:key] forKey:key];
    }
    [manager GET:url parameters:params headers:headerDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        return ;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
            NSLog(@"T_T(网络异常):%@", error);
        }
        return ;
    }];
}

+ (void)Post:(NSString*)url filePathData:(NSData *)filePathData success:(void (^)(id))success
        failure:(void (^)(NSError *))failure {
    NSLog(@"URL:%@\n",url);
    
    AFHTTPSessionManager *manager;
    manager = [[AFHTTPSessionManager manager]init];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
//        manager.securityPolicy.allowInvalidCertificates = YES;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",nil]
    ;
    manager.securityPolicy.validatesDomainName = NO;
    
    manager.securityPolicy.allowInvalidCertificates = NO;
    [manager.requestSerializer setValue:@"zh-CN,zh;q=0.8,en-US;q=0.5,en;q=0.3" forHTTPHeaderField:@"Accept-Language"];
    //设置请求头
    for (NSString *key in [HeaderDic allKeys] ) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",[HeaderDic objectForKey:key]] forHTTPHeaderField:key];
    }
    //设置请求头
    
    NSMutableDictionary *headerDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    for (NSString *key in [HeaderDic allKeys] ) {
        [headerDict setValue:[HeaderDic objectForKey:key] forKey:key];
    }
    NSLog(@"HEADER:%@\n",HeaderDic);
    NSLog(@"BODY:%@\n",params);
    [manager POST:url parameters:params headers:headerDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFormData:filePathData name:@"file"];
        [formData appendPartWithFileData:filePathData
                                    name:@"file"
                                fileName:@"test.mp3"
                                mimeType:@"mp3"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        NSLog(@"RESPONSE:%@\n",params);
        return ;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        return ;
    }];
}


- (void)setTimeOut:(int)time{
    timeOut = time;
}

- (int)getTimeOut{
    timeOut = 15;
    return timeOut;
}
- (void)setHeader:(NSString*)key value:(NSString*)value{
    [HeaderDic setObject:value forKey:key];

}

- (void)setParameter:(NSString*)key value:(NSString*)value{
    [params setObject:value forKey:key];
}

- (void)setParameter:(NSString*)key number:(NSNumber *)value{
    [params setObject:value forKey:key];
}
- (void)setArrayParameter:(NSString*)key arrayValue:(NSArray*)value{
    [params setObject:value forKey:key];
}






@end






