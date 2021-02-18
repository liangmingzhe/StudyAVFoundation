//
//  LMZAudioInfo.h
//  StudyAVFoundation
//
//  Created by 梁明哲 on 2021/2/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface LMZAudioInfo : NSObject
@property (nonatomic,copy) NSString *singer;//歌手
@property (nonatomic,copy) NSString *song;//歌曲名
@property (nonatomic,copy) UIImage *image;//图片
@property (nonatomic,copy) NSString *albumName;//专辑名
@property (nonatomic,copy) NSString *fileSize;//文件大小
@property (nonatomic,copy) NSString *voiceStyle;//音质类型
@property (nonatomic,copy) NSString *fileStyle;//文件类型
@property (nonatomic,copy) NSString *creatDate;//创建日期
@property (nonatomic,copy) NSString *savePath; //存储路径

@end

NS_ASSUME_NONNULL_END
