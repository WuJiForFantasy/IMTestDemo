//
//  WJIMMainManager.m
//  IMTestDemo
//
//  Created by tqh on 2017/1/7.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMMainManager.h"
#import <UserNotifications/UserNotifications.h>

static WJIMMainManager *manager = nil;
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";

@interface WJIMMainManager ()

@property (nonatomic,strong)NSDate *lastPlaySoundDate;   //音频最后播放时间

@end

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
    
    //初始化多播
    _delegates = (GCDMulticastDelegate<WJIMMainManagerChatDelegate> *)[[GCDMulticastDelegate alloc]init];
    //初始化环信
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
    [self.delegates conversationListDidUpdate:aConversationList];
//    if (self.delegates && [self.delegates respondsToSelector:@selector(conversationListDidUpdate:)]) {
//        [self.delegates conversationListDidUpdate:aConversationList];
//    }
}

//收到消息
- (void)messagesDidReceive:(NSArray *)aMessages {
    [self.delegates messagesDidReceive:aMessages];
//    if (self.delegates && [self.delegates respondsToSelector:@selector(messagesDidReceive:)]) {
//        [self.delegates messagesDidReceive:aMessages];
//    }
    
    NSLog(@"收到消息%@",aMessages);

    BOOL isRefreshCons = YES;
    for(EMMessage *message in aMessages){
        
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        
#if !TARGET_IPHONE_SIMULATOR
            switch (state) {
                case UIApplicationStateActive:
                case UIApplicationStateInactive:
                    
                    //播放音乐震动
                    [self playSoundAndVibration];
                    break;
                case UIApplicationStateBackground:
                    //显示通知信息
                    [self showNotificationWithMessage:message];
                    break;
                default:
                    break;
            }
#endif
        
        BOOL isChatting = NO;
        if (self.chatStore) {
            isChatting = [message.conversationId isEqualToString:self.chatStore.conversation.conversationId];
        }
        //没有在聊天中收到消息刷新列表
        if (self.chatStore == nil || !isChatting || state == UIApplicationStateBackground) {
            
            if (self.conversationStore) {
                [self.conversationStore refreshData];
            }
            //设置小红点
            self.allUnreadMessageCount = [self getAllUnreadMessageCount];
        }
        if (isChatting) {
            isRefreshCons = NO;
        }
        
    }
   
    if (isRefreshCons) {
        if (self.conversationStore) {
            [self.conversationStore refreshData];
        }
        //设置小红点
        [self getAllUnreadMessageCount];
        
        self.allUnreadMessageCount = [self getAllUnreadMessageCount];
        [self.delegates unReadAllMessageCount:self.allUnreadMessageCount];
    }
}


//收到cmd消息
- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages {
    [self.delegates cmdMessagesDidReceive:aCmdMessages];
    NSLog(@"收到cmd消息");
//    if (self.delegates && [self.delegates respondsToSelector:@selector(cmdMessagesDidReceive:)]) {
//        [self.delegates cmdMessagesDidReceive:aCmdMessages];
//    }
}

//收到已读回执
- (void)messagesDidRead:(NSArray *)aMessages {
    [self.delegates messagesDidRead:aMessages];
    NSLog(@"收到消息已读回执");
//    if (self.delegates && [self.delegates respondsToSelector:@selector(messagesDidRead:)]) {
//        [self.delegates messagesDidRead:aMessages];
//    }
}

//收到消息送达回执
- (void)messagesDidDeliver:(NSArray *)aMessages {
    [self.delegates messagesDidDeliver:aMessages];
    NSLog(@"收到消息送达回执");
//    if (self.delegates && [self.delegates respondsToSelector:@selector(messagesDidDeliver:)]) {
//        [self.delegates messagesDidDeliver:aMessages];
//    }
}

//消息状态发生变化
- (void)messageStatusDidChange:(EMMessage *)aMessage
                         error:(EMError *)aError {
     [self.delegates messageStatusDidChange:aMessage error:aError];
    NSLog(@"消息状态发生变化");
//    if (self.delegates && [self.delegates respondsToSelector:@selector(messageStatusDidChange:error:)]) {
//        [self.delegates messageStatusDidChange:aMessage error:aError];
//    }
}

//消息附件状态发生改变
- (void)messageAttachmentStatusDidChange:(EMMessage *)aMessage
                                   error:(EMError *)aError {
    [self.delegates messageAttachmentStatusDidChange:aMessage error:aError];
    NSLog(@"消息附件发生变化");
//    if (self.delegates && [self.delegates respondsToSelector:@selector(messagesDidReceive:)]) {
//        [self.delegates messageAttachmentStatusDidChange:aMessage error:aError];
//    }
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

#pragma mark - tool

/**播放音乐&震动*/
- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < 3) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}


/**显示通知的消息～～～～（发送本地推送）*/
- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    NSString *alertBody = nil;
    if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
        EMMessageBody *messageBody = message.body;
        NSString *messageStr = nil;
        switch (messageBody.type) {
            case EMMessageBodyTypeText:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case EMMessageBodyTypeVideo:{
                messageStr = NSLocalizedString(@"message.video", @"Video");
            }
                break;
            default:
                break;
        }
   
    }
    else{
        alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    BOOL playSound = NO;
    if (!self.lastPlaySoundDate || timeInterval >= 3) {
        self.lastPlaySoundDate = [NSDate date];
        playSound = YES;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:kMessageType];
    [userInfo setObject:message.conversationId forKey:kConversationChatter];
    
    //发送本地推送
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        if (playSound) {
            content.sound = [UNNotificationSound defaultSound];
        }
        content.body =alertBody;
        content.userInfo = userInfo;
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:message.messageId content:content trigger:trigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
    }
    else {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date]; //触发通知的时间
        notification.alertBody = alertBody;
        notification.alertAction = NSLocalizedString(@"open", @"Open");
        notification.timeZone = [NSTimeZone defaultTimeZone];
        if (playSound) {
            notification.soundName = UILocalNotificationDefaultSoundName;
        }
        notification.userInfo = userInfo;
        
        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

/**获取所有未读消息数量*/
- (CGFloat)getAllUnreadMessageCount {
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    
    //    UIApplication *application = [UIApplication sharedApplication];
    //    [application setApplicationIconBadgeNumber:unreadCount];
    return unreadCount;
}


@end
