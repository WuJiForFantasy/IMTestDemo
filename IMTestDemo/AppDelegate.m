//
//  AppDelegate.m
//  IMTestDemo
//
//  Created by tqh on 2017/1/7.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import "WJIMMainManager.h"
#import "WJIMMainManager+Send.h"
//#import "WJIMMainManager+Setup.h"
#import "WJIMMainManager+Login.h"
#import "MainController.h"
#import "AppDelegate+WJIM.h"
#import "UIAlertController+Blocks.h"

@interface AppDelegate ()



@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.mainController = [[MainController alloc]init];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.mainController;
    [self.window makeKeyAndVisible];
    
    [self imManagerApplication:application didFinishLaunchingWithOptions:launchOptions];
    WJIMMainManagerLoginModel *model = [[WJIMMainManagerLoginModel alloc]init];
    model.userName = @"123";
    model.password = @"123";
    [WJIMMainManager loginWithLoginModel:model finish:^(BOOL sucess, EMError *error, WJIMMainManagerLoginModel *model) {
        
        
        NSLog(@"%@登录%@",model.userName,sucess ? @"成功" : @"失败");
        [[NSUserDefaults standardUserDefaults] setObject:model.userName forKey:@"user"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //登录成功刷新小红点
        NSInteger count = [[WJIMMainManager shareManager] getAllUnreadMessageCount];
        NSLog(@"所有未读消息:%ld",count);
        if (count > 0) {
            self.mainController.viewControllers[0].tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)count];
        }else{
            self.mainController.viewControllers[0].tabBarItem.badgeValue = nil;
        }
        UIApplication *application = [UIApplication sharedApplication];
        [application setApplicationIconBadgeNumber:count];
    }];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//    
//    });
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 通知处理

//收到远程通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"收到通知");
    [self imManagerApplication:application didReceiveRemoteNotification:userInfo];
}

//收到本地通知
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"收到本地通知");
}

#pragma mark - iOS10通知方法

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{

    //    NSDictionary *userInfo = notification.request.content.userInfo;
    //    [self easemobApplication:[UIApplication sharedApplication] didReceiveRemoteNotification:userInfo];

}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    
//    if (_mainController) {
//        [_mainController didReceiveUserNotification:response.notification];
//    }
    
    completionHandler();
}

@end
