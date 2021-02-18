//
//  LMZDateManager.m
//  StudyAVFoundation
//
//  Created by 梁明哲 on 2021/2/11.
//

#import "LMZDateManager.h"

@implementation LMZDateManager

+ (NSString *)timeStampWithDate:(NSDate *)date {
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeInterval interval = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%f",interval];
}
@end
