//
//  TTHistoryDataObject.h
//  TTLineChartView
//
//  Created by RenTongtong on 16/8/29.
//  Copyright © 2016年 rtt. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface TTHistoryDataObject : NSObject

@property (nonatomic, copy) NSString *displayX;
@property (nonatomic, copy) NSString *detailX;
@property (nonatomic, strong) NSNumber *ring;
@property (nonatomic, strong) NSNumber *yValue;

@end
