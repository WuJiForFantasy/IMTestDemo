//
//  WJIMChatStore+send.h
//  IMTestDemo
//
//  Created by tqh on 2017/2/7.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMChatStore.h"

/**
 发送方法
 */
@interface WJIMChatStore (send)

//发送文本消息
- (void)sendTextMessage:(NSString *)text;
//发送地理位置
- (void)sendLocationMessageLatitude:(double)latitude
                          longitude:(double)longitude
                         andAddress:(NSString *)address;
//发送图片数据
- (void)sendImageMessageWithData:(NSData *)imageData;
//发送图片UIImage
- (void)sendImageMessage:(UIImage *)image;
//发送语音消息
- (void)sendVoiceMessageWithLocalPath:(NSString *)localPath
                             duration:(NSInteger)duration;
//发送视频消息
- (void)sendVideoMessageWithURL:(NSURL *)url;

@end
