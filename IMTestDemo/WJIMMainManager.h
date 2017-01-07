//
//  WJIMMainManager.h
//  IMTestDemo
//
//  Created by tqh on 2017/1/7.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <EMSDK.h>

/** @brief 注册SDK时，是否允许控制台输出log */
#define kSDKConfigEnableConsoleLogger @"SDKConfigEnableConsoleLogger"

/**聊天总管理*/
//链接，单聊，群组，聊天室
@interface WJIMMainManager : NSObject <EMClientDelegate,EMChatManagerDelegate,EMGroupManagerDelegate,EMChatroomManagerDelegate>

+ (instancetype)shareManager;

//从服务器获取推送属性
- (void)asyncPushOptions;

//从服务器获取群组
- (void)asyncGroupFromServer;

//从数据库获取会话信息
- (void)asyncConversationFromDB;

@end
