//
//  FriendListController.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/6.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "FriendListController.h"
#import "WJIMChatController.h"

@interface FriendListController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;//列表
@property (nonatomic,strong) NSArray *dataArray;    //数据源
@end

@implementation FriendListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
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
    
    WJIMChatController *chat = [[WJIMChatController alloc]initWithConversationChatter:self.dataArray[indexPath.row] conversationType:EMConversationTypeChat];
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
        _dataArray = @[@"123",@"123456"];
    }
    return _dataArray;
}

@end
