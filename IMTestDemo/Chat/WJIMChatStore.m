//
//  WJIMChatStore.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/6.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMChatStore.h"
#import "WJIMMainManager.h"

@interface WJIMChatStore () <WJIMMainManagerChatDelegate>

{
    dispatch_queue_t _messageQueue; //线程
}

@property (nonatomic) NSTimeInterval messageTimeIntervalTag; //时间间隔标记

@end

@implementation WJIMChatStore

- (instancetype)initWithConversationChatter:(NSString *)conversationChatter
                           conversationType:(EMConversationType)conversationType {
    self = [super init];
    if (self) {
        //创建会话
        self.conversation = [[EMClient sharedClient].chatManager getConversation:conversationChatter type:conversationType createIfNotExist:YES];
        //将所有消息设置为已读
        [self.conversation markAllMessagesAsRead:nil];
        _messageQueue = dispatch_queue_create("tqh.com", NULL);
        
    }
    return self;
}

//创建聊天监听
- (void)setupChat {
    
    [WJIMMainManager shareManager].delegate = self;
}

- (void)destroyChat {
    
    [WJIMMainManager shareManager].delegate = nil;
}

#pragma mark - <WJIMMainManagerChatDelegate>

/*!
 *  \~chinese
 *  收到消息
 */
- (void)messagesDidReceive:(NSArray *)aMessages {
    
    for (EMMessage *message in aMessages) {
        if ([self.conversation.conversationId isEqualToString:message.conversationId]) {
            
            //添加消息到消息数组中
            [self addMessageToDataSource:message progress:nil];
            
            //发送消息已读回执
            [self _sendHasReadResponseForMessages:@[message]
                                           isRead:NO];
            
            //将未读的消息设置为已读
            if ([self _shouldMarkMessageAsRead])
            {
                [self.conversation markMessageAsReadWithId:message.messageId error:nil];
            }
        }
    }
}

/*!
 *  \~chinese
 *  收到Cmd消息
 */
- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages {
    
    for (EMMessage *message in aCmdMessages) {
        if ([self.conversation.conversationId isEqualToString:message.conversationId]) {
            NSLog(@"在聊天页面收到cmd消息");
            break;
        }
    }
}

/*!
 *  \~chinese
 *  收到已读回执
 */
- (void)messagesDidRead:(NSArray *)aMessages {

    for(EMMessage *message in aMessages){
        //替换消息模型，更换消息状态
        [self _updateMessageStatus:message];
    }
}

/*!
 *  \~chinese
 *  收到消息送达回执
 */
- (void)messagesDidDeliver:(NSArray *)aMessages {

    for (EMMessage *message in aMessages) {
        if (![self.conversation.conversationId isEqualToString:message.conversationId]){
            continue;
        }
        
        //将消息未读状态变为已读状态
        __block id<IMessageModel> model = nil;
        __block BOOL isHave = NO;
        [self.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
             if ([obj conformsToProtocol:@protocol(IMessageModel)])
             {
                 model = (id<IMessageModel>)obj;
                 if ([model.messageId isEqualToString:message.messageId])
                 {
                     model.message.isReadAcked = YES;
                     isHave = YES;
                     *stop = YES;
                 }
             }
         }];
        
        if(!isHave){
            return;
        }

        if (self.delegate && [self.delegate respondsToSelector:@selector(IMChatStoreIsTableViewReloadData)]) {
            [self.delegate IMChatStoreIsTableViewReloadData];
        }

    }
}

/*!
 *  \~chinese
 *  消息状态发生变化
 */
- (void)messageStatusDidChange:(EMMessage *)aMessage
                         error:(EMError *)aError {
    //替换消息模型，更换消息状态
    [self _updateMessageStatus:aMessage];
}

/*!
 *  \~chinese
 *  消息附件状态发生改变
 */
- (void)messageAttachmentStatusDidChange:(EMMessage *)aMessage
                                   error:(EMError *)aError {
    //判断图片缩略图，视频缩略图，音频文件的下载状态，成功就刷新数据
    if (!aError) {
        EMFileMessageBody *fileBody = (EMFileMessageBody*)[aMessage body];
        if ([fileBody type] == EMMessageBodyTypeImage) {
            EMImageMessageBody *imageBody = (EMImageMessageBody *)fileBody;
            if ([imageBody thumbnailDownloadStatus] == EMDownloadStatusSuccessed)
            {
                [self _reloadTableViewDataWithMessage:aMessage];
            }
        }else if([fileBody type] == EMMessageBodyTypeVideo){
            EMVideoMessageBody *videoBody = (EMVideoMessageBody *)fileBody;
            if ([videoBody thumbnailDownloadStatus] == EMDownloadStatusSuccessed)
            {
                [self _reloadTableViewDataWithMessage:aMessage];
            }
        }else if([fileBody type] == EMMessageBodyTypeVoice){
            if ([fileBody downloadStatus] == EMDownloadStatusSuccessed)
            {
                [self _reloadTableViewDataWithMessage:aMessage];
            }
        }
        
    }else{
        
    }
}

#pragma mark - others

- (BOOL)_shouldMarkMessageAsRead
{
    BOOL isMark = YES;
  
        if (([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) || !self.isViewDidAppear)
        {
            isMark = NO;
        }
    
    return isMark;
}

- (NSArray *)formatMessages:(NSArray *)messages
{
    NSMutableArray *formattedArray = [[NSMutableArray alloc] init];
    if ([messages count] == 0) {
        return formattedArray;
    }
    
    for (EMMessage *message in messages) {
        //Calculate time interval
        CGFloat interval = (self.messageTimeIntervalTag - message.timestamp) / 1000;
        if (self.messageTimeIntervalTag < 0 || interval > 60 || interval < -60) {
            double timeInterval = (NSTimeInterval)message.timestamp;
            if((NSTimeInterval)message.timestamp > 140000000000) {
                timeInterval = (NSTimeInterval)message.timestamp / 1000;
            }
            NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
     
            NSString *timeStr = @"";
            timeStr = [messageDate formattedTime];

            [formattedArray addObject:timeStr];
            self.messageTimeIntervalTag = message.timestamp;
        }
        
        //Construct message model
        id<IMessageModel> model = nil;

            model = [[WJIMMessageModel alloc] initWithMessage:message];

        if (model) {
            [formattedArray addObject:model];
        }
    }
    
    return formattedArray;
}

-(void)addMessageToDataSource:(EMMessage *)message
                     progress:(id)progress
{
    [self.messsagesSource addObject:message];
    
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(_messageQueue, ^{
        NSArray *messages = [weakSelf formatMessages:@[message]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.dataArray addObjectsFromArray:messages];
            if (self.delegate && [self.delegate respondsToSelector:@selector(IMChatStoreIsTableViewScrollToRowAtIndexPath:)]) {
                [self.delegate IMChatStoreIsTableViewScrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[weakSelf.dataArray count] - 1 inSection:0]];
            }
        });
    });
}

- (void)_sendHasReadResponseForMessages:(NSArray*)messages
                                 isRead:(BOOL)isRead
{
    NSMutableArray *unreadMessages = [NSMutableArray array];
    for (NSInteger i = 0; i < [messages count]; i++)
    {
        EMMessage *message = messages[i];
        BOOL isSend = YES;

        isSend = [self shouldSendHasReadAckForMessage:message
                                                 read:isRead];
        
        if (isSend)
        {
            [unreadMessages addObject:message];
        }
    }
    
    if ([unreadMessages count])
    {
        for (EMMessage *message in unreadMessages)
        {
            [[EMClient sharedClient].chatManager sendMessageReadAck:message completion:nil];
        }
    }
}

/*!
 @method
 @brief 传入消息是否需要发动已读回执
 @param message  待判断的消息
 @param read     消息是否已读
 */
- (BOOL)shouldSendHasReadAckForMessage:(EMMessage *)message
                                  read:(BOOL)read
{
    NSString *account = [[EMClient sharedClient] currentUsername];
    if (message.chatType != EMChatTypeChat || message.isReadAcked || [account isEqualToString:message.from] || ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) || !self.isViewDidAppear)
    {
        return NO;
    }
    
    EMMessageBody *body = message.body;
    if (((body.type == EMMessageBodyTypeVideo) ||
         (body.type == EMMessageBodyTypeVoice) ||
         (body.type == EMMessageBodyTypeImage)) &&
        !read)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)_reloadTableViewDataWithMessage:(EMMessage *)message
{
    if ([self.conversation.conversationId isEqualToString:message.conversationId])
    {
        for (int i = 0; i < self.dataArray.count; i ++) {
            id object = [self.dataArray objectAtIndex:i];
            if ([object isKindOfClass:[WJIMMessageModel class]]) {
                id<IMessageModel> model = object;
                if ([message.messageId isEqualToString:model.messageId]) {
                    id<IMessageModel> model = nil;
                    model = [[WJIMMessageModel alloc] initWithMessage:message];

                    [self.dataArray replaceObjectAtIndex:i withObject:model];
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(IMChatStoreIsTableViewReloadRowsAtIndexPaths:)]) {
                        [self.delegate IMChatStoreIsTableViewReloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]]];
                    }
                    
                    break;
                }
            }
        }
    }
}

//通过消息模型更新消息状态
- (void)_updateMessageStatus:(EMMessage *)aMessage
{
    BOOL isChatting = [aMessage.conversationId isEqualToString:self.conversation.conversationId];
    if (aMessage && isChatting) {
        id<IMessageModel> model = nil;
  
        //初始化头像和昵称
        model = [[WJIMMessageModel alloc] initWithMessage:aMessage];
       
        if (model) {
            __block NSUInteger index = NSNotFound;
            [self.dataArray enumerateObjectsUsingBlock:^(WJIMMessageModel *model, NSUInteger idx, BOOL *stop){
                if ([model conformsToProtocol:@protocol(IMessageModel)]) {
                    if ([aMessage.messageId isEqualToString:model.message.messageId])
                    {
                        index = idx;
                        *stop = YES;
                    }
                }
            }];
            
            if (index != NSNotFound)
            {
                [self.dataArray replaceObjectAtIndex:index withObject:model];
                //刷新列表
                if (self.delegate && [self.delegate respondsToSelector:@selector(IMChatStoreIsTableViewReloadRowsAtIndexPaths:)]) {
                    [self.delegate IMChatStoreIsTableViewReloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
                }
                
            }
        }
    }
}

/*!
 @method
 @brief 通过当前会话类型，返回消息聊天类型
 */

- (EMChatType)_messageTypeFromConversationType
{
    EMChatType type = EMChatTypeChat;
    switch (self.conversation.type) {
        case EMConversationTypeChat:
            type = EMChatTypeChat;
            break;
        case EMConversationTypeGroupChat:
            type = EMChatTypeGroupChat;
            break;
        case EMConversationTypeChatRoom:
            type = EMChatTypeChatRoom;
            break;
        default:
            break;
    }
    return type;
}

#pragma mark - 懒加载

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)messsagesSource {
    if (!_messsagesSource) {
        _messsagesSource = [NSMutableArray array];
    }
    return _messsagesSource;
}

@end
