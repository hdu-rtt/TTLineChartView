//
//  ViewController.m
//  TTLineChartView
//
//  Created by RenTongtong on 16/5/31.
//  Copyright © 2016年 rtt. All rights reserved.
//

#import "ViewController.h"
#import "TTLineChartView/TTLineChartView.h"
#import "TTLineChartView/TTHistoryDataObject.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface ViewController ()

@property (nonatomic, strong) TTLineChartView *lineChartView;
@property (nonatomic, assign) BOOL showAxle;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.showAxle = YES;
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn1.frame = CGRectMake(20, 50, 70, 30);
    [btn1 setTitle:@"切换数据" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(dataChange) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn2.frame = CGRectMake(110, 50, 120, 30);
    [btn2 setTitle:@"隐藏/显示坐标轴" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(hiddenChange) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn1];
    [self.view addSubview:btn2];

    [self.view addSubview:self.lineChartView];
    
}

- (void)dataChange
{
    NSMutableArray *sourceData = [NSMutableArray array];
    NSInteger count = arc4random_uniform(30);
    for (int i = 0; i < count; i++) {
        [sourceData addObject:@(arc4random_uniform(10000))];
    }
    NSMutableArray *historyData = [NSMutableArray array];
    for (int i = 0; i < sourceData.count; i++) {
        TTHistoryDataObject *obj = [[TTHistoryDataObject alloc] init];
        obj.displayX = [NSString stringWithFormat:@"%@", @(i)];
        obj.detailX = [NSString stringWithFormat:@"%@", sourceData[i]];
        obj.yValue = sourceData[i];
        obj.ring = i == 0 ? @0 : @((([sourceData[i] floatValue] - [sourceData[i - 1] floatValue]) / [sourceData[i - 1] floatValue]) * 100);
        [historyData addObject:obj];
    }
    self.lineChartView.historyData = historyData;
    [self.lineChartView refreshUIWithElementData:sourceData];
}

- (void)hiddenChange
{
    _lineChartView.needAddDotView = self.showAxle;
    _lineChartView.showAxle = !self.showAxle;
    self.showAxle = !self.showAxle;
}

- (TTLineChartView *)lineChartView
{
    if (!_lineChartView) {
        _lineChartView = [[TTLineChartView alloc] initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, 234)];
        _lineChartView.showBackgroundView = YES;
        _lineChartView.heightOffset = 34;
        _lineChartView.widthOffset = 17.5;
    }
    return _lineChartView;
}

@end
