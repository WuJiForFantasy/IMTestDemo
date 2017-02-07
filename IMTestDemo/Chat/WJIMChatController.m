//
//  WJIMChatController.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/6.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMChatController.h"
#import "UIAlertController+Blocks.h"
#import "WJIMMainManager+Send.h"
#import "WJIMMainManager.h"
#import "WJIMChatStore.h"

@interface WJIMChatController () <WJIMChatStoreDelegate>

@property (nonatomic,copy) NSString *userId;
@property (nonatomic,strong) WJIMChatStore *store;
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation WJIMChatController

- (instancetype)initWithUserId:(NSString *)userId {
    
    self = [super init];
    if (self) {
        self.userId = userId;
//        self.convsersation = [[EMClient sharedClient].chatManager getConversation:userId type:EMConversationTypeChat createIfNotExist:YES];
//        [self.convsersation markAllMessagesAsRead:nil];
    }
    return self;
}

- (instancetype)initWithConversationChatter:(NSString *)conversationChatter
                           conversationType:(EMConversationType)conversationType {
    self = [super init];
    if (self) {
        self.store = [[WJIMChatStore alloc]initWithConversationChatter:conversationChatter conversationType:conversationType];
        self.store.delegate = self;
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.store setupChat];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.store destroyChat];
}

#pragma mark - <WJIMChatStoreDelegate>

//刷新一组cell
- (void)IMChatStoreIsTableViewReloadRowsAtIndexPaths:(NSArray *)indexPaths {
    NSLog(@"刷新了一组数据");
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}
//刷新整个列表
- (void)IMChatStoreIsTableViewReloadData {
    NSLog(@"刷新列表");
    [self.tableView reloadData];
}
//刷新列表后滑动到最后位置
- (void)IMChatStoreIsTableViewScrollToRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"滑动了位置");
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemPressed)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 事件监听

- (void)rightItemPressed {
    
    [UIAlertController showActionSheetInViewController:self withTitle:@"发送消息" message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"文字",@"图片",@"视频",@"语音",@"红包,地理位置"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
        
    } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        NSLog(@"%ld",buttonIndex);
        switch (buttonIndex) {
            case 2:
                
                [self sendText];
                break;
            case 3:
                
                [self sendPic];
                break;
            case 4:
                
                [self sendVideo];
                break;
            case 5:
                
                [self sendMusic];
                break;
            case 6:
                
                [self sendHongbao];
                break;
            case 7:
                
                [self sendLocation];
                break;
            default:
                break;
        }
    }];
}

- (void)sendText {
    EMMessage *message = [WJIMMainManager sendTextMessage:@"测试测试测试" to:self.userId messageType:EMChatTypeChat messageExt:nil];

    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
        
        if (!aError) {
            NSLog(@"%@发送消息成功",[self class]);
        
        }
        else {
            NSLog(@"发送消息出错：~ ~ %@",aError.errorDescription);
      
        }
    }];
    
}

- (void)sendPic {
    
    [WJIMMainManager sendImageMessageWithImage:[UIImage imageNamed:@""] to:@"" messageType:EMChatTypeChat messageExt:nil];
}

- (void)sendVideo {
    
}

- (void)sendMusic {
    [WJIMMainManager sendVoiceMessageWithLocalPath:@"" duration:10 to:@"" messageType:EMChatTypeChat messageExt:nil];
}

- (void)sendHongbao {

}

- (void)sendLocation {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end