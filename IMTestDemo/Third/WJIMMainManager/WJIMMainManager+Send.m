//
//  WJIMMainManager+Send.m
//  IMTestDemo
//
//  Created by tqh on 2017/1/7.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMMainManager+Send.h"
#import "EaseConvertToCommonEmoticonsHelper.h"  //emoji表情转换

@implementation WJIMMainManager (Send)

#pragma mark - send message

+ (EMMessage *)sendTextMessage:(NSString *)text
                            to:(NSString *)toUser
                   messageType:(EMChatType)messageType
                    messageExt:(NSDictionary *)messageExt

{
    NSString *willSendText = [EaseConvertToCommonEmoticonsHelper convertToCommonEmoticons:text];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:willSendText];
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:toUser from:from to:toUser body:body ext:messageExt];
    message.chatType = messageType;
    
    return message;
}

+ (EMMessage *)sendCmdMessage:(NSString *)action
                           to:(NSString *)to
                  messageType:(EMChatType)messageType
                   messageExt:(NSDictionary *)messageExt
                    cmdParams:(NSArray *)params
{
    EMCmdMessageBody *body = [[EMCmdMessageBody alloc] initWithAction:action];
    if (params) {
        body.params = params;
    }
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:to from:from to:to body:body ext:messageExt];
    message.chatType = messageType;
    
    return message;
}

+ (EMMessage *)sendLocationMessageWithLatitude:(double)latitude
                                     longitude:(double)longitude
                                       address:(NSString *)address
                                            to:(NSString *)to
                                   messageType:(EMChatType)messageType
                                    messageExt:(NSDictionary *)messageExt
{
    EMLocationMessageBody *body = [[EMLocationMessageBody alloc] initWithLatitude:latitude longitude:longitude address:address];
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:to from:from to:to body:body ext:messageExt];
    message.chatType = messageType;
    
    return message;
}

+ (EMMessage *)sendImageMessageWithImageData:(NSData *)imageData
                                          to:(NSString *)to
                                 messageType:(EMChatType)messageType
                                  messageExt:(NSDictionary *)messageExt
{
    EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithData:imageData displayName:@"image.png"];
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:to from:from to:to body:body ext:messageExt];
    message.chatType = messageType;
    
    return message;
}

+ (EMMessage *)sendImageMessageWithImage:(UIImage *)image
                                      to:(NSString *)to
                             messageType:(EMChatType)messageType
                              messageExt:(NSDictionary *)messageExt
{
    NSData *data = UIImageJPEGRepresentation(image, 1);
    
    return [self sendImageMessageWithImageData:data to:to messageType:messageType messageExt:messageExt];
}

+ (EMMessage *)sendVoiceMessageWithLocalPath:(NSString *)localPath
                                    duration:(NSInteger)duration
                                          to:(NSString *)to
                                 messageType:(EMChatType)messageType
                                  messageExt:(NSDictionary *)messageExt
{
    EMVoiceMessageBody *body = [[EMVoiceMessageBody alloc] initWithLocalPath:localPath displayName:@"audio"];
    body.duration = (int)duration;
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:to from:from to:to body:body ext:messageExt];
    message.chatType = messageType;
    
    return message;
}

+ (EMMessage *)sendVideoMessageWithURL:(NSURL *)url
                                    to:(NSString *)to
                           messageType:(EMChatType)messageType
                            messageExt:(NSDictionary *)messageExt
{
    EMVideoMessageBody *body = [[EMVideoMessageBody alloc] initWithLocalPath:[url path] displayName:@"video.mp4"];
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:to from:from to:to body:body ext:messageExt];
    message.chatType = messageType;
    
    return message;
}


@end
