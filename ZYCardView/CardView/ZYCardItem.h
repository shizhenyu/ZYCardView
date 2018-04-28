//
//  ZYCardItem.h
//  ZYCardView
//
//  Created by youyun on 2018/4/26.
//  Copyright © 2018年 TaoSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYDetailView.h"
#import "PasserbyModel.h"

#define PAN_DISTANCE 120
#define CARD_WIDTH kWidth(333)
#define CARD_HEIGHT kWidth(400)

#define ROTATION_ANGLE M_PI/8
#define CLICK_ANIMATION_TIME 0.5
#define RESET_ANIMATION_TIME 0.3

@class ZYCardItem;
@protocol ZYCardItemDelegate <NSObject>

- (void)cardSwiped:(UIView *)card LorR:(BOOL)isRight;

- (void)moveCards:(CGFloat)distance;

- (void)moveBackCards;

- (void)adjustOtherCards;

- (void)headerImageViewDidClickOfCardItem:(ZYCardItem *)cardItem;

@end

@interface ZYCardItem : UIView

@property (nonatomic, weak) id <ZYCardItemDelegate> delegate;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, assign) CGPoint originalPoint;
@property (nonatomic, assign) CGPoint originalCenter;
@property (nonatomic, assign) CGAffineTransform originalTransform;
@property (nonatomic, assign) BOOL canPan;

@property (nonatomic, strong) NSDictionary *userInfo;

@property (nonatomic, strong) UIImageView *headerImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) ZYDetailView *contentLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *vipIcon;

@property (nonatomic, strong) UIButton *locationButton;

@property (nonatomic, strong) PasserbyModel *model;

-(void)leftClickAction;
-(void)rightClickAction;

@end
