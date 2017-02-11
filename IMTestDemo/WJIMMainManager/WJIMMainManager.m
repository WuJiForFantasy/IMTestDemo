//
//  WJIMMainManager.m
//  IMTestDemo
//
//  Created by tqh on 2017/1/7.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMMainManager.h"


static WJIMMainManager *manager = nil;

@implementation WJIMMainManager

#pragma mark - 销毁

- (void)dealloc
{
    [[EMClient sharedClient] removeDelegate:self];
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[EMClient sharedClient].roomManager removeDelegate:self];
    [[EMClient sharedClient].chatManager removeDelegate:self];
}

#pragma mark - 初始化单例

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WJIMMainManager alloc]init];
    });
    return manager;
 
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initHelper];
    }
    return self;
}

- (void)initHelper
{
    
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].roomManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];

}

- (void)asyncPushOptions
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        [[EMClient sharedClient] getPushOptionsFromServerWithError:&error];
    });
}


- (void)asyncGroupFromServer
{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient].groupManager getJoinedGroups];
        EMError *error = nil;
        [[EMClient sharedClient].groupManager getMyGroupsFromServerWithError:&error];
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //更新群组
            });
        }
    });
}

- (void)asyncConversationFromDB
{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *array = [[EMClient sharedClient].chatManager getAllConversations];
        [array enumerateObjectsUsingBlock:^(EMConversation *conversation, NSUInteger idx, BOOL *stop){
            if(conversation.latestMessage == nil){
                [[EMClient sharedClient].chatManager deleteConversation:conversation.conversationId isDeleteMessages:NO completion:nil];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新会话列表，已读数量，小圆点等
        });
    });
}

#pragma mark - <EMClientDelegate>

// 网络状态变化回调
- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    NSLog(@"%@,%@环信服务器",[self class],connectionState == 0 ? @"已连接":@"未连接");
}

//自动登录完成时的回调
- (void)autoLoginDidCompleteWithError:(EMError *)error
{
    
}

//当前登录账号在其它设备登录时会接收到此回调
- (void)userAccountDidLoginFromOtherDevice
{
    
    [self _clearHelper];

//    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

//当前登录账号已经被从服务器端删除时会收到该回调
- (void)userAccountDidRemoveFromServer
{
    [self _clearHelper];

//    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

// 服务被禁用
- (void)userDidForbidByServer
{
    [self _clearHelper];

//    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

#pragma mark - <EMChatManagerDelegate>

//会话列表发生改变
- (void)conversationListDidUpdate:(NSArray *)aConversationList {
    NSLog(@"会话列表发生改变");
    if (self.delegate && [self.delegate respondsToSelector:@selector(conversationListDidUpdate:)]) {
        [self.delegate conversationListDidUpdate:aConversationList];
    }
}

//收到消息
- (void)messagesDidReceive:(NSArray *)aMessages {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(messagesDidReceive:)]) {
        [self.delegate messagesDidReceive:aMessages];
    }
    
    NSLog(@"收到消息%@",aMessages);
    
//    BOOL isRefreshCons = YES;
//    for(EMMessage *message in aMessages){
//        BOOL needShowNotification = (message.chatType != EMChatTypeChat) ? [self _needShowNotification:message.conversationId] : YES;
//        
//#ifdef REDPACKET_AVALABLE
//        /**
//         *  屏蔽红包被抢消息的提示
//         */
//        NSDictionary *dict = message.ext;
//        needShowNotification = (dict && [dict valueForKey:RedpacketKeyRedpacketTakenMessageSign]) ? NO : needShowNotification;
//#endif
//        
//        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
//        if (needShowNotification) {
//#if !TARGET_IPHONE_SIMULATOR
////            switch (state) {
////                case UIApplicationStateActive:
////                    [self.mainVC playSoundAndVibration];
////                    break;
////                case UIApplicationStateInactive:
////                    [self.mainVC playSoundAndVibration];
////                    break;
////                case UIApplicationStateBackground:
////                    [self.mainVC showNotificationWithMessage:message];
////                    break;
////                default:
////                    break;
////            }
//#endif
//        }
//    }
}

//收到cmd消息
- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages {
    
    NSLog(@"收到cmd消息");
    if (self.delegate && [self.delegate respondsToSelector:@selector(cmdMessagesDidReceive:)]) {
        [self.delegate cmdMessagesDidReceive:aCmdMessages];
    }
}

//收到已读回执
- (void)messagesDidRead:(NSArray *)aMessages {
    
    NSLog(@"收到消息已读回执");
    if (self.delegate && [self.delegate respondsToSelector:@selector(messagesDidRead:)]) {
        [self.delegate messagesDidRead:aMessages];
    }
}

//收到消息送达回执
- (void)messagesDidDeliver:(NSArray *)aMessages {
    
    NSLog(@"收到消息送达回执");
    if (self.delegate && [self.delegate respondsToSelector:@selector(messagesDidDeliver:)]) {
        [self.delegate messagesDidDeliver:aMessages];
    }
}

//消息状态发生变化
- (void)messageStatusDidChange:(EMMessage *)aMessage
                         error:(EMError *)aError {
    
    NSLog(@"消息状态发生变化");
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageStatusDidChange:error:)]) {
        [self.delegate messageStatusDidChange:aMessage error:aError];
    }
}

//消息附件状态发生改变
- (void)messageAttachmentStatusDidChange:(EMMessage *)aMessage
                                   error:(EMError *)aError {
    
    NSLog(@"消息附件发生变化");
    if (self.delegate && [self.delegate respondsToSelector:@selector(messagesDidReceive:)]) {
        [self.delegate messageAttachmentStatusDidChange:aMessage error:aError];
    }
}

#pragma mark - <EMGroupManagerDelegate>

- (void)groupInvitationDidReceive:(NSString *)aGroupId
                          inviter:(NSString *)aInviter
                          message:(NSString *)aMessage {
   
    //使用推送逻辑将会话列表群通知添加 “接受到入群的回调”
    NSLog(@"接受到入群的回调");
    [self showWithString:@"接受到入群的回调"];
    [[WJIMNotifyCache shareManager] saveWithType:WJIMNotifyChatGroupType_ReceiveJoin groupId:aGroupId inviteId:aInviter message:aMessage];
}


- (void)groupInvitationDidAccept:(EMGroup *)aGroup
                         invitee:(NSString *)aInvitee {
    
    //使用推送逻辑将会话列表群通知添加 “别人同意你的邀请”
    NSLog(@"接受到入群的回调");
    [self showWithString:@"接受到入群的回调"];
    [[WJIMNotifyCache shareManager] saveWithType:WJIMNotifyChatGroupType_AcceptJoin groupId:aGroup.groupId inviteId:aInvitee message:@""];
}

//别人拒绝你的邀请
- (void)groupInvitationDidDecline:(EMGroup *)aGroup
                          invitee:(NSString *)aInvitee
                           reason:(NSString *)aReason {
    

    //使用推送逻辑将会话列表群通知添加 “别人拒绝你的邀请”
    NSLog(@"别人拒绝你的邀请");
    [self showWithString:@"别人拒绝你的邀请"];
    [[WJIMNotifyCache shareManager] saveWithType:WJIMNotifyChatGroupType_AcceptJoin groupId:aGroup.groupId inviteId:aInvitee message:aReason];
}

//- (void)didJoinGroup:(EMGroup *)aGroup
//             inviter:(NSString *)aInviter
//             message:(NSString *)aMessage {
//    
//}

//离开群组回调
- (void)didLeaveGroup:(EMGroup *)aGroup
               reason:(EMGroupLeaveReason)aReason {
    
    //使用推送逻辑将会话列表群通知添加 “你离开了群”
    NSLog(@"你已经离开群");
    [self showWithString:@"你已经离开群"];
    switch (aReason) {
        case EMGroupLeaveReasonBeRemoved:
            [[WJIMNotifyCache shareManager] saveWithType:WJIMNotifyChatGroupType_LeaveReasonBeRemoved groupId:aGroup.groupId inviteId:@"" message:@""];
            break;
        case EMGroupLeaveReasonUserLeave:
            [[WJIMNotifyCache shareManager] saveWithType:WJIMNotifyChatGroupType_LeaveReasonUserLeave groupId:aGroup.groupId inviteId:@"" message:@""];
            break;
        case EMGroupLeaveReasonDestroyed:
            [[WJIMNotifyCache shareManager] saveWithType:WJIMNotifyChatGroupType_LeaveReasonDestroyed groupId:aGroup.groupId inviteId:@"" message:@""];
            break;
        default:
            break;
    }
    
}

////群组的群主收到用户的入群申请，群的类型是EMGroupStylePublicJoinNeedApproval
//- (void)joinGroupRequestDidReceive:(EMGroup *)aGroup
//                              user:(NSString *)aUsername
//                            reason:(NSString *)aReason {
//    //joinGroupRequestDidReceive
//    NSLog(@"群主收到用户的入群申请");
//    
//    //使用推送逻辑将会话列表群通知添加 “入群申请”
//     [self showWithString:@"群主收到用户的入群申请"];
//}

////群主同意用户A的入群申请后，用户A会接收到该回调，群的类型是EMGroupStylePublicJoinNeedApproval
//- (void)joinGroupRequestDidDecline:(NSString *)aGroupId
//                            reason:(NSString *)aReason {
//    
//    NSLog(@"群主同意你的入群申请");
//    //使用推送逻辑将会话列表群通知添加 “群主同意你入群”
//    [self showWithString:@"群主同意你的入群申请"];
//}
//
////群主拒绝用户A的入群申请后，用户A会接收到该回调，群的类型是EMGroupStylePublicJoinNeedApproval
//- (void)joinGroupRequestDidApprove:(EMGroup *)aGroup {
//
//    NSLog(@"群主拒绝你的入群申请");
//    //使用推送逻辑将会话列表群通知添加 “群主拒接你入群”
//    [self showWithString:@"群主拒绝你的入群申请"];
//}

//群组列表发生变化
- (void)groupListDidUpdate:(NSArray *)aGroupList {
    
    NSLog(@"群组列表发生变化");
}

#pragma mark - others

//需要显示通知
- (BOOL)_needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EMClient sharedClient].groupManager getGroupsWithoutPushNotification:nil];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    return ret;
}



//退出登录
- (void)_clearHelper
{

//    self.mainVC = nil;
//    self.conversationListVC = nil;
//    self.chatVC = nil;
//    self.contactViewVC = nil;
    
    [[EMClient sharedClient] logout:NO];

}

- (void)showWithString:(NSString *)string {
    [SVProgressHUD showWithStatus:string];
}

@end
