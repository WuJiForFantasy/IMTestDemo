//
//  AppDelegate+WJIM.h
//  IMTestDemo
//
//  Created by tqh on 2017/2/6.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (WJIM) <WJIMMainManagerChatDelegate>

//集成环信SDK的方法

- (void)imManagerApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

//iOS前台收到通知调用
- (void)imManagerApplication:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo;


@end
