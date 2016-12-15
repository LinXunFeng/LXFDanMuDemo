//
//  LXFDanMu.m
//  酷炫弹幕
//
//  Created by 林洵锋 on 2016/12/14.
//  Copyright © 2016年 林洵锋. All rights reserved.
//  弹幕模型

#import "LXFDanMu.h"

@implementation LXFDanMu

+ (instancetype)danMuWithDict:(NSDictionary *)dict {
    id obj = [[self alloc] init];
    
    [obj setValuesForKeysWithDictionary:dict];
    
    return obj;
}

@end
