//
//  ZYCardView.h
//  ZYCardView
//
//  Created by youyun on 2018/4/26.
//  Copyright © 2018年 TaoSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYCardItem.h"
#import "PasserbyModel.h"

@class ZYCardView;
@protocol ZYCardViewDelegate <NSObject>

- (void)cardItem:(ZYCardItem *)cardItem didSwipedDirectionLorR:(BOOL)isLike;

- (void)cardView:(ZYCardView *)cardView didClickHeaderImageViewAtIndex:(NSInteger)index cardItem:(ZYCardItem *)cardItem;

- (void)didClickDetailEventAtIndex:(NSInteger)index;

@end

@interface ZYCardView : UIView

@property (nonatomic, weak) id <ZYCardViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray <PasserbyModel *> *dataArr;

- (void)unlikeCurrentCard;

- (void)likeCurrentCard;

- (void)reloadData;

- (void)refreshAllCards;

@end
