//
//  LXFDanMuView.h
//  酷炫弹幕
//
//  Created by 林洵锋 on 2016/12/14.
//  Copyright © 2016年 林洵锋. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LXFDanMuImage;
@class LXFDanMu;

@interface LXFDanMuView : UIView

/** 添加弹幕图片 */
- (void)addImage:(LXFDanMuImage *)image;

/** 根据弹幕模型生成弹幕图片 */
- (LXFDanMuImage *)imageWithDanMu:(LXFDanMu *)danMu;

@end
