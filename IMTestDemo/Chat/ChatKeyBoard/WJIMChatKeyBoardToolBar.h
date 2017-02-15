//
//  WJIMChatKeyBoardToolBar.h
//  IMTestDemo
//
//  Created by tqh on 2017/2/14.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYTextView.h"
@protocol WJIMChatKeyBoardToolBarDelegate;

/**
 聊天键盘工具条
 */
@interface WJIMChatKeyBoardToolBar : UIView


@property (nonatomic,assign) CGFloat toolBarChangeHeight;    //会改变的工具条高度

/**完成后回调*/
@property (nonatomic,copy) void (^didFinishBlock) (NSString *str,NSAttributedString *attStr);
@property (nonatomic,weak) id <WJIMChatKeyBoardToolBarDelegate> delegate;

- (void)resetSelected;  //重置选中状态

@end


@protocol WJIMChatKeyBoardToolBarDelegate <NSObject>

- (void)toolBarChangeFrame:(WJIMChatKeyBoardToolBar *)toolBar changeHeight:(CGFloat)changeHeight;

//0:音频，1:键盘，2:更多
- (void)toolBarSelectedAtIndex:(NSInteger)index selected:(BOOL)selected textView:(YYTextView *)textView;

@end

