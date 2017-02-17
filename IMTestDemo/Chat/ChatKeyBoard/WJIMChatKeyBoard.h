//
//  WJIMChatKeyBoard.h
//  IMTestDemo
//
//  Created by tqh on 2017/2/14.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJIMChatKeyBoardToolBar.h"
@protocol WJIMChatKeyBoardDelegate;

/**
 聊天键盘
 */
@interface WJIMChatKeyBoard : UIView

@property (nonatomic,strong) WJIMChatKeyBoardToolBar *toolBar;      //工具条
@property (nonatomic,strong) UIView *paneView;                      //键盘

@property (nonatomic, weak) id<WJIMChatKeyBoardDelegate> delegate;

- (void)resetKeyBoard; //重置键盘

@end

@protocol WJIMChatKeyBoardDelegate <NSObject>


- (void)chatKeyBoardTextViewDidBeginEditing:(UITextView *)textView;

/**发送文字*/
- (void)chatKeyBoardSendText:(NSString *)text;

/**改变*/
- (void)chatKeyBoardTextViewDidChange:(UITextView *)textView;

/**改变时候高度的改变*/
- (void)chatKeyBoardDidChangeFrameToTopY:(CGFloat)TopY;

/**键盘上的输入监听*/
- (void)chatKeyBoardFacePicked:(WJIMChatKeyBoard *)chatKeyBoard faceSize:(NSInteger)faceSize faceName:(NSString *)faceName delete:(BOOL)isDelete;

/**点击了某一个item*/
- (void)chatKeyBoardDidItemIndex:(NSInteger)index;

@end
