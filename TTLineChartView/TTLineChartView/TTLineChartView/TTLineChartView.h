//
//  TTLineChartView.h
//  ChartTest
//
//  Created by RenTongtong on 16/5/12.
//  Copyright © 2016年 rtt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTHistoryDataObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTLineChartView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

- (void)refreshUIWithElementData:(NSArray<NSNumber *> * _Nullable)elementData;

//display data
@property (nonatomic, strong, nullable) NSArray<TTHistoryDataObject *> *historyData;
//hide or display axle. defalut is YES
@property (nonatomic, assign) BOOL showAxle;
//hide or display backround. defalut is NO
@property (nonatomic, assign) BOOL showBackgroundView;
//hide or display dot. defalut is NO
@property (nonatomic, assign) BOOL needAddDotView;
//real content yAxle offset. defalut is 0.0
@property (nonatomic, assign) CGFloat heightOffset;
//real content xAxle offset. defalut is 0.0
@property (nonatomic, assign) CGFloat widthOffset;

@end

NS_ASSUME_NONNULL_END
