//
//  WJIMMainManager+Login.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/6.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMMainManager+Login.h"

@implementation WJIMMainManager (Login)

#pragma mark - public

+ (void)loginWithLoginModel:(WJIMMainManagerLoginModel *)loginModel finish:(WJIMMainManagerLoginFinishBlock)finish {
    
    //登录
    [[EMClient sharedClient] loginWithUsername:loginModel.userName password:loginModel.password completion:^(NSString *aUsername, EMError *aError) {
        
            //如果没有注册进行注册
            if (aError.code == EMErrorUserNotFound) {
                [self registerWithLoginModel:loginModel finish:finish];
            }
            else {
                if (!aError) {
                    [self saveUserInfoWithLoginModel:loginModel];
                    finish(YES,nil,loginModel);
                }else {
                    finish(NO,aError,loginModel);
                }
            }
    }];
  
}

+ (void)logout {
    [[EMClient sharedClient] logout:NO];
}

#pragma mark - private

+ (void)registerWithLoginModel:(WJIMMainManagerLoginModel *)loginModel finish:(WJIMMainManagerLoginFinishBlock)finish {
    
    [[EMClient sharedClient] registerWithUsername:loginModel.userName password:[self changePassWordWithLoginModel:loginModel] completion:^(NSString *aUsername, EMError *aError) {
        
        if (!aError) {
            [self loginWithLoginModel:loginModel finish:finish];
        }else {
            finish(NO,aError,loginModel);
        }
    }];
    
}

#pragma mark - others

//保存用户的数据信息
+ (void)saveUserInfoWithLoginModel:(WJIMMainManagerLoginModel *)loginModel {
    
}

//密码生成规则
+ (NSString *)changePassWordWithLoginModel:(WJIMMainManagerLoginModel *)loginModel {
    return @"123";
}

@end

@implementation WJIMMainManagerLoginModel



@end
