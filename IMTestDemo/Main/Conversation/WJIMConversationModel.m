//
//  WJIMConversationModel.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/11.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMConversationModel.h"

@interface WJIMConversationModel ()

@property (strong, nonatomic) EMConversation *conversation;

@end

@implementation WJIMConversationModel

- (instancetype)initWithConversation:(EMConversation *)conversation {
    self = [super init];
    if (self) {
        self.conversation = conversation;
        self.title = conversation.conversationId;
        self.content = @"内容";
    }
    return self;
}

@end
