//
//  ZYCardView.m
//  ZYCardView
//
//  Created by youyun on 2018/4/26.
//  Copyright © 2018年 TaoSheng. All rights reserved.
//

#import "ZYCardView.h"

#define MIN_INFO_NUM 6
#define CARD_SCALE 0.95

@interface ZYCardView ()<ZYCardItemDelegate>

@property (nonatomic, assign) NSUInteger numberOfItem;

@property (nonatomic, strong) NSMutableArray <ZYCardItem *> *cardItems;

@property (nonatomic, assign) CGPoint lastCardCenter;

@property (nonatomic, assign) CGAffineTransform lastCardTransform;

@end

@implementation ZYCardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initInfo];
        
    }
    return self;
}

#pragma mark - Private Method
- (void)initInfo {
    
    self.cardItems = [NSMutableArray array];
}

- (void)configItemWithData:(NSMutableArray *)dataArr {
    
    for (int i = 0; i < dataArr.count; i++) {
        
        ZYCardItem *item = [[ZYCardItem alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 20)];
        
        item.model = [dataArr objectAtIndex:i];
        
        kWeakSelf
        item.contentLabel.detailClickEventBlock = ^{
            
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didClickDetailEventAtIndex:)]) {
                
                [weakSelf.delegate didClickDetailEventAtIndex:1];
            }
            
        };
        
        if (i > 0 && i < dataArr.count - 1) {
            
            item.transform = CGAffineTransformScale(item.transform, pow(CARD_SCALE, i), pow(CARD_SCALE, i));
            
        }else if(i == dataArr.count-1){
            
            item.transform = CGAffineTransformScale(item.transform, pow(CARD_SCALE, i-1), pow(CARD_SCALE, i-1));
        }
        
        item.delegate = self;
        
        [self.cardItems addObject:item];
        
        if (i==0) {
            
            item.canPan=YES;
            
        }else{
            
            item.canPan=NO;
            
        }
    }
    
    for (int i = (int)dataArr.count - 1; i >= 0; i--){
        
        [self addSubview:self.cardItems[i]];
    }
}

#pragma mark - Public Method
- (void)reloadData {
    
    for (int i=0; i < self.cardItems.count; i++) {
        
        ZYCardItem *item = self.cardItems[i];
        
        item.transform = CGAffineTransformIdentity;
        
        item.frame = CGRectMake(CGRectGetWidth(self.bounds)+CARD_WIDTH, 40, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-20);
        
        item.transform = CGAffineTransformMakeRotation(ROTATION_ANGLE);
        
        item.hidden = NO;
    }
    
    for (int i = 0; i < self.cardItems.count ;i++) {
        
        ZYCardItem *item=self.cardItems[i];
        
        CGPoint finishPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)-10);
        
        [UIView animateKeyframesWithDuration:0.5 delay:0.06*i options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            
            item.center = finishPoint;
            item.transform = CGAffineTransformMakeRotation(0);
            
            if (i > 0 && i < self.numberOfItem - 1) {
                
                ZYCardItem *preItem=[self.cardItems objectAtIndex:i-1];
                
                item.transform=CGAffineTransformScale(item.transform, pow(CARD_SCALE, i), pow(CARD_SCALE, i));
                
                CGRect frame=item.frame;
                
                frame.origin.y=preItem.frame.origin.y+(preItem.frame.size.height-frame.size.height)+10*pow(0.7,i);
                
                item.frame=frame;
                
            }else if (i == self.numberOfItem - 1) {
                
                ZYCardItem *preItem = [self.cardItems objectAtIndex:i-1];
                item.transform = preItem.transform;
                item.frame = preItem.frame;
            }
            
        } completion:^(BOOL finished) {
            
        }];
        
        item.originalCenter=item.center;
        item.originalTransform=item.transform;
        
        if (i == self.numberOfItem - 1) {
            
            self.lastCardCenter=item.center;
            
            self.lastCardTransform=item.transform;
        }
    }
}

#pragma mark - 刷新所有卡片
-(void)refreshAllCards {
    
    for (int i = 0; i<self.cardItems.count ;i++) {
        
        ZYCardItem *card = self.cardItems[i];
        
        CGPoint originalPoint = card.center;
        
        CGAffineTransform originalTransform = card.transform;
        
        CGPoint finishPoint = CGPointMake(-CGRectGetMidX(self.bounds)-80, CGRectGetMidY(self.bounds)+20);
        
        card.transform = originalTransform;
        
        [UIView animateKeyframesWithDuration:0.5 delay:0.06*i options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            
            card.center = finishPoint;
            card.transform = CGAffineTransformMakeRotation(-ROTATION_ANGLE);
            
        } completion:^(BOOL finished) {
            
            card.transform = CGAffineTransformMakeRotation(ROTATION_ANGLE);
            card.hidden=YES;
            card.center = originalPoint;
            card.transform = originalTransform;
            
            if (i==self.cardItems.count-1) {
                
                [self reloadData];
                
            }
        }];
    }
}



#pragma mark - LUCardItemDelegate
#pragma mark - 滑动中更改其他卡片位置
-(void)moveCards:(CGFloat)distance{
    
    if (fabs(distance)<=PAN_DISTANCE) {
        for (int i = 1; i < self.numberOfItem - 1; i++) {
            ZYCardItem *item=self.cardItems[i];
            ZYCardItem *preItem=[self.cardItems objectAtIndex:i-1];
            
            item.transform=CGAffineTransformScale(item.originalTransform, 1+(1/CARD_SCALE-1)*fabs(distance/PAN_DISTANCE)*0.6, 1+(1/CARD_SCALE-1)*fabs(distance/PAN_DISTANCE)*0.6);//0.6为缩减因数，使放大速度始终小于卡片移动速度
            
            CGPoint center = item.center;
            center.y = item.originalCenter.y - (item.originalCenter.y-preItem.originalCenter.y)*fabs(distance/PAN_DISTANCE)*0.6;//此处的0.6同上
            item.center=center;
        }
    }
}

#pragma mark - 滑动终止后复原其他卡片
-(void)moveBackCards{
    
    for (int i = 1; i<self.numberOfItem - 1; i++) {
        
        ZYCardItem *item = self.cardItems[i];
        
        [UIView animateWithDuration:RESET_ANIMATION_TIME
                         animations:^{
                             item.transform=item.originalTransform;
                             item.center=item.originalCenter;
                         }];
    }
}

#pragma mark - 滑动后调整其他卡片位置
-(void)adjustOtherCards{
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         for (int i = 1; i<self.numberOfItem - 1; i++) {
                             ZYCardItem *item=self.cardItems[i];
                             ZYCardItem *preItem=[self.cardItems objectAtIndex:i-1];
                             item.transform=preItem.originalTransform;
                             item.center=preItem.originalCenter;
                         }
                     }completion:^(BOOL complete){
                         
                     }];
    
}

#pragma mark - 滑动后续操作
-(void)cardSwiped:(ZYCardItem *)card LorR:(BOOL)isRight{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cardItem:didSwipedDirectionLorR:)]) {
        
        [self.delegate cardItem:card didSwipedDirectionLorR:isRight];
    }
    
    
    [self.cardItems removeObject:card];
    card.transform = self.lastCardTransform;
    card.center = self.lastCardCenter;
    card.canPan=NO;
    [self insertSubview:card belowSubview:[self.cardItems lastObject]];
    [self.cardItems addObject:card];
    
    //    if ([self.sourceObject firstObject]!=nil) {
    //        card.userInfo=[self.sourceObject firstObject];
    //        [self.sourceObject removeObjectAtIndex:0];
    //        [card layoutSubviews];
    //        if (self.sourceObject.count<MIN_INFO_NUM) {
    //            [self requestSourceData:NO];
    //        }
    //    }else{
    //        card.hidden=YES;//如果没有数据则隐藏卡片
    //    }
    
    for (int i = 0; i < self.numberOfItem; i++) {
        
        ZYCardItem *item = [self.cardItems objectAtIndex:i];
        
        item.originalCenter = item.center;
        
        item.originalTransform = item.transform;
        
        if (i==0) {
            item.canPan=YES;
        }
    }
}

- (void)headerImageViewDidClickOfCardItem:(ZYCardItem *)cardItem {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cardView:didClickHeaderImageViewAtIndex:cardItem:)]) {
        [self.delegate cardView:self didClickHeaderImageViewAtIndex:1 cardItem:cardItem];
    }
    
}

- (void)unlikeCurrentCard {
    
}

- (void)likeCurrentCard {
    
    
}


#pragma mark - Setter & Getter

- (void)setDataArr:(NSMutableArray<PasserbyModel *> *)dataArr {
    
    _dataArr = dataArr;
    
    self.numberOfItem = dataArr.count;
    
    [self configItemWithData:dataArr];
}

@end
