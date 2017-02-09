//
//  WJIMMessageReadManager.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/9.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMMessageReadManager.h"

@implementation WJIMMessageReadManager

+ (instancetype)shareManager {
    
    static dispatch_once_t onceToken;
    static WJIMMessageReadManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[WJIMMessageReadManager alloc]init];
    });
    return manager;
}


- (BOOL)prepareMessageAudioModel:(WJIMMessageModel *)messageModel
            updateViewCompletion:(void (^)(WJIMMessageModel *prevAudioModel, WJIMMessageModel *currentAudioModel))updateCompletion
{
    BOOL isPrepare = NO;
    
    if(messageModel.bodyType == EMMessageBodyTypeVoice)
    {
        WJIMMessageModel *prevAudioModel = self.audioMessageModel;
        WJIMMessageModel *currentAudioModel = messageModel;
        self.audioMessageModel = messageModel;
        
        BOOL isPlaying = messageModel.isMediaPlaying;
        if (isPlaying) {
            messageModel.isMediaPlaying = NO;
            self.audioMessageModel = nil;
            currentAudioModel = nil;
            [[EMCDDeviceManager sharedInstance] stopPlaying];
        }
        else {
            messageModel.isMediaPlaying = YES;
            prevAudioModel.isMediaPlaying = NO;
            isPrepare = YES;
            
            if (!messageModel.isMediaPlayed) {
                messageModel.isMediaPlayed = YES;
                EMMessage *chatMessage = messageModel.message;
                if (chatMessage.ext) {
                    NSMutableDictionary *dict = [chatMessage.ext mutableCopy];
                    if (![[dict objectForKey:@"isPlayed"] boolValue]) {
                        [dict setObject:@YES forKey:@"isPlayed"];
                        chatMessage.ext = dict;
                        [[EMClient sharedClient].chatManager updateMessage:chatMessage completion:nil];
                    }
                } else {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:chatMessage.ext];
                    [dic setObject:@YES forKey:@"isPlayed"];
                    chatMessage.ext = dic;
                    [[EMClient sharedClient].chatManager updateMessage:chatMessage completion:nil];
                }
            }
        }
        
        if (updateCompletion) {
            updateCompletion(prevAudioModel, currentAudioModel);
        }
    }
    
    return isPrepare;
}

- (WJIMMessageModel *)stopMessageAudioModel
{
    WJIMMessageModel *model = nil;
    if (self.audioMessageModel.bodyType == EMMessageBodyTypeVoice) {
        if (self.audioMessageModel.isMediaPlaying) {
            model = self.audioMessageModel;
        }
        self.audioMessageModel.isMediaPlaying = NO;
        self.audioMessageModel = nil;
    }
    
    return model;
}

@end
