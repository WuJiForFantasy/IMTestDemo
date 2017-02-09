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
    dispatch_queue_t _messageQueue; //消息线程
}

@property (nonatomic) NSInteger messageCountOfPage; //default 20

@end

@implementation WJIMChatStore

- (instancetype)initWithConversationChatter:(NSString *)conversationChatter
                           conversationType:(EMConversationType)conversationType {
    self = [super init];
    if (self) {
        self.messageCountOfPage = 20;
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

- (void)reloadMessageData {
    self.messageTimeIntervalTag = -1;
    NSString *messageId = nil;
    if ([self.messsagesSource count] > 0) {
        messageId = [(EMMessage *)self.messsagesSource.firstObject messageId];
    }
    else {
        messageId = nil;
    }
    //加载历史消息默认条数
    [self _loadMessagesBefore:messageId count:self.messageCountOfPage append:YES];
    //刷新头部
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


- (void)_loadMessagesBefore:(NSString*)messageId
                      count:(NSInteger)count
                     append:(BOOL)isAppend
{
    __weak typeof(self) weakSelf = self;
    void (^refresh)(NSArray *messages) = ^(NSArray *messages) {
        dispatch_async(_messageQueue, ^{
            //Format the message
            NSArray *formattedMessages = [weakSelf formatMessages:messages];
            
            //Refresh the page
            dispatch_async(dispatch_get_main_queue(), ^{
                typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    NSInteger scrollToIndex = 0;
                    if (isAppend) {
                        [strongSelf.messsagesSource insertObjects:messages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [messages count])]];
                        
                        //Combine the message
                        id object = [strongSelf.dataArray firstObject];
                        if ([object isKindOfClass:[NSString class]]) {
                            NSString *timestamp = object;
                            [formattedMessages enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id model, NSUInteger idx, BOOL *stop) {
                                if ([model isKindOfClass:[NSString class]] && [timestamp isEqualToString:model]) {
                                    [strongSelf.dataArray removeObjectAtIndex:0];
                                    *stop = YES;
                                }
                            }];
                        }
                        scrollToIndex = [strongSelf.dataArray count];
                        [strongSelf.dataArray insertObjects:formattedMessages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [formattedMessages count])]];
                    }
                    else {
                        [strongSelf.messsagesSource removeAllObjects];
                        [strongSelf.messsagesSource addObjectsFromArray:messages];
                        
                        [strongSelf.dataArray removeAllObjects];
                        [strongSelf.dataArray addObjectsFromArray:formattedMessages];
                    }
                    
                    EMMessage *latest = [strongSelf.messsagesSource lastObject];
                    strongSelf.messageTimeIntervalTag = latest.timestamp;
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(IMChatStoreIsTableViewScrollToRowAtIndexPath:animated:)]) {
                        [self.delegate IMChatStoreIsTableViewScrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count] - scrollToIndex - 1 inSection:0] animated:NO];
                    }
                }
            });
            
            //re-download all messages that are not successfully downloaded
            for (EMMessage *message in messages)
            {
                [weakSelf _downloadMessageAttachments:message];
            }
            
            //send the read acknoledgement
            [weakSelf _sendHasReadResponseForMessages:messages
                                               isRead:NO];
        });
    };
    
    [self.conversation loadMessagesStartFromId:messageId count:(int)count searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
        if (!aError && [aMessages count]) {
            refresh(aMessages);
        }
    }];
}


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
            if (self.delegate && [self.delegate respondsToSelector:@selector(IMChatStoreIsTableViewScrollToRowAtIndexPath:animated:)]) {
                [self.delegate IMChatStoreIsTableViewScrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[weakSelf.dataArray count] - 1 inSection:0] animated:YES];
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

/*!
 @method
 @brief 下载消息附件
 @param message  待下载附件的消息
 */
- (void)_downloadMessageAttachments:(EMMessage *)message
{
    __weak typeof(self) weakSelf = self;
    void (^completion)(EMMessage *aMessage, EMError *error) = ^(EMMessage *aMessage, EMError *error) {
        if (!error)
        {
            [weakSelf _reloadTableViewDataWithMessage:message];
        }
        else
        {
            NSLog(@"聊天界面中:thumbnail for failure!");

        }
    };
    
    EMMessageBody *messageBody = message.body;
    if ([messageBody type] == EMMessageBodyTypeImage) {
        EMImageMessageBody *imageBody = (EMImageMessageBody *)messageBody;
        if (imageBody.thumbnailDownloadStatus > EMDownloadStatusSuccessed)
        {
            //download the message thumbnail
            [[[EMClient sharedClient] chatManager] downloadMessageThumbnail:message progress:nil completion:completion];
        }
    }
    else if ([messageBody type] == EMMessageBodyTypeVideo)
    {
        EMVideoMessageBody *videoBody = (EMVideoMessageBody *)messageBody;
        if (videoBody.thumbnailDownloadStatus > EMDownloadStatusSuccessed)
        {
            //download the message thumbnail
            [[[EMClient sharedClient] chatManager] downloadMessageThumbnail:message progress:nil completion:completion];
        }
    }
    else if ([messageBody type] == EMMessageBodyTypeVoice)
    {
        EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody*)messageBody;
        if (voiceBody.downloadStatus > EMDownloadStatusSuccessed)
        {
            //download the message attachment
            [[EMClient sharedClient].chatManager downloadMessageAttachment:message progress:nil completion:^(EMMessage *message, EMError *error) {
                if (!error) {
                    [weakSelf _reloadTableViewDataWithMessage:message];
                }
                else {
                    NSLog(@"聊天界面中：voice for failure!");
//                    [weakSelf showHint:NSEaseLocalizedString(@"message.voiceFail", @"voice for failure!")];
                }
            }];
        }
    }
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
