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

/**
 聊天的数据处理
 */
@interface WJIMChatStore : NSObject

@property (nonatomic) NSTimeInterval messageTimeIntervalTag;    //时间间隔标记
@property (nonatomic) BOOL isViewDidAppear;                     //是否在当前视图
@property (nonatomic) BOOL scrollToBottomWhenAppear;            //当前页面显示的时候是否滚动到最后一条
@property (nonatomic) BOOL isPlayingAudio;                      //是否正在播放音频
@property (nonatomic,strong) EMConversation *conversation;      //会话
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
//加载历史消息
- (void)reloadMessageData;

#pragma mark - others

- (NSArray *)formatMessages:(NSArray *)messages;
- (EMChatType)_messageTypeFromConversationType;
-(void)addMessageToDataSource:(EMMessage *)message
                     progress:(id)progress;

#pragma mark - selected
//发送消息已经读回执
- (void)_sendHasReadResponseForMessages:(NSArray*)messages
                                 isRead:(BOOL)isRead;
//刷新单个cell
- (void)_reloadTableViewDataWithMessage:(EMMessage *)message;
@end

@protocol WJIMChatStoreDelegate <NSObject>

//刷新一组cell
- (void)IMChatStoreIsTableViewReloadRowsAtIndexPaths:(NSArray *)indexPaths;
//刷新整个列表
- (void)IMChatStoreIsTableViewReloadData;
//刷新列表后滑动到最后位置
- (void)IMChatStoreIsTableViewScrollToRowAtIndexPath:(NSIndexPath *)indexPath;

@end
