//
//  ZYDetailView.h
//  ZYCardView
//
//  Created by youyun on 2018/4/14.
//  Copyright © 2018年 TaoSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYDetailView : UIView

@property(nonatomic, strong) UIFont *font;

@property(nonatomic, copy) NSString *text;

@property(nonatomic, strong) UIColor *textColor;

@property(nonatomic, strong) UIColor *detailColor;

/** 布局时最大的参考宽度 */
@property(nonatomic, assign) CGFloat preferMaxWidth;

@property(nonatomic, copy) void(^detailClickEventBlock)(void);

@end
