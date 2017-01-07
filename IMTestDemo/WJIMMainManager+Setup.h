//
//  WJIMMainManager+Setup.h
//  IMTestDemo
//
//  Created by tqh on 2017/1/7.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMMainManager.h"

@interface WJIMMainManager (Setup)

//集成环信SDK的方法
- (void)imManagerApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                      appkey:(NSString *)appkey
                apnsCertName:(NSString *)apnsCertName
                 otherConfig:(NSDictionary *)otherConfig;

//iOS前台收到通知调用
- (void)imManagerApplication:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo;


@end
