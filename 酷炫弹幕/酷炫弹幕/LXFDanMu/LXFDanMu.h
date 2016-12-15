//
//  LXFDanMu.h
//  酷炫弹幕
//
//  Created by 林洵锋 on 2016/12/14.
//  Copyright © 2016年 林洵锋. All rights reserved.
//  弹幕模型

#import <Foundation/Foundation.h>

@interface LXFDanMu : NSObject

/** 表情数组 */
@property(nonatomic, strong) NSArray *emotions;

/** 用户名 */
@property(nonatomic, copy) NSString *username;

/** 用户输入的内容 */
@property(nonatomic, copy) NSString *text;

/** 弹幕的类型 */
// YES: 自己发的  NO: 别人发的
@property(nonatomic, assign) BOOL type;

+ (instancetype)danMuWithDict:(NSDictionary *)dict;


@end
