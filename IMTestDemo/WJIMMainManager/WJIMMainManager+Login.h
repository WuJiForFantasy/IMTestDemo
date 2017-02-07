//
//  WJIMMainManager+Login.h
//  IMTestDemo
//
//  Created by tqh on 2017/2/6.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMMainManager.h"

@class WJIMMainManagerLoginModel;
typedef void (^WJIMMainManagerLoginFinishBlock)(BOOL sucess, EMError *error, WJIMMainManagerLoginModel *model);

/**
 登录注册环信的类目
 */
@interface WJIMMainManager (Login)

/**登录(没有用户自动注册,注册后自动登录)*/
+ (void)loginWithLoginModel:(WJIMMainManagerLoginModel *)loginModel finish:(WJIMMainManagerLoginFinishBlock)finish;

+ (void)logout;

@end

/**
 im登录模型（按照需要在这里面增加）
 */
@interface WJIMMainManagerLoginModel : NSObject

@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *password;


@end
