//
//  MNSingleton.h
//  StudyAVFoundation
//
//  Created by benjaminlmz@qq.com on 2021/1/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MNSingleton : NSObject
@property (nonatomic,copy)NSString *token;
@property (nonatomic,assign)long long usr_id;

+ (MNSingleton *)sharedInstance;
@end

NS_ASSUME_NONNULL_END
