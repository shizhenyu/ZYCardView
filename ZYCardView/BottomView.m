//
//  BottomView.m
//  ZYCardView
//
//  Created by youyun on 2018/4/28.
//  Copyright © 2018年 TaoSheng. All rights reserved.
//

#import "BottomView.h"

@interface BottomView ()

@property (nonatomic, strong) UIButton *refreshButton;

@property (nonatomic, strong) UIButton *unLikeButton;

@property (nonatomic, strong) UIButton *likeButton;

@end

@implementation BottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubViewConstraints];
    }
    return self;
}

- (void)addSubViewConstraints {
    
    [self.unLikeButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.mas_equalTo(-15);
        
        make.centerX.equalTo(self.mas_centerX).multipliedBy(0.5);
        
        make.width.height.mas_equalTo(80);
        
    }];
    
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(-15);
        
        make.centerX.equalTo(self.mas_centerX).multipliedBy(1.5);
        
        make.width.height.mas_equalTo(80);
    }];
    
    [self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.unLikeButton.mas_centerY);
        
        make.centerX.mas_equalTo(0);
                
        make.width.height.mas_equalTo(50);
        
    }];
}

#pragma mark - Event Response
- (void)buttonClick:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomViewActionToDo:)]) {
        
        [self.delegate bottomViewActionToDo:sender.tag];
    }
}

#pragma mark - Setter && Getter
- (UIButton *)refreshButton {
    
    if (!_refreshButton) {
        
        _refreshButton = [UIButton new];
        
        [_refreshButton setImage:kImage(@"撤销") forState:UIControlStateNormal];
        
        _refreshButton.tag = 10;
        
        [_refreshButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_refreshButton];
    }
    
    return _refreshButton;
}

- (UIButton *)unLikeButton {
    
    if (!_unLikeButton) {
        
        _unLikeButton = [UIButton new];
        
        [_unLikeButton setImage:kImage(@"unLike") forState:UIControlStateNormal];
        
        _unLikeButton.tag = 11;
        
        [_unLikeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_unLikeButton];
    }
    
    return _unLikeButton;
}

- (UIButton *)likeButton {
    
    if (!_likeButton) {
        
        _likeButton = [UIButton new];
        
        [_likeButton setImage:kImage(@"Like") forState:UIControlStateNormal];
        
        _likeButton.tag = 12;
        
        [_likeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_likeButton];
    }
    
    return _likeButton;
}

@end
