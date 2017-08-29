//
//  UIView+TTLineChartView.m
//  TTLineChartView
//
//  Created by RenTongtong on 16/8/29.
//  Copyright © 2016年 rtt. All rights reserved.
//

#import "UIView+TTLineChartView.h"

@implementation UIView (TTLineChartView)

- (void)setTop:(CGFloat)top
{
    self.frame = CGRectMake(self.left, top, self.width, self.height);
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setBottom:(CGFloat)bottom
{
    self.frame = CGRectMake(self.left, bottom - self.height, self.width, self.height);
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setLeft:(CGFloat)left
{
    self.frame = CGRectMake(left , self.top, self.width, self.height);
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setRight:(CGFloat)right
{
    self.frame = CGRectMake(right - self.width, self.top, self.width, self.height);
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    self.frame = CGRectMake(self.left, self.top, width, self.height);
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    self.frame = CGRectMake(self.left, self.top, self.width, height);
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}

@end
