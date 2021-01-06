//
//  Request.h
//  HttpRequest
//
//  Created by 梁明哲 on 2017/8/21.
//  Copyright © 2017年 梁明哲. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^SuccessBlock)(id *data);
typedef void (^FailureBlock)(NSError *error);


@interface Request:NSObject

@property (nonatomic, copy) SuccessBlock successBlock;
@property (nonatomic, copy) FailureBlock failureBlock;

+ (void)Post:(NSString*)url outTime:(int)outTime success:(void (^)(id success))success
     failure:(void (^)(NSError *))failure;

+ (void)Post:(NSString*)url filePathData:(NSData *)filePathData success:(void (^)(id))success
     failure:(void (^)(NSError *))failure;

+ (void)GET:(NSString*)url outTime:(int)outTime success:(void (^)(id))success
    failure:(void (^)(NSError *))failure;

- (void)setHeader:(NSString*)key value:(NSString*)value;
- (void)setParameter:(NSString*)key value:(NSString*)value;
- (void)setParameter:(NSString*)key number:(NSNumber *)value;

- (void)setArrayParameter:(NSString*)key arrayValue:(NSArray*)value;




@end

