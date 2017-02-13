//
//  MainController.h
//  IMTestDemo
//
//  Created by tqh on 2017/2/6.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ConversationController.h"
/**
 主控制器
 */
@interface MainController : UITabBarController

@property (nonatomic,strong) ConversationController *convsersation;

@end
