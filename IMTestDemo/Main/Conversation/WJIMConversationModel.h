//
//  WJIMConversationModel.h
//  IMTestDemo
//
//  Created by tqh on 2017/2/11.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IConversationModel.h"

@interface WJIMConversationModel : NSObject <IConversationModel>

/** @brief 会话对象 */
@property (strong, nonatomic, readonly) EMConversation *conversation;
/** @brief 会话的标题(主要用户UI显示) */
@property (strong, nonatomic) NSString *title;
/** @brief conversationId的头像url */
@property (strong, nonatomic) NSString *avatarURLPath;
/** @brief conversationId的头像 */
@property (strong, nonatomic) UIImage *avatarImage;
@property (nonatomic,copy) NSString *content;           //内容
@property (nonatomic,assign) NSTimeInterval dateTime;   //时间戳
@property (nonatomic,strong) WJIMNotifyChatGroupModel *group;

- (instancetype)initWithConversation:(EMConversation *)conversation;

@end
