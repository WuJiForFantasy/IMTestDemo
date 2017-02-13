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

@interface MainController ()<WJIMMainManagerChatDelegate>

@property (nonatomic,strong) ConversationController *convsersation;

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
    
    [[WJIMMainManager shareManager].delegates addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

#pragma mark - <WJIMMainManagerChatDelegate>

/**会话列表改变*/
- (void)conversationListDidUpdate:(NSArray *)aConversationList {
    
    NSLog(@"会话列表改变");
    [self.convsersation loadDataFromDB];
}

/**收到消息*/
- (void)messagesDidReceive:(NSArray *)aMessages {
    
    NSLog(@"在外面收到了消息");
    [self.convsersation refreshData];
}

@end
