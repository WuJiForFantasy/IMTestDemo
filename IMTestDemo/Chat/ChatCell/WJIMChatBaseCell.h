//
//  WJIMChatBaseCell.h
//  IMTestDemo
//
//  Created by tqh on 2017/2/7.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJIMMessageModel.h"
#import "WJIMChatBorderManager.h"
#import "UIView+IM.h"
@protocol WJIMChatBaseCellDelegate;
/**聊天cell的基类
 1.注意调用添加消息后把cellHeight赋值
 2.注意高度调用 [WJIMChatBaseCell cellHeight]
 3.集合了群聊，单聊，聊天室的布局～～～～～
 */

static CGFloat cellHeight = 0;//计算cell的高度，静态变量

@interface WJIMChatBaseCell : UITableViewCell

@property (nonatomic,strong) id<IMessageModel> message;             //环信聊天消息
@property (nonatomic,strong) UIActivityIndicatorView *activity;     //消息发送时的圈圈
@property (nonatomic,strong) UIImageView *avatarView;               //头像
@property (nonatomic,strong) UIView *footerView;                    //底部
@property (nonatomic,strong) UIView *headerView;                    //头部
@property (nonatomic,strong) UILabel *timeLabel;                    //时间
@property (nonatomic,strong) UIButton *errorView;                   //错误视图
@property (nonatomic,strong) UIButton *readView;                    //阅读状态视图
@property (nonatomic,strong) UIButton *bodyBgView;                  //文本区域
@property (nonatomic,assign) CGFloat cellHeight;                    //高度属性
@property (nonatomic,weak) id<WJIMChatBaseCellDelegate>delegate;    //代理

#pragma mark - public

- (void)setIMMessage:(id<IMessageModel>)message;
//- (void)changeIMMessage:(id<IMessageModel>)message;
//基础的坐标范围
- (WJIMChatBorderManager *)borderImageAndFrame;

//刷新基础布局
- (void)baseFrameLayout;

//cell的高度
+ (CGFloat)cellHeight;

@end

@protocol WJIMChatBaseCellDelegate <NSObject>

@optional

/** 气泡选中 */
- (void)messageCellSelected:(id<IMessageModel>)model;

/** 气泡选中 */
- (void)messageCellSelected:(id<IMessageModel>)model cell:(WJIMChatBaseCell *)cell;

/** 状态点击 */
- (void)statusButtonSelcted:(id<IMessageModel>)model withMessageCell:(id)messageCell;

/** 头像点击 */
- (void)avatarViewSelcted:(id<IMessageModel>)model;

/** 错误点击 */
- (void)errorViewSelcted:(id<IMessageModel>)model;

@end
