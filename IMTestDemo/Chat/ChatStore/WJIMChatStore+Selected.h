//
//  WJIMChatStore+Selected.h
//  IMTestDemo
//
//  Created by tqh on 2017/2/9.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMChatStore.h"

/**
 点击图片，视频，音频的下载操作，位置点击的回调
 */
@interface WJIMChatStore (Selected)

- (void)_imageMessageCellSelected:(id<IMessageModel>)model;

- (void)_locationMessageCellSelected:(id<IMessageModel>)model;

- (void)_audioMessageCellSelected:(id<IMessageModel>)model;

- (void)_videoMessageCellSelected:(id<IMessageModel>)model;
@end
