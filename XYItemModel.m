//
//  XYItemModel.m
//  XY视频直播
//
//  Created by qingyun on 16/6/28.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "XYItemModel.h"

@implementation XYItemModel

-(instancetype)initItemModelWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        _bpic = dict[@"bpic"];
        _title = dict[@"title"];
        _nickname = dict[@"nickname"];
        _online = dict[@"online"];
        _videoId = dict[@"videoId"];
        _gender = dict[@"gender"];
    }
    return self;
}

+(instancetype)itemModelWithDictionary:(NSDictionary *)dict{
    return [[self alloc]initItemModelWithDictionary:dict];
}

@end
