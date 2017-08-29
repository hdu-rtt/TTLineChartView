//
//  UIView+TTLineChartView.h
//  TTLineChartView
//
//  Created by RenTongtong on 16/8/29.
//  Copyright © 2016年 rtt. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define Font(x) [UIFont systemFontOfSize:x]

@interface UIView (TTLineChartView)

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;

@end
