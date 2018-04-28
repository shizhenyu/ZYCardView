//
//  BottomView.h
//  ZYCardView
//
//  Created by youyun on 2018/4/28.
//  Copyright © 2018年 TaoSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomViewDelegate <NSObject>

- (void)bottomViewActionToDo:(NSInteger)tag;

@end

@interface BottomView : UIView

@property (nonatomic, weak) id <BottomViewDelegate> delegate;

@end
