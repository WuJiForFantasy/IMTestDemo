//
//  WJIMChatBaseCell.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/7.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMChatBaseCell.h"

@implementation WJIMChatBaseCell

- (void)setMessage:(id<IMessageModel>)message {

    self.textLabel.text = message.text;
}

@end
