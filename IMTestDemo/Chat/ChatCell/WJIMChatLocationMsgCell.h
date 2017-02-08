//
//  WJIMChatLocationMsgCell.h
//  IMTestDemo
//
//  Created by tqh on 2017/2/8.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMChatBaseCell.h"

/**
 聊天cell的地址定位类
 */
@interface WJIMChatLocationMsgCell : WJIMChatBaseCell

@property (nonatomic,strong)UIImageView *picImage;

@property (nonatomic,strong)UIView *bottomView;

@property (nonatomic,strong)UIButton *locationIcon;

@property (nonatomic,strong)UILabel *locationLabel;

@end
