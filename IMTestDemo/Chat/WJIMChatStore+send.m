//
//  WJIMChatStore+send.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/7.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMChatStore+send.h"

@implementation WJIMChatStore (send)

/**扩展字段：黑名单，好友，昵称，头像*/
- (NSDictionary *)messageExt {

    return @{@"nickname":@"昵称123",
             @"avatarUrl":@"http://tva2.sinaimg.cn/crop.3.0.634.634.1024/cd516b22jw8fa4mlfynwzj20hs0hm0tr.jpg",
             @"blacklist":@(YES),
             @"friend":@(YES)};
}

- (void)sendTextMessage:(NSString *)text {
    
    EMMessage *message = [WJIMMainManager sendTextMessage:text to:self.conversation.conversationId messageType:[self _messageTypeFromConversationType] messageExt:self.messageExt];
    [self _sendMessage:message];
}

- (void)sendLocationMessageLatitude:(double)latitude
                          longitude:(double)longitude
                         andAddress:(NSString *)address {
    
    EMMessage *message =  [WJIMMainManager sendLocationMessageWithLatitude:latitude longitude:longitude address:address to:self.conversation.conversationId messageType:[self _messageTypeFromConversationType] messageExt:self.messageExt];
    [self _sendMessage:message];
}

- (void)sendImageMessageWithData:(NSData *)imageData {
    
    EMMessage *message = [WJIMMainManager sendImageMessageWithImageData:imageData
                                                                   to:self.conversation.conversationId
                                                          messageType:[self _messageTypeFromConversationType]
                                                           messageExt:self.messageExt];
    [self _sendMessage:message];
}

- (void)sendImageMessage:(UIImage *)image {
    
    EMMessage *message = [WJIMMainManager sendImageMessageWithImage:image
                                                               to:self.conversation.conversationId
                                                      messageType:[self _messageTypeFromConversationType]
                                                       messageExt:self.messageExt];
    [self _sendMessage:message];
}

- (void)sendVoiceMessageWithLocalPath:(NSString *)localPath
                             duration:(NSInteger)duration {
    
    EMMessage *message = [WJIMMainManager sendVoiceMessageWithLocalPath:localPath
                                                             duration:duration
                                                                   to:self.conversation.conversationId
                                                          messageType:[self _messageTypeFromConversationType]
                                                           messageExt:self.messageExt];
    [self _sendMessage:message];
}

- (void)sendVideoMessageWithURL:(NSURL *)url {
 
    EMMessage *message = [WJIMMainManager sendVideoMessageWithURL:url
                                                             to:self.conversation.conversationId
                                                    messageType:[self _messageTypeFromConversationType]
                                                     messageExt:self.messageExt];
    [self _sendMessage:message];
}


//发送消息（可发送任何消息）
- (void)_sendMessage:(EMMessage *)message
{
    if (self.conversation.type == EMConversationTypeGroupChat){
        message.chatType = EMChatTypeGroupChat;
    }
    else if (self.conversation.type == EMConversationTypeChatRoom){
        message.chatType = EMChatTypeChatRoom;
    }
    
    //将消息添加到消息数组
    [self addMessageToDataSource:message
                        progress:nil];
    
    __weak typeof(self) weakself = self;
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
        
        if (!aError) {
            NSLog(@"%@发送消息成功",[self class]);
            [weakself _refreshAfterSentMessage:aMessage];
        }
        else {
            NSLog(@"发送消息出错：~ ~ %@",aError.errorDescription);
            if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(IMChatStoreIsTableViewReloadData)]) {
                [weakself.delegate IMChatStoreIsTableViewReloadData];
            }
        }
    }];
}

//重新发送消息
- (void)resendMessage:(EMMessage *)message {
    
    __weak typeof(self) weakself = self;
    [[[EMClient sharedClient] chatManager] resendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
        if (!error) {
            [weakself _refreshAfterSentMessage:message];
        }
        else {
            if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(IMChatStoreIsTableViewReloadData)]) {
                [weakself.delegate IMChatStoreIsTableViewReloadData];
            }
//            [weakself.tableView reloadData];
        }
    }];
    
//    [self.tableView reloadData];
}

//刷新列表之后发送消息
- (void)_refreshAfterSentMessage:(EMMessage*)aMessage {
    
    if ([self.messsagesSource count] && [EMClient sharedClient].options.sortMessageByServerTime) {
        NSString *msgId = aMessage.messageId;
        EMMessage *last = self.messsagesSource.lastObject;
        if ([last isKindOfClass:[EMMessage class]]) {
            
            __block NSUInteger index = NSNotFound;
            index = NSNotFound;
            [self.messsagesSource enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(EMMessage *obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[EMMessage class]] && [obj.messageId isEqualToString:msgId]) {
                    index = idx;
                    *stop = YES;
                }
            }];
            if (index != NSNotFound) {
                [self.messsagesSource removeObjectAtIndex:index];
                [self.messsagesSource addObject:aMessage];
                //格式化消息
                self.messageTimeIntervalTag = -1;
                NSArray *formattedMessages = [self formatMessages:self.messsagesSource];
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:formattedMessages];
                if (self.delegate && [self.delegate respondsToSelector:@selector(IMChatStoreIsTableViewScrollToRowAtIndexPath:animated:)]) {
                    [self.delegate IMChatStoreIsTableViewScrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count] - 1 inSection:0]animated:NO];
                }
                return;
            }
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(IMChatStoreIsTableViewReloadData)]) {
        [self.delegate IMChatStoreIsTableViewReloadData];
    }
}



@end
