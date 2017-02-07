//
//  AppDelegate+WJIM.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/6.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "AppDelegate+WJIM.h"
#import <UserNotifications/UserNotifications.h> //ios10通知
#import "WJIMMainManager.h"

#define WJIMManagerKey @"917034405#imtest" //环信的key
#define WJIMApnsCert_DEVName @""
#define WJIMApnsCert_PROName @""

@implementation AppDelegate (WJIM)


#pragma mark - app delegate notifications

/** @brief 注册App切入后台和进入前台的通知 */
- (void)_setupAppDelegateNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackgroundNotif:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

//app进入后台断开链接
- (void)appDidEnterBackgroundNotif:(NSNotification*)notif
{
    [[EMClient sharedClient] applicationDidEnterBackground:notif.object];
}

//app进入前台重新链接
- (void)appWillEnterForeground:(NSNotification*)notif
{
    [[EMClient sharedClient] applicationWillEnterForeground:notif.object];
}

#pragma mark - register apns

/** @brief 注册远程通知 */
- (void)_registerRemoteNotification
{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError *error) {
            if (granted) {
#if !TARGET_IPHONE_SIMULATOR
                [application registerForRemoteNotifications];
#endif
            }
        }];
        return;
    }
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}

#pragma mark - init

- (void)imManagerApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                      appkey:(NSString *)appkey
                apnsCertName:(NSString *)apnsCertName
                 otherConfig:(NSDictionary *)otherConfig
{
    //监听app进入后台进入前台
    [self _setupAppDelegateNotifications];
    //注册远程通知
    [self _registerRemoteNotification];
    
    //配置全局信息
    EMOptions *options = [EMOptions optionsWithAppkey:appkey];
    options.apnsCertName = apnsCertName;
    options.isAutoAcceptGroupInvitation = NO;
    if ([otherConfig objectForKey:kSDKConfigEnableConsoleLogger]) {
        options.enableConsoleLog = YES;
    }
    
    BOOL sandBox = [otherConfig objectForKey:@"easeSandBox"] && [[otherConfig objectForKey:@"easeSandBox"] boolValue];
    if (!sandBox) {
        EMError *error = [[EMClient sharedClient] initializeSDKWithOptions:options];
        if (error) {
            NSLog(@"%@",error);
        }
    }
}

- (void)imManagerApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //证书
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = WJIMApnsCert_DEVName;
#else
    apnsCertName = WJIMApnsCert_PROName;
#endif
    
    //环信的key
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSString *appkey = [ud stringForKey:@"identifier_appkey"];
//    if (!appkey) {
//        appkey = WJIMManagerKey;
//        [ud setObject:appkey forKey:@"identifier_appkey"];
//    }
    
    [self imManagerApplication:application didFinishLaunchingWithOptions:launchOptions appkey:WJIMManagerKey apnsCertName:apnsCertName otherConfig:nil];
    [WJIMMainManager shareManager];
}

- (void)imManagerApplication:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[EMClient sharedClient] application:application didReceiveRemoteNotification:userInfo];
}


@end
