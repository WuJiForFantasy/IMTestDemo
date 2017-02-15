//
//  WJIMChatKeyBoard.h
//  IMTestDemo
//
//  Created by tqh on 2017/2/14.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJIMChatKeyBoardToolBar.h"
/**
 聊天键盘
 */
@interface WJIMChatKeyBoard : UIView

@property (nonatomic,strong) WJIMChatKeyBoardToolBar *toolBar;      //工具条
@property (nonatomic,strong) UIView *paneView;                      //键盘

- (void)resetKeyBoard; //重置键盘

@end
