//
//  XYItemModel.h
//  XY视频直播
//
//  Created by qingyun on 16/6/28.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYItemModel : NSObject

@property (nonatomic ,strong)NSString *videoId;
@property (nonatomic ,strong)NSString *title;
@property (nonatomic ,strong)NSString *nickname;
@property (nonatomic ,strong)NSNumber *online;
@property (nonatomic ,strong)NSString *bpic;
@property (nonatomic ,strong)NSString *gender;

-(instancetype)initItemModelWithDictionary:(NSDictionary *)dict;
+(instancetype)itemModelWithDictionary:(NSDictionary *)dict;

@end
