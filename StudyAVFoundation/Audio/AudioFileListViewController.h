//
//  AudioFileListViewController.h
//  StudyAVFoundation
//
//  Created by 梁明哲 on 2021/1/3.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN


@interface AudioFileListViewController : BaseViewController
@property (nonatomic,copy) void (^selectFile)(NSString *selectFilePath,BOOL isSelectFile);
@end

NS_ASSUME_NONNULL_END
