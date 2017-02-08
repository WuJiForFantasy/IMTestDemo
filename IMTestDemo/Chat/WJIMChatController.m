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
#import "WJIMChatStore+send.h"
//#import "WJIMChatBaseCell.h"
#import "WJIMChatTextMsgCell.h"
#import "WJIMChatCellUtil.h"

@interface WJIMChatController () <WJIMChatStoreDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,copy) NSString *userId;
@property (nonatomic,strong) WJIMChatStore *store;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation WJIMChatController



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

#pragma mark - <UITableViewDelegate,UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    WJIMChatTextMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
//    id message= self.store.dataArray[indexPath.row];
//    if (![message isKindOfClass:[NSString class]]) {
//         [cell setIMMessage:message];
//    }else {
//        cell.textLabel.text = message;
//    }
   UITableViewCell *cell = [WJIMChatCellUtil tableView:tableView cellForMsg:self.store.dataArray[indexPath.row]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.store.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [WJIMChatCellUtil cellHeightForMsg:self.store.dataArray[indexPath.row]];
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
    
    [self.view addSubview:self.tableView];
    [self.store reloadMessageData];
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
    
    [self.store sendTextMessage:@"哇哈哈"];
    
}

- (void)sendPic {
    
    
    [self.store sendImageMessageWithData:UIImagePNGRepresentation([UIImage imageNamed:@"avatar"])];
}

- (void)sendVideo {
    
    NSString * docPath = [[NSBundle mainBundle] pathForResource:@"shipin" ofType:@"mp4"];
    NSString * appDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    //appLib  Library/Caches目录
    NSString *appLib = [appDir stringByAppendingString:@"/Caches"];
    
    BOOL filesPresent = [self copyMissingFile:docPath toPath:appLib];
    if (filesPresent) {
        NSLog(@"OK");
        
    }
    else
    {
        NSLog(@"NO");
    }
    NSString *str = [NSString stringWithFormat:@"%@/%@",appLib,@"shipin.mp4"];
    [self.store sendVideoMessageWithURL:[NSURL URLWithString:str]];
    
}

- (BOOL)copyMissingFile:(NSString *)sourcePath toPath:(NSString *)toPath
{
    BOOL retVal = YES; // If the file already exists, we'll return success…
    NSString * finalLocation = [toPath stringByAppendingPathComponent:[sourcePath lastPathComponent]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:finalLocation])
    {
        retVal = [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:finalLocation error:NULL];
    }
    return retVal;
}

- (void)sendMusic {
    [WJIMMainManager sendVoiceMessageWithLocalPath:@"" duration:10 to:@"" messageType:EMChatTypeChat messageExt:nil];
}

- (void)sendHongbao {

}

- (void)sendLocation {
    
//    self.store sendVideoMessageWithURL:<#(NSURL *)#>
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor grayColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
