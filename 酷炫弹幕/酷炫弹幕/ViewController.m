//
//  ViewController.m
//  酷炫弹幕
//
//  Created by 林洵锋 on 2016/12/14.
//  Copyright © 2016年 林洵锋. All rights reserved.
//

#import "ViewController.h"
#import "LXFDanMuView.h"
#import "LXFDanMuImage.h"
#import "LXFDanMu.h"

@interface ViewController ()

/** 弹幕View */
@property (weak, nonatomic) IBOutlet LXFDanMuView *danMuView;

/** 弹幕模型数组 */
@property(nonatomic, strong) NSMutableArray *danMus;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载数据
    [self loadData];
}

// 加载数据
- (void)loadData {
    // 获得plist文件全路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"danMu.plist" ofType:nil];
    // 从指定的路径中加载数据
    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    // 遍历数组
    for (NSDictionary *dict in array) {
        // 字典转模型
        LXFDanMu *danMu = [LXFDanMu danMuWithDict:dict];
        // 将模型添加到数组中
        [self.danMus addObject:danMu];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 获得一个随机整数值
    NSInteger index = arc4random_uniform((u_int32_t)self.danMus.count); // 范围：0 ~ self.danMus.count-1
    // 获得一个随机模型
    LXFDanMu *danMu = self.danMus[index];
    // 根据模型生成图片
    LXFDanMuImage *image = [self.danMuView imageWithDanMu:danMu];
    image.x = self.view.bounds.size.width;
    image.y = arc4random_uniform(self.danMuView.bounds.size.height - image.size.height);
    // 将图片添加到弹幕view上
    [self.danMuView addImage:image];
}

#pragma mark - 懒加载
- (NSMutableArray *)danMus {
    if (_danMus == nil) {
        _danMus = [NSMutableArray array];
    }
    return _danMus;
}



@end
