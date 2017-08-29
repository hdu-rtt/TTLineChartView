//
//  MTBCYLineChartView.m
//  ChartTest
//
//  Created by RenTongtong on 16/5/12.
//  Copyright © 2016年 rtt. All rights reserved.
//

#import "TTLineChartView.h"
#import "UIView+TTLineChartView.h"
#import "TTLineChartIndicateView.h"

@interface TTLineChartView ()

@property (nonatomic, strong) CAGradientLayer *backgroundLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) CAShapeLayer *maskLayer;

@property (nonatomic, strong) UIView *axleXView;
@property (nonatomic, strong) UIView *axleYView;
@property (nonatomic, strong) TTLineChartIndicateView *indicateLineView;
@property (nonatomic, strong) UIImageView *dotImageView;

@property (nonatomic, strong) NSMutableArray *elementData; //原始数据
@property (nonatomic, strong) NSArray *zoomedElementData; //缩放后转成真实的高度

@end

@implementation TTLineChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        [self setupGradientLayer];
        [self setupMaskLayer];
        self.showAxle = YES;
    }
    return self;
}

#pragma mark draw LineChartView

- (void)setShowAxle:(BOOL)showAxle
{
    _showAxle = showAxle;
    self.userInteractionEnabled = _showAxle;
    [self refreshUIWithElementData:self.elementData];
}

- (void)refreshUIWithElementData:(NSArray *)elementData;
{
    self.elementData = [elementData mutableCopy];
    
    if (self.showBackgroundView) {
        [self setupBackgroundLayer];
    } else {
        [self removeBackgroundLayer];
    }
    
    if (self.showAxle) {
        [self setupAxleX];
        [self setupAlexY];
    } else {
        [self removeAxleX];
        [self removeAxleY];
    }
    
    [self setupFillLineChart];
    
    if (self.needAddDotView) {
        [self addDotView];
    } else {
        [self removeDotView];
        if (self.showAxle && self.elementData.count > 0) {
            [self selectIndex:self.elementData.count - 1];
        } else {
            [self removeIndicateView];
        }
    }
}

- (void)removeDotView
{
    if (self.dotImageView.superview) {
        [self.dotImageView removeFromSuperview];
    }
}

- (void)addDotView
{
    [self removeDotView];
    [self removeIndicateView];
    if (self.elementData.count > 0) {
        [self addSubview:self.dotImageView];
        NSInteger index = self.elementData.count - 1;
        CGRect rect = CGRectMake(index * [self caculateGap] + self.widthOffset - 3, self.bounds.size.height - [self.zoomedElementData[index] floatValue] - 3, 6, 6);
        self.dotImageView.frame = rect;
    }
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(self.width, self.height);
}

- (CGFloat)caculateGap
{
    CGFloat gap = self.elementData.count - 1 <= 0 ? (self.bounds.size.width - self.widthOffset * 2) : (self.bounds.size.width - self.widthOffset * 2) / (self.elementData.count - 1);
    return gap;
}

- (void)removeAxleX
{
    if (self.axleXView.superview) {
        [self.axleXView removeFromSuperview];
        self.axleXView = nil;
    }
}

- (BOOL)shouldDrawScale:(NSInteger)index
{
    if (self.historyData.count > index) {
        TTHistoryDataObject *history = self.historyData[index];
        return history.displayX.length > 0;
    }
    return NO;
}

- (void)setupAxleX
{
    [self removeAxleX];
    if (self.elementData.count == 0) {
        return;
    }
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 6, self.bounds.size.width, 6)];
    CGFloat gap = [self caculateGap];
    
    for (int i = 0; i < self.elementData.count; i++) {
        UIView *view = nil;
        UILabel *label = nil;
        if ([self shouldDrawScale:i]) {
            view = [[UIView alloc] initWithFrame:CGRectMake(i * gap + self.widthOffset, 0, 1, 6)];
            
            label = [[UILabel alloc] init];
            if (self.historyData.count > i) {
                label.text = [self.historyData[i] displayX];
            }
            label.font = Font(12);
            label.textColor = RGBCOLOR(0x2b, 0xb8, 0xaa);
            [label sizeToFit];
            label.centerX = view.centerX;
            label.bottom = view.top;
        } else {
            view = [[UIView alloc] initWithFrame:CGRectMake(i * gap + self.widthOffset, 3, 1, 3)];
        }
        view.backgroundColor = [UIColor colorWithRed:39 / 255.0 green:197 / 255.0 blue:179 / 255.0 alpha:1];
        
        [containerView addSubview:view];
        [containerView addSubview:label];
    }
    self.axleXView = containerView;
    [self addSubview:self.axleXView];
}

- (void)removeAxleY
{
    if (self.axleYView.superview) {
        [self.axleYView removeFromSuperview];
        self.axleYView = nil;
    }
}

- (void)setupAlexY
{
    [self removeAxleY];
    if (self.elementData.count == 0) {
        return;
    }
    
    UIView *containerView = [[UIView alloc] initWithFrame:self.bounds];
    CGFloat gap = (self.bounds.size.height - self.heightOffset) / 4;
    for (int i = 0; i < 4; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, i * gap + self.heightOffset, self.bounds.size.width, 0.5)];
        lineView.backgroundColor = RGBCOLOR(0xcc, 0xcc, 0xcc);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.5, i * gap + self.heightOffset - 14, 0, 0)];
        CGFloat upperValue = [self upperValue];
        CGFloat lowestValue = [self lowestValue];
        CGFloat maxValue = [self maxElementData];
        CGFloat minValue = [self minElementData];
        if (maxValue == minValue) {
                label.text = [NSString stringWithFormat:@"%@", @(maxValue)];
        } else {
            CGFloat valueGap;
            valueGap = ceil((upperValue - lowestValue) / 3.0f);
            if (i == 3) {
                label.text = [NSString stringWithFormat:@"%@", @(lowestValue)];
            } else {
                label.text = [NSString stringWithFormat:@"%@", @(upperValue - i * valueGap)];
            }
        }
        
        label.font = Font(12);
        label.textColor = RGBCOLOR(0x99, 0x99, 0x99);
        [label sizeToFit];
        
        [containerView addSubview:lineView];
        [containerView addSubview:label];
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 0.5, self.bounds.size.width, 0.5)];
    lineView.backgroundColor = RGBCOLOR(0xe5, 0xde, 0xd7);
    [containerView addSubview:lineView];
    self.axleYView = containerView;
    [self addSubview:self.axleYView];
}

- (void)setupFillLineChart
{
    if (self.gradientLayer.superlayer) {
        [self.gradientLayer removeFromSuperlayer];
    }
    [self.layer insertSublayer:self.gradientLayer above:self.backgroundLayer];
    
    NSArray *zoomedElementData = [self zoomElementData];
    self.zoomedElementData = zoomedElementData;
    
    CGFloat gap = [self caculateGap];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.widthOffset, 0)];
    
    if (zoomedElementData.count > 0) {
        int i = 0;
        for (; i < zoomedElementData.count; i++) {
            [path addLineToPoint:CGPointMake(i * gap + self.widthOffset, [zoomedElementData[i] floatValue])];
        }
        [path addLineToPoint:CGPointMake((i - 1) * gap + self.widthOffset, 0)];
    }
    
    [self.maskLayer setPath:path.CGPath];
    [self.gradientLayer setMask:self.maskLayer];
}

#pragma mark zoom data

- (CGFloat)maxElementData
{
    if (self.elementData.count == 0) {
        return 0.0;
    }
    CGFloat maxValue = CGFLOAT_MIN;
    for (NSNumber *value in self.elementData) {
        if (value.floatValue > maxValue) {
            maxValue = value.floatValue;
        }
    }
    return maxValue;
}

- (CGFloat)minElementData
{
    if (self.elementData.count == 0) {
        return 0.0;
    }
    CGFloat minValue = CGFLOAT_MAX;
    for (NSNumber *value in self.elementData) {
        if (value.floatValue < minValue) {
            minValue = value.floatValue;
        }
    }
    return minValue;
}

- (CGFloat)upperValue
{
    CGFloat maxValue = [self maxElementData];
    NSInteger upperValue = (NSInteger)(maxValue);
    NSInteger div = 10;
    if (upperValue % div != 0) {
        NSInteger last = upperValue % div;
        upperValue += (div - last);
    }
    return upperValue;
}

- (CGFloat)lowestValue
{
    CGFloat minValue = [self minElementData];
    NSInteger lowestValue = (NSInteger)(minValue);
    NSInteger div = 10;
    if (lowestValue % div != 0) {
        NSInteger last = lowestValue % div;
        lowestValue -= last;
    }
    return lowestValue;
}

- (NSArray *)zoomElementData
{
    CGFloat upperValue = [self upperValue];
    CGFloat lowestValue = [self lowestValue];
    CGFloat maxValue = [self maxElementData];
    CGFloat minValue = [self minElementData];
    
    NSMutableArray *zoomedElementData = [NSMutableArray array];
    CGFloat gap = (self.bounds.size.height - self.heightOffset) / 4;
    if (upperValue == 0 || maxValue == 0) {
        for (int i = 0; i < self.elementData.count; i++) {
            [zoomedElementData addObject:@(self.bounds.size.height - self.heightOffset - 3 * gap)];
        }
        return zoomedElementData;
    }
    
    if (maxValue == minValue) {
        for (int i = 0; i < self.elementData.count; i++) {
            [zoomedElementData addObject:@(self.bounds.size.height - self.heightOffset)];
        }
    } else {
        CGFloat magicNumber;
        if (upperValue - lowestValue == 0) {
            magicNumber = 0;
        } else {
            magicNumber = (self.bounds.size.height - self.heightOffset - gap) / (upperValue - lowestValue);
        }
        for (int i = 0; i < self.elementData.count; i++) {
            [zoomedElementData addObject:@(([self.elementData[i] floatValue] - lowestValue) * magicNumber + gap)];
        }
    }
    
    return zoomedElementData;
}

#pragma mark init or remove views

- (void)removeBackgroundLayer
{
    if (self.backgroundLayer.superlayer) {
        [self.backgroundLayer removeFromSuperlayer];
        self.backgroundLayer = nil;
    }
}

- (void)setupBackgroundLayer
{
    [self removeBackgroundLayer];
    self.backgroundLayer = [CAGradientLayer layer];
    CGColorRef color1 = RGBCOLOR(0xff, 0xfb, 0xfb).CGColor;
    CGColorRef color2 = RGBCOLOR(0xfd, 0xec, 0xdc).CGColor;
    [self.backgroundLayer setColors:@[(__bridge id)color1,(__bridge id)color2]];
    [self.backgroundLayer setFrame:[self bounds]];
    [[self layer] addSublayer:self.backgroundLayer];
}

- (void)setupGradientLayer
{
    _gradientLayer = [CAGradientLayer layer];
    CGColorRef color1 = RGBCOLOR(0xff, 0x9a, 0x63).CGColor;
    CGColorRef color2 = RGBCOLOR(0xfd, 0xec, 0xdc).CGColor;
    [_gradientLayer setColors:@[(__bridge id)color1,(__bridge id)color2]];
    [_gradientLayer setFrame:[self bounds]];
}

- (void)setupMaskLayer
{
    _maskLayer = [CAShapeLayer layer];
    [_maskLayer setFrame:[self bounds]];
    [_maskLayer setGeometryFlipped:YES];
    [_maskLayer setStrokeColor:[[UIColor redColor] CGColor]];
    [_maskLayer setFillColor:[[UIColor redColor] CGColor]];
    [_maskLayer setLineWidth:2.0f];
    [_maskLayer setLineJoin:kCALineJoinBevel];
    [_maskLayer setMasksToBounds:YES];
}

- (TTLineChartIndicateView *)indicateLineView
{
    if (!_indicateLineView) {
        _indicateLineView = [[TTLineChartIndicateView alloc] init];
        _indicateLineView.backgroundColor = RGBCOLOR(0xf7, 0x61, 0x20);
    }
    return _indicateLineView;
}

- (UIImageView *)dotImageView
{
    if (!_dotImageView) {
        _dotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_home_circle"]];
    }
    return _dotImageView;
}

#pragma mark handle touch event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [self refreshIndicateViewWithTouchs:touches];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [self refreshIndicateViewWithTouchs:touches];
    [super touchesMoved:touches withEvent:event];
}

- (void)refreshIndicateViewWithTouchs:(NSSet<UITouch *> *)touches
{
    if (self.elementData.count == 0) {
        return;
    }
    CGPoint touchPoint = [[[touches allObjects] firstObject] locationInView:self];
    
    if (touchPoint.x < 0 || touchPoint.x > self.bounds.size.width || touchPoint.y < 0 || touchPoint.y > self.bounds.size.height) {
        return;
    }
    
    CGFloat gap = [self caculateGap];
    
    NSInteger index = (NSInteger)((touchPoint.x - self.widthOffset) / gap);
    if (index <= 0) {
        index = 0;
    } else if (index >= self.zoomedElementData.count - 1) {
        index = self.zoomedElementData.count - 2;
    }
    
    if ((touchPoint.x - index * gap - self.widthOffset) > (gap / 2)) {
        index++;
    }
    
    [self selectIndex:index];
}

- (void)selectIndex:(NSInteger)index
{
    [self removeIndicateView];
    if (!self.indicateLineView.superview) {
        [self addSubview:self.indicateLineView];
    }
    
    if (self.historyData.count > index) {
        TTHistoryDataObject *history = self.historyData[index];
        //frame
        CGRect rect = CGRectMake(index * [self caculateGap] + self.widthOffset, self.bounds.size.height - [self.zoomedElementData[index] floatValue], 1, [self.zoomedElementData[index] floatValue]);
        //value
        NSString *yValue = [TTLineChartView convertValue:history.yValue withPoint:0];
        NSMutableAttributedString *yValueString = [[NSMutableAttributedString alloc] initWithString:@"数量" attributes:@{NSForegroundColorAttributeName: RGBCOLOR(0x66, 0x66, 0x66),NSFontAttributeName: Font(11)}];
        NSMutableAttributedString *valueString = [[NSMutableAttributedString alloc] initWithString:yValue attributes:@{NSForegroundColorAttributeName: RGBCOLOR(0x66, 0x66, 0x66),NSFontAttributeName: Font(15)}];
        [yValueString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        [yValueString appendAttributedString:valueString];
        
        //ring
        NSString *ring = [TTLineChartView convertValue:history.ring withPoint:2];
        if (ring.length == 0) {
            ring = @"";
        } else {
            ring = [NSString stringWithFormat:@"%@%@%@", [history.ring floatValue] > 0 ? @"+" : @"", ring, @"\%"];
        }
        NSString *ringString = [NSString stringWithFormat:@"环比%@ %@", [ring floatValue] >= 0 ? @"增长" : @"降低", ring];
        [self.indicateLineView refreshUIWithFrame:rect andValue:yValueString andRing:ringString andDetailX:history.detailX andIsRise:history.ring.floatValue >= 0];
    } else {
        CGRect rect = CGRectMake(index * [self caculateGap] + self.widthOffset, self.bounds.size.height - [self.zoomedElementData[index] floatValue], 1, [self.zoomedElementData[index] floatValue]);
        [self.indicateLineView refreshUIWithFrame:rect andValue:[[NSAttributedString alloc] initWithString:@""] andRing:@"" andDetailX:@"" andIsRise:YES];
    }
}

- (void)removeIndicateView
{
    if (self.indicateLineView.superview) {
        [self.indicateLineView removeFromSuperview];
    }
}

+ (NSString *)convertValue:(NSNumber *)value withPoint:(NSInteger)point
{
    NSString *resString = @"";
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    if (point == 1) {
        [formatter setPositiveFormat:@"###,##0.0"];
        resString = [formatter stringFromNumber:value];
    } else if (point == 2) {
        [formatter setPositiveFormat:@"###,##0.00"];
        resString = [formatter stringFromNumber:value];
    } else {
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        resString = [formatter stringFromNumber:value];
    }
    return resString ?: @"";
}

@end
