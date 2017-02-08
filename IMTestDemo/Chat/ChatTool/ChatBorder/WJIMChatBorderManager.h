//
//  WJIMChatBorderManager.h
//  IMTestDemo
//
//  Created by tqh on 2017/2/8.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WJIMTextMsgCellTextFont [UIFont systemFontOfSize:14]                //文字的大小

//cell上的配置
#define WJCHAT_CELL_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)      //cell宽度
#define WJCHAT_CELL_AVATARWIDTH 40                                          //头像宽度
#define WJCHAT_CELL_PADDING 10                                              //间距
#define WJCHAT_CELL_LEFT_PADDING (40+15)                                    //左边距离
#define WJCHAT_CELL_RIGHT_PADDING (15+WJCHAT_CELL_AVATARWIDTH)              //右边距离
#define WJCHAT_CELL_HEADER 0                                                //header高度
#define WJCHAT_CELL_TIMELABELHEIGHT 30                                      //footer高度
#define WJCHAT_CELL_CONTENT_MAXWIDTH (WJCHAT_CELL_WIDTH - WJCHAT_CELL_LEFT_PADDING-WJCHAT_CELL_RIGHT_PADDING - WJCHAT_CELL_PADDING * 2)                                              //文本最大宽度

/**边框管理，定义各种边框的尺寸*/

@interface WJIMChatBorderManager : NSObject

@property (nonatomic,assign)CGFloat leftPadding;    //左边
@property (nonatomic,assign)CGFloat rightPadding;   //右边
@property (nonatomic,assign)CGFloat topPadding;     //顶部
@property (nonatomic,assign)CGFloat bottomPadding;  //底部

@property (nonatomic,assign)CGFloat labelWidth;     //label宽度
@property (nonatomic,assign)CGFloat labelHeight;    //label高度

@property (nonatomic,assign)CGFloat width;          //边框宽度
@property (nonatomic,assign)CGFloat height;         //边框高度

@property (nonatomic,strong)UIImage *borderImage;   //边框图片

//根据消息初始化
- (instancetype)initWithIMMessage:(id<IMessageModel>)msg;

@end
