//
//  WJIMMessageReadManager.h
//  IMTestDemo
//
//  Created by tqh on 2017/2/9.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMCDDeviceManager.h"

/**
 消息阅读管理
 */
@interface WJIMMessageReadManager : NSObject

@property (strong, nonatomic) WJIMMessageModel *audioMessageModel;

+ (instancetype)shareManager;

/*!
 @method
 @brief 语音消息是否可以播放
 @discussion 若传入的语音消息正在播放，停止播放并重置isMediaPlaying，返回NO；否则当前语音消息isMediaPlaying设为yes，记录的上一条语音消息isMediaPlaying重置，更新消息ext，返回yes
 @param messageModel   选中的语音消息model
 @param updateCompletion  语音消息model更新后的回调
 */
- (BOOL)prepareMessageAudioModel:(WJIMMessageModel *)messageModel
            updateViewCompletion:(void (^)(WJIMMessageModel *prevAudioModel, WJIMMessageModel *currentAudioModel))updateCompletion;

/*!
 @method
 @brief 重置正在播放状态为NO，返回对应的语音消息model
 @discussion 重置正在播放状态为NO，返回对应的语音消息model，若当前记录的消息不为语音消息，返回nil
 @return  返回修改后的语音消息model
 */
- (WJIMMessageModel *)stopMessageAudioModel;

@end
