//
//  WJKeyBoardManager.h
//  moyouAPP
//
//  Created by 幻想无极（谭启宏） on 16/10/12.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^keyBoarddWillShowBlock)(CGFloat keyboardHeight);
typedef void (^keyBoarddWillHideBlock)(void);

/**键盘监听管理*/

@interface WJKeyBoardManager : NSObject

@property (nonatomic,assign)CGFloat keyboardHeight; //键盘高度

+ (instancetype)sharedKeyBoardManager;              //单例

- (void)addNotificationAtkeyBoarddwithView:(UIView *)view WillShow:(keyBoarddWillShowBlock)willShow willHide:(keyBoarddWillHideBlock)willHide;

- (void)removeNotification;

@end
