//
//  WJIMChatCellUtil.h
//  IMTestDemo
//
//  Created by tqh on 2017/2/8.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WJIMChatTextMsgCell.h"
#import "WJIMChatBaseCell.h"
#import "WJIMChatTimeCell.h"
#import "WJIMChatPicMsgCell.h"
#import "WJIMChatVideoMsgCell.h"
#import "WJIMChatAudioMsgCell.h"
#import "WJIMChatLocationMsgCell.h"

/**
 cell的工具类
 */
@interface WJIMChatCellUtil : NSObject

/**cell的高的*/
+ (CGFloat)cellHeightForMsg:(id)msg;

/**初始化cell*/
+ (UITableViewCell *)tableView:(UITableView *)tableView cellForMsg:(id)msg;

@end
