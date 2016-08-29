//
//  TTLineChartIndicateView.h
//  TTLineChartView
//
//  Created by RenTongtong on 16/5/31.
//  Copyright © 2016年 rtt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTLineChartIndicateView : UIView

- (void)refreshUIWithFrame:(CGRect)frame andValue:(NSAttributedString *)valueString andRing:(NSString *)ringString andDetailX:(NSString *)detailX andIsRise:(BOOL)isRise;

@property (nonatomic, strong) UIImageView *infoView;
@property (nonatomic, strong) UIImageView *infoArrowView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *saleLabel;

@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *dotImageView;

@end