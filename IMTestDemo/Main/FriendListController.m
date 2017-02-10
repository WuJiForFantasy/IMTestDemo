//
//  FriendListController.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/6.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "FriendListController.h"
#import "WJIMChatController.h"
#import "UIAlertController+Blocks.h"

@interface FriendListController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;//列表
@property (nonatomic,strong) NSArray *dataArray;    //数据源

@end

@implementation FriendListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"创建群组" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemPressed)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"群管理" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemPressed)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)leftItemPressed {
    
//    [WJIMMainManager groupCreat];
}

- (void)rightItemPressed {
    
    NSString *group = @"1486694145795";
    NSString *inviter = @"123";
    [UIAlertController showActionSheetInViewController:self withTitle:@"群管理" message:@"群" cancelButtonTitle:@"取消" destructiveButtonTitle:@"创建群组" otherButtonTitles:@[@"邀请123加入该群",@"申请加入该群",@"同意xxx加入群",@"拒绝xxx加入群",@"离开群"] popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
        
    } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        switch (buttonIndex) {
            case 1:
                [WJIMMainManager groupCreat];
                break;
            case 2:
                [WJIMMainManager groupInviteJoin];
                break;
            case 3:
                [WJIMMainManager groupApplyJoin];
                break;
            case 4:
                [WJIMMainManager groupAcceptInvitationFromGroup:group inviter:inviter];
                break;
            case 5:
                [WJIMMainManager groupRejectJoin];
                break;
            default:
                break;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  <UITableViewDataSource,UITableViewDelegate>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EMConversationType type = EMConversationTypeChat;
    if (indexPath.row > 1) {
        type = EMConversationTypeGroupChat;
    }
    WJIMChatController *chat = [[WJIMChatController alloc]initWithConversationChatter:self.dataArray[indexPath.row] conversationType:type];
    chat.title = self.dataArray[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chat animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - 懒加载

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    }
    return _tableView;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"123",@"123456",@"1486694145795"];
    }
    return _dataArray;
}

@end
