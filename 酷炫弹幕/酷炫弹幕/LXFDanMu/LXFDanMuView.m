//
//  LXFDanMuView.m
//  酷炫弹幕
//
//  Created by 林洵锋 on 2016/12/14.
//  Copyright © 2016年 林洵锋. All rights reserved.
//

#import "LXFDanMuView.h"
#import "LXFDanMuImage.h"
#import "LXFDanMu.h"

@interface LXFDanMuView()

/** 弹幕图片数组 */
@property(nonatomic, strong) NSMutableArray *images;

/** 装要删除的图片 */
@property(nonatomic, strong) NSMutableArray *deleteImages;

/** 定时器 */
@property(nonatomic, strong) CADisplayLink *link;

@end

@implementation LXFDanMuView
#pragma mark - 生命周期
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

// reason: '*** Collection <__NSArrayM: 0x610000253e30> was mutated while being enumerated.'
// 原因: 在遍历数组的同时删除了数组中的元素
// OC语法规定，不能在遍历数组的时候删除数组中的元素


#pragma mark - 绘制
- (void)drawRect:(CGRect)rect {
    // 遍历图片数组
    for (LXFDanMuImage *image in self.images) {
        // 修改图片的x值
        image.x -= 5;
        // 绘制图片
        [image drawAtPoint:CGPointMake(image.x, image.y)];
        
        // 判断图片是否超出屏幕
        if (image.x + image.size.width < 0) {
            // 将图片从数组中移除
            // [self.images removeObject:image];
            [self.deleteImages addObject:image];
        }
    }

    // 遍历数组
    for (LXFDanMuImage *image in self.deleteImages) {
        // 删除images数组中的元素
        [self.images removeObject:image];
    }
    // 删除deleteImages数组中的图片
    [self.deleteImages removeAllObjects];
}

#pragma mark - 提供使用的方法
#pragma mark 添加弹幕图片
- (void)addImage:(LXFDanMuImage *)image {
    // 将图片添加到数组中
    [self.images addObject:image];
    
    // 重绘
    [self setNeedsDisplay];
    
    // 添加定时器
    [self addTimer];
}
#pragma mark 根据弹幕模型生成弹幕图片
- (LXFDanMuImage *)imageWithDanMu:(LXFDanMu *)danMu {
    
    // 绘制文字使用的字体
    UIFont *font = [UIFont systemFontOfSize:13];
    
    // 间距
    CGFloat marginX = 5;
    // 头像的尺寸
    CGFloat iconH = 30;
    CGFloat iconW = iconH;
    
    // 表情图片的尺寸
    CGFloat emotionW = 25;
    CGFloat emotionH = emotionW;
    
    // 计算用户名占据的实际区域
    CGSize nameSize = [danMu.username boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
    // 计算内容占据的实际区域
    CGSize textSize = [danMu.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
    
    // 位图上下文的尺寸
    CGFloat contextH = iconH;
    CGFloat contextW = iconW + 4 * marginX + nameSize.width + textSize.width + danMu.emotions.count * emotionW;
    
    
    CGSize contextSize = CGSizeMake(contextW, contextH);
    // 开启位图上下文
    UIGraphicsBeginImageContextWithOptions(contextSize, NO, 0.0);
    // 获得位图上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 将上下文保存一份到栈中
    CGContextSaveGState(ctx);
    
    // 绘制圆的区域
    CGRect iconFrame = CGRectMake(0, 0, iconW, iconH);
    // 绘制头像圆形
    CGContextAddEllipseInRect(ctx, iconFrame);
    // 超出圆形范围内的内容要裁剪
    CGContextClip(ctx);
    // 绘制头像
    UIImage *icon = danMu.type ? [UIImage imageNamed:@"lxf"] : [UIImage imageNamed:@"other"];
    [icon drawInRect:iconFrame];
    
    // 将上下文出栈替换当前上下文
    CGContextRestoreGState(ctx);
    
    // 绘制背景图片
    CGFloat bgX = iconW + marginX;
    CGFloat bgY = 0;
    CGFloat bgW = contextW - bgX;
    CGFloat bgH = contextH;
    // 设置背景颜色
    danMu.type ? [[UIColor orangeColor] set] : [[UIColor whiteColor] set];
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(bgX, bgY, bgW, bgH) cornerRadius:bgH * 0.5] fill];
    
    // 绘制用户名
    CGFloat nameX = bgX + marginX;
    CGFloat nameY = (contextH - nameSize.height) * 0.5;
    [danMu.username drawAtPoint:CGPointMake(nameX, nameY) withAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName : danMu.type == NO ? [UIColor orangeColor] : [UIColor blackColor]}];
    
    // 绘制内容
    CGFloat textX = nameX + nameSize.width + marginX;
    CGFloat textY = nameY;
    [danMu.text drawAtPoint:CGPointMake(textX, textY) withAttributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName : danMu.type == NO ? [UIColor blackColor] : [UIColor whiteColor]}];
    
    // 绘制表情图片
    __block CGFloat emotionX = textX + textSize.width;
    CGFloat emotionY = (contextH - emotionH) * 0.5;
    [danMu.emotions enumerateObjectsUsingBlock:^(NSString *emotionName, NSUInteger idx, BOOL * _Nonnull stop) {
        // 加载表情图片
        UIImage *emotion = [UIImage imageNamed:emotionName];
        // 绘制表情
        [emotion drawInRect:CGRectMake(emotionX, emotionY, emotionW, emotionH)];
        // 修改emtionX
        emotionX += emotionW;
    }];
    
    // 从位图上下文中获得绘制好的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    return [[LXFDanMuImage alloc] initWithCGImage:image.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
}

#pragma mark - 添加定时器
- (void)addTimer {
    if (self.link) return;
    
    // 每秒执行60次回调方法
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
    // 将定时器添加到runLoop
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    // 记录属性
    self.link = link;
}


#pragma mark - 懒加载
- (NSMutableArray *)images {
    if (_images == nil) {
        _images = [NSMutableArray array];
    }
    return _images;
}
- (NSMutableArray *)deleteImages {
    if (_deleteImages == nil) {
        _deleteImages = [NSMutableArray array];
    }
    return _deleteImages;
}
@end
