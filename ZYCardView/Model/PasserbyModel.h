//
//  PasserbyModel.h
//  ZYCardView
//
//  Created by youyun on 2018/4/28.
//  Copyright © 2018年 TaoSheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PasserbyModel : NSObject

/** 路人ID */
@property (nonatomic, copy) NSString *peopleID;

/** 路人姓名 */
@property (nonatomic, copy) NSString *name;

/** 路人头像 */
@property (nonatomic, copy) NSString *headerPic;

/** 路人地址 */
@property (nonatomic, copy) NSString *address;

/** 路人年级 */
@property (nonatomic, copy) NSString *age;

/** 路人身高 */
@property (nonatomic, copy) NSString *height;

/** 路人存款 */
@property (nonatomic, copy) NSString *money;

/** 生肖 */
@property (nonatomic, copy) NSString *shengxiao;

/** 星座 */
@property (nonatomic, copy) NSString *constellation;

/** 简介 */
@property (nonatomic, copy) NSString *abstract;

@end
