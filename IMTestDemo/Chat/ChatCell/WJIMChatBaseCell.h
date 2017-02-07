//
//  WJIMChatBaseCell.h
//  IMTestDemo
//
//  Created by tqh on 2017/2/7.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJIMMessageModel.h"

/**聊天cell的基类
 1.注意调用添加消息后把cellHeight赋值
 2.注意高度调用 [WJIMChatBaseCell cellHeight]
 3.more~~~
 */

static CGFloat cellHeight = 0;//计算cell的高度，静态变量

@interface WJIMChatBaseCell : UITableViewCell

@property (nonatomic,strong) id<IMessageModel> msg;          //环信聊天消息
@property (nonatomic,strong) UIActivityIndicatorView *activity;  //消息发送时的圈圈
@property (nonatomic,strong) UIImageView *avatarView; //头像
@property (nonatomic,strong) UIView *footerView;      //底部
@property (nonatomic,strong) UIView *headerView;      //底部
@property (nonatomic,strong) UILabel *timeLabel;//时间
@property (nonatomic,strong) UIButton *errorView;       //错误视图
@property (nonatomic,strong) UIButton *readView;        //阅读状态视图
@property (nonatomic,strong) UIButton *bodyBgView;    //文本区域
@property (nonatomic,assign) CGFloat cellHeight;//高度属性

- (void)setMessage:(id<IMessageModel>)message;

@end
