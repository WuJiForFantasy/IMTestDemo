//
//  WJIMChatStore.h
//  IMTestDemo
//
//  Created by tqh on 2017/2/6.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EMSDK.h>

@protocol WJIMChatStoreDelegate;

@interface WJIMChatStore : NSObject

@property (nonatomic) BOOL isViewDidAppear;//是否在当前视图
@property (nonatomic,strong) EMConversation *conversation; //会话
@property (strong, nonatomic) NSMutableArray *messsagesSource;  //数据<EMMessage>消息
@property (strong, nonatomic) NSMutableArray *dataArray;        //tableView数据，用于UI显示
@property (nonatomic, assign) id<WJIMChatStoreDelegate> delegate;

//初始化数据管理
- (instancetype)initWithConversationChatter:(NSString *)conversationChatter
                           conversationType:(EMConversationType)conversationType;

#pragma mark - pubulic

//开启聊天代理
- (void)setupChat;
//关闭聊天代理
- (void)destroyChat;
- (NSArray *)formatMessages:(NSArray *)messages;

@end

@protocol WJIMChatStoreDelegate <NSObject>

//刷新一组cell
- (void)IMChatStoreIsTableViewReloadRowsAtIndexPaths:(NSArray *)indexPaths;
//刷新整个列表
- (void)IMChatStoreIsTableViewReloadData;
//刷新列表后滑动到最后位置
- (void)IMChatStoreIsTableViewScrollToRowAtIndexPath:(NSIndexPath *)indexPath;

@end
