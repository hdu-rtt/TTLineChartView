//
//  TTLineChartIndicateView.m
//  TTLineChartView
//
//  Created by RenTongtong on 16/5/31.
//  Copyright © 2016年 rtt. All rights reserved.

#import "TTLineChartIndicateView.h"
#import "UIView+TTLineChartView.h"

@implementation TTLineChartIndicateView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.infoView];
        [self addSubview:self.descLabel];
        [self addSubview:self.dotImageView];
        [self addSubview:self.infoArrowView];
    }
    return self;
}

- (void)refreshUIWithFrame:(CGRect)frame andValue:(NSAttributedString *)valueString andRing:(NSString *)ringString andDetailX:(NSString *)detailX andIsRise:(BOOL)isRise
{
    self.frame = frame;
    //点的位置
    self.dotImageView.left = -(self.dotImageView.width / 2);
    self.dotImageView.top = -self.dotImageView.height;
    //箭头的位置
    self.infoArrowView.left = -(self.infoArrowView.width / 2);
    self.infoArrowView.top = -(self.infoArrowView.height + self.dotImageView.height);
    //显示数据
    self.nameLabel.attributedText = valueString;
    [self.nameLabel sizeToFit];
    
    self.saleLabel.text = ringString;
    [self.saleLabel sizeToFit];
    self.saleLabel.top = self.nameLabel.bottom + 2;
    self.saleLabel.textColor = isRise ? RGBCOLOR(0xFF, 0x89, 0x00) : RGBCOLOR(0x3d, 0xc6, 0xb6);
    
    self.descLabel.text = [NSString stringWithFormat:@"%@", detailX ?: @""];;
    [self.descLabel sizeToFit];
    self.descLabel.frame = CGRectMake(-self.descLabel.width / 2, self.height - 6 - 14, self.descLabel.width, self.descLabel.height);
    //根据显示数据的宽度来确定infoView
    self.infoView.width = self.nameLabel.width > self.saleLabel.width ? self.nameLabel.width + 20 : self.saleLabel.width + 20;
    if (self.left < self.infoView.width / 2 ) {
        self.infoView.left = -self.left;
    } else if (self.superview.width - self.left < self.infoView.width / 2) {
        self.infoView.left = -self.infoView.width + self.superview.width - self.left;
    } else {
        self.infoView.left = -(self.infoView.width / 2);
    }
}

- (UIImageView *)dotImageView
{
    if (!_dotImageView) {
        _dotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_detail_circle"]];
        _dotImageView.width = _dotImageView.height = 11;
    }
    return _dotImageView;
}

- (UIImageView *)infoArrowView
{
    if (!_infoArrowView) {
        _infoArrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_indicate_arrow"]];
        _infoArrowView.width = 15;
        _infoArrowView.height = 9;
    }
    return _infoArrowView;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = Font(12);
        _descLabel.textColor = RGBCOLOR(0xf7, 0x61, 0x20);
        _descLabel.backgroundColor = RGBCOLOR(0xfd, 0xed, 0xdc);
    }
    return _descLabel;
}

- (UIImageView *)infoView
{
    if (!_infoView) {
        _infoView = [[UIImageView alloc] initWithFrame:CGRectMake(-54, -(43 + self.dotImageView.height + self.infoArrowView.height - 5), 108, 43)];
        _infoView.image = [UIImage imageNamed:@"img_indicate_rectangle"];
        [_infoView addSubview:self.nameLabel];
        [_infoView addSubview:self.saleLabel];
    }
    return _infoView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.left = 12;
        _nameLabel.top = 3;
        _nameLabel.font = [UIFont systemFontOfSize:11];
        _nameLabel.textColor = RGBCOLOR(0x66, 0x66, 0x66);
    }
    return _nameLabel;
}

- (UILabel *)saleLabel
{
    if (!_saleLabel) {
        _saleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 0, 0)];
        _saleLabel.left = 11;
        _saleLabel.font = [UIFont systemFontOfSize:11];
    }
    return _saleLabel;
}

@end

