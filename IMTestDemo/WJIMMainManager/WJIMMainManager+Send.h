//
//  WJIMMainManager+Send.h
//  IMTestDemo
//
//  Created by tqh on 2017/1/7.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMMainManager.h"

/**
 创建发送消息发送消息的类目
 */
@interface WJIMMainManager (Send)

#pragma mark - send message

/*!
 @method
 @brief 构建待发送的文本消息
 @discussion        向环信id为to的用户发送文本消息
 @param text        待发送的文本信息
 @param to          消息的接收方环信id
 @param messageType 消息的聊天类型
 @param messageExt  消息的扩展属性
 @result 返回构建完成的消息
 */
+ (EMMessage *)sendTextMessage:(NSString *)text
                            to:(NSString *)to
                   messageType:(EMChatType)messageType
                    messageExt:(NSDictionary *)messageExt;

/*!
 @method
 @brief 构建待发送的透传消息
 @discussion        向环信id为to的用户发送透传消息
 @param action      透传消息的命令内容
 @param to          消息的接收方环信id
 @param messageType 消息的聊天类型
 @param messageExt  消息的扩展属性
 @param params   透传消息命令参数，只是为了兼容老版本，应该使用EMMessage的扩展属性来代替
 @result 返回构建完成的消息
 */
+ (EMMessage *)sendCmdMessage:(NSString *)action
                           to:(NSString *)to
                  messageType:(EMChatType)messageType
                   messageExt:(NSDictionary *)messageExt
                    cmdParams:(NSArray *)params;

/*!
 @method
 @brief 构建待发送的位置消息
 @discussion        向环信id为to的用户发送位置消息
 @param latitude    纬度
 @param longitude   经度
 @param address     地址信息
 @param to          消息的接收方环信id
 @param messageType 消息的聊天类型
 @param messageExt  消息的扩展属性
 @result 返回构建完成的消息
 */
+ (EMMessage *)sendLocationMessageWithLatitude:(double)latitude
                                     longitude:(double)longitude
                                       address:(NSString *)address
                                            to:(NSString *)to
                                   messageType:(EMChatType)messageType
                                    messageExt:(NSDictionary *)messageExt;

/*!
 @method
 @brief 构建待发送的图片消息
 @discussion        向环信id为to的用户发送图片消息
 @param imageData   图片数据(NSData对象)
 @param to          消息的接收方环信id
 @param messageType 消息的聊天类型
 @param messageExt  消息的扩展属性
 @result 返回构建完成的消息
 */
+ (EMMessage *)sendImageMessageWithImageData:(NSData *)imageData
                                          to:(NSString *)to
                                 messageType:(EMChatType)messageType
                                  messageExt:(NSDictionary *)messageExt;

/*!
 @method
 @brief 构建待发送的图片消息
 @discussion        向环信id为to的用户发送图片消息
 @param image       图片(UIImage对象)
 @param to          消息的接收方环信id
 @param messageType 消息的聊天类型
 @param messageExt  消息的扩展属性
 @result 返回构建完成的消息
 */
+ (EMMessage *)sendImageMessageWithImage:(UIImage *)image
                                      to:(NSString *)to
                             messageType:(EMChatType)messageType
                              messageExt:(NSDictionary *)messageExt;

/*!
 @method
 @brief 构建待发送的语音消息
 @discussion        向环信id为to的用户发送语音消息
 @param localPath   录制的语音文件本地路径
 @param duration    语音时长
 @param to          消息的接收方环信id
 @param messageType 消息的聊天类型
 @param messageExt  消息的扩展属性
 @result 返回构建完成的消息
 */
+ (EMMessage *)sendVoiceMessageWithLocalPath:(NSString *)localPath
                                    duration:(NSInteger)duration
                                          to:(NSString *)to
                                 messageType:(EMChatType)messageType
                                  messageExt:(NSDictionary *)messageExt;

/*!
 @method
 @brief 构建待发送的视频消息
 @discussion        向环信id为to的用户发送视频消息
 @param url         视频文件本地路径url
 @param to          消息的接收方环信id
 @param messageType 消息的聊天类型
 @param messageExt  消息的扩展属性
 @result 返回构建完成的消息
 */
+ (EMMessage *)sendVideoMessageWithURL:(NSURL *)url
                                    to:(NSString *)to
                           messageType:(EMChatType)messageType
                            messageExt:(NSDictionary *)messageExt;

@end
