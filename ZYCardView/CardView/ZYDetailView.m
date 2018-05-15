//
//  ZYDetailView.m
//  ZYCardView
//
//  Created by youyun on 2018/4/14.
//  Copyright © 2018年 TaoSheng. All rights reserved.
//

#import "ZYDetailView.h"

@interface ZYDetailView ()

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIButton *detailButton;

@end

@implementation ZYDetailView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
                
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.edges.mas_equalTo(0);
            
        }];
        
        [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.trailing.equalTo(self.contentLabel.mas_trailing);
            
            make.bottom.equalTo(self.contentLabel.mas_bottom);
            
            make.height.mas_equalTo(16);
            
        }];
    }
    return self;
}

#pragma mark - Button Event Response
- (void)detailButtonClick {
    
    if (self.detailClickEventBlock) {
        
        self.detailClickEventBlock();
    }
}

#pragma mark - Setter && Getter
- (UILabel *)contentLabel {
    
    if (!_contentLabel) {
        
        _contentLabel = [[UILabel alloc] init];
        
        _contentLabel.numberOfLines = 2;
        
        _contentLabel.font = kFont(15);
        
        _contentLabel.textColor = [UIColor zy_colorWithHex:0x9fa3a3];
        
        [self addSubview:_contentLabel];
    }
    
    return _contentLabel;
}

- (UIButton *)detailButton {
    
    if (!_detailButton) {
        
        _detailButton = [UIButton new];
        
        _detailButton.backgroundColor = [UIColor whiteColor];
                
        [_detailButton setTitle:@"更多" forState:UIControlStateNormal];
        
        [_detailButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        
        _detailButton.titleLabel.font = kFont(15);
        
        [_detailButton addTarget:self action:@selector(detailButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_detailButton sizeToFit];
        
        [self addSubview:_detailButton];
    }
    
    return _detailButton;
}

- (void)setFont:(UIFont *)font {
    
    _font = font;
    
    self.contentLabel.font = font;
    self.detailButton.titleLabel.font = font;
}

- (void)setText:(NSString *)text {
    
    _text = text;
    
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 10;
    
    [contentStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    
    self.contentLabel.text = text;
}

- (void)setTextColor:(UIColor *)textColor {
    
    _textColor = textColor;
    
    self.contentLabel.textColor = textColor;
}

- (void)setDetailColor:(UIColor *)detailColor {
    
    _detailColor = detailColor;
    
    [self.detailButton setTitleColor:detailColor forState:UIControlStateNormal];
}

- (void)setPreferMaxWidth:(CGFloat)preferMaxWidth {
    
    _preferMaxWidth = preferMaxWidth;
    
    self.contentLabel.preferredMaxLayoutWidth = preferMaxWidth;
}
@end
