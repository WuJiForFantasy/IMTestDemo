//
//  MainController.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/6.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "MainController.h"
#import "ConversationController.h"
#import "FriendListController.h"

@interface MainController ()



@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    FriendListController *friendList = [FriendListController new];
    friendList.title = @"好友列表";
    
    self.convsersation = [ConversationController new];
    self.convsersation.title = @"会话";
    
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:self.convsersation];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:friendList];
    
    self.viewControllers = @[nav1,nav2];
    
  
}


@end
