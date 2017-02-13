//
//  WJIMConversationStore.h
//  IMTestDemo
//
//  Created by tqh on 2017/2/10.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WJIMConversationStoreDelegate;

@interface WJIMConversationStore : NSObject

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) id<WJIMConversationStoreDelegate>delegate;

- (void)refreshData;

- (void)loadDataFromDB;

@end


@protocol WJIMConversationStoreDelegate <NSObject>

//加载数据
- (void)WJIMConversationStoreIsTableViewReloadData;

//刷新数据
- (void)WJIMConversationStoreIsTableViewRefreshData;

@end
