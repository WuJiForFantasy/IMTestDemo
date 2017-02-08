//
//  WJIMChatCellUtil.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/8.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMChatCellUtil.h"

@implementation WJIMChatCellUtil

+ (CGFloat)cellHeightForMsg:(id)msg {
    
    CGFloat height = 44;
    if ([msg isKindOfClass:[WJIMMessageModel class]]) {
        WJIMMessageModel *tmpMsg = (WJIMMessageModel *)msg;
        switch (tmpMsg.bodyType) {
            case EMMessageBodyTypeText:
               height = [WJIMChatTextMsgCell cellHeight];
                break;
            case EMMessageBodyTypeImage:
                height = [WJIMChatPicMsgCell cellHeight];
                break;
            case EMMessageBodyTypeVideo:
                height = [WJIMChatVideoMsgCell cellHeight];
                break;
            case EMMessageBodyTypeLocation:
                height = [WJIMChatLocationMsgCell cellHeight];
                break;
            case EMMessageBodyTypeVoice:
                 height = [WJIMChatAudioMsgCell cellHeight];
                break;
            case EMMessageBodyTypeFile:
                break;
            case EMMessageBodyTypeCmd:
                break;
            default:
                break;
        }
    }
    return height;
}

+ (UITableViewCell *)tableView:(UITableView *)tableView cellForMsg:(id)msg {
    
    if ([msg isKindOfClass:[WJIMMessageModel class]]) {
        WJIMChatBaseCell *cell = nil;
        WJIMMessageModel *tmpMsg = (WJIMMessageModel *)msg;
        
        switch (tmpMsg.bodyType) {
            case EMMessageBodyTypeText:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"IMTextMsg"];
                if(cell == nil){
                    cell = [[WJIMChatTextMsgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IMTextMsg"];
                }
                [cell setIMMessage:tmpMsg];
            }
                break;
            case EMMessageBodyTypeImage:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"IMPicMsg"];
                if(cell == nil){
                    cell = [[WJIMChatPicMsgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IMPicMsg"];
                }
                [cell setIMMessage:tmpMsg];
            }
                break;
            case EMMessageBodyTypeVideo:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"IMVideoMsg"];
                if(cell == nil){
                    cell = [[WJIMChatVideoMsgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IMVideoMsg"];
                }
                [cell setIMMessage:tmpMsg];
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"IMLocationMsg"];
                if(cell == nil){
                    cell = [[WJIMChatLocationMsgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IMLocationMsg"];
                }
                [cell setIMMessage:tmpMsg];
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"IMVoiceMsg"];
                if(cell == nil){
                    cell = [[WJIMChatAudioMsgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IMVoiceMsg"];
                }
                [cell setIMMessage:tmpMsg];
            }
                break;
            case EMMessageBodyTypeFile:
            case EMMessageBodyTypeCmd:
            default:
            {
                cell = [[WJIMChatBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test"];
            }
                break;
        }
        return cell;
    }
    else if ([msg isKindOfClass:[NSString class]]) {
        
        WJIMChatTimeCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"TimeLabel"];
        if(cell == nil)
        {
            cell = [[WJIMChatTimeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TimeLabel"];
        }
        [cell setTimeText:msg];
        return cell;
    }
    else {
        
        return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test"];
    }
}

@end
