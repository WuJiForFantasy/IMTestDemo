//
//  ConversationController.h
//  IMTestDemo
//
//  Created by tqh on 2017/2/6.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 会话列表
 */
@interface ConversationController : UIViewController

- (void)refreshData;
- (void)loadDataFromDB;

@end
