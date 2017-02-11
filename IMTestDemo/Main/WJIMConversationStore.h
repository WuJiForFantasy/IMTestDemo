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

//- (void)loadDataFromDB;
- (void)tableViewDidTriggerHeaderRefresh;
@end


@protocol WJIMConversationStoreDelegate <NSObject>

- (void)WJIMConversationStoreIsTableViewReloadData;

@end
