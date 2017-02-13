//
//  ConversationController.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/6.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "ConversationController.h"
#import "WJIMConversationStore.h"
#import "WJIMConversationCell.h"
#import "WJIMChatController.h"

@interface ConversationController () <UITableViewDelegate,UITableViewDataSource,WJIMConversationStoreDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) WJIMConversationStore *store;

@end

@implementation ConversationController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.store loadDataFromDB];
    });
}

- (void)refreshData {
    [self.store refreshData];
}

- (void)loadDataFromDB {
    [self.store loadDataFromDB];
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WJIMConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.model = self.store.dataArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.store.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [WJIMConversationCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WJIMConversationModel *model = self.store.dataArray[indexPath.row];
    WJIMChatController *chat = [[WJIMChatController alloc]initWithConversationChatter:model.conversation.conversationId conversationType:model.conversation.type];
    chat.title = model.title;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chat animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - <WJIMConversationStoreDelegate>

- (void)WJIMConversationStoreIsTableViewReloadData {
    [self.tableView reloadData];
}

#pragma mark - 懒加载

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[WJIMConversationCell class] forCellReuseIdentifier:@"cellID"];
    }
    return _tableView;
}

- (WJIMConversationStore *)store {
    if (!_store) {
        _store = [WJIMConversationStore new];
        _store.delegate = self;
    }
    return _store;
}

@end


