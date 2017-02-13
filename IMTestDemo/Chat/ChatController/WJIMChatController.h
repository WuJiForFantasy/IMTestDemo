//
//  WJIMChatController.h
//  IMTestDemo
//
//  Created by tqh on 2017/2/6.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 聊天控制器
 */
@interface WJIMChatController : UIViewController

/**根据环信ID初始化聊天控制器*/
- (instancetype)initWithConversationChatter:(NSString *)conversationChatter
                           conversationType:(EMConversationType)conversationType;
@end
