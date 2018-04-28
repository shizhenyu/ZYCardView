//
//  Macro.h
//  ZYCardView
//
//  Created by youyun on 2018/4/14.
//  Copyright © 2018年 TaoSheng. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kWidth(width) width * kScreenWidth / 375.0

#define kHeight(height) height * kScreenHeight / 667.0

#define kFont(size) [UIFont systemFontOfSize:size]
#define kBFont(size) [UIFont boldSystemFontOfSize:size]

#define kImage(imageName) [UIImage imageNamed:imageName]

#define kWeakSelf __weak typeof(self)weakSelf = self;

#endif /* Macro_h */
