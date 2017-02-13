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
//#import "WJIMMainManager+Send.h"
//#import "WJIMMainManager+Login.h"

/** @brief 注册SDK时，是否允许控制台输出log */
#define kSDKConfigEnableConsoleLogger @"SDKConfigEnableConsoleLogger"
#import "WJIMMessageModel.h"
#import "GCDMulticastDelegate.h"        //xmpp多播
@protocol WJIMMainManagerChatDelegate;


/**聊天总管理*/
//链接，单聊，群组，聊天室
@interface WJIMMainManager : NSObject <EMClientDelegate,EMChatManagerDelegate,EMGroupManagerDelegate,EMChatroomManagerDelegate>

+ (instancetype)shareManager;

//@property (nonatomic,weak) id<WJIMMainManagerChatDelegate> delegate;
@property (nonatomic, readonly, strong) GCDMulticastDelegate <WJIMMainManagerChatDelegate> *delegates;  
//从服务器获取推送属性
- (void)asyncPushOptions;

//从服务器获取群组
- (void)asyncGroupFromServer;

//从数据库获取会话信息
- (void)asyncConversationFromDB;

@end

#pragma mark - 协议

/*******聊天代理*******/

@protocol WJIMMainManagerChatDelegate <NSObject>


@optional
/*!
 *  \~chinese
 *  会话列表发生变化
 */
- (void)conversationListDidUpdate:(NSArray *)aConversationList;


/*!
 *  \~chinese
 *  收到消息
 */
- (void)messagesDidReceive:(NSArray *)aMessages;

/*!
 *  \~chinese
 *  收到Cmd消息
 */
- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages;

/*!
 *  \~chinese
 *  收到已读回执
 */
- (void)messagesDidRead:(NSArray *)aMessages;

/*!
 *  \~chinese
 *  收到消息送达回执
 */
- (void)messagesDidDeliver:(NSArray *)aMessages;

/*!
 *  \~chinese
 *  消息状态发生变化
 */
- (void)messageStatusDidChange:(EMMessage *)aMessage
                         error:(EMError *)aError;

/*!
 *  \~chinese
 *  消息附件状态发生改变
 */
- (void)messageAttachmentStatusDidChange:(EMMessage *)aMessage
                                   error:(EMError *)aError;



@end
