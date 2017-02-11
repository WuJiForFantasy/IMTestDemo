//
//  WJIMConversationStore.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/10.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMConversationStore.h"
#import "WJIMConversationModel.h"

@implementation WJIMConversationStore

- (void)loadDataFromDB {
//    YYCache *cache = [[YYCache alloc]initWithName:@""];
    WJIMNotifyChatGroupModel *cache = [[WJIMNotifyCache shareManager] getChatGroupModelFromCache];
    EMConversation *con = [[EMClient sharedClient].chatManager getAllConversations];
    
    for (int i = 0; i < 10; i++) {
        WJIMConversationModel *model = [[WJIMConversationModel alloc]init];
        model.title = @"asdsa";
        model.content = @"这是内容xxx";
        [self.dataArray addObject:model];
    }
}

#pragma mark - 懒加载

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - others

-(void)refreshAndSortView
{
    if ([self.dataArray count] > 1) {
        if ([[self.dataArray objectAtIndex:0] isKindOfClass:[WJIMConversationModel class]]) {
            NSArray* sorted = [self.dataArray sortedArrayUsingComparator:
                               ^(WJIMConversationModel *obj1, WJIMConversationModel* obj2){
                                   EMMessage *message1 = [obj1.conversation latestMessage];
                                   EMMessage *message2 = [obj2.conversation latestMessage];
                                   if(message1.timestamp > message2.timestamp) {
                                       return(NSComparisonResult)NSOrderedAscending;
                                   }else {
                                       return(NSComparisonResult)NSOrderedDescending;
                                   }
                               }];
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:sorted];
        }
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(WJIMConversationStoreIsTableViewReloadData)]) {
        [self.delegate WJIMConversationStoreIsTableViewReloadData];
    }
}

/*!
 @method
 @brief 加载会话列表
 */
- (void)tableViewDidTriggerHeaderRefresh
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSArray* sorted = [conversations sortedArrayUsingComparator:
                       ^(EMConversation *obj1, EMConversation* obj2){
                           EMMessage *message1 = [obj1 latestMessage];
                           EMMessage *message2 = [obj2 latestMessage];
                           if(message1.timestamp > message2.timestamp) {
                               return(NSComparisonResult)NSOrderedAscending;
                           }else {
                               return(NSComparisonResult)NSOrderedDescending;
                           }
                       }];
    
    
    
    [self.dataArray removeAllObjects];
    for (EMConversation *converstion in sorted) {
        WJIMConversationModel *model = nil;
            model = [[WJIMConversationModel alloc] initWithConversation:converstion];
        
        if (model) {
            [self.dataArray addObject:model];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(WJIMConversationStoreIsTableViewReloadData)]) {
        [self.delegate WJIMConversationStoreIsTableViewReloadData];
    }
//    [self.tableView reloadData];
//    [self tableViewDidFinishTriggerHeader:YES reload:NO];
}

@end
