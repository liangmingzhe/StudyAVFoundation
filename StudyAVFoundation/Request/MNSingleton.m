//
//  MNSingleton.m
//  StudyAVFoundation
//
//  Created by benjaminlmz@qq.com on 2021/1/4.
//

#import "MNSingleton.h"
static MNSingleton *singleTon = nil;
@implementation MNSingleton
+ (MNSingleton *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (singleTon == nil) {
            singleTon = [[MNSingleton alloc] init];
        }
    });
    return singleTon;
}

@end
