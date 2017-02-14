//
//  WJIMNotifyCache.h
//  IMTestDemo
//
//  Created by tqh on 2017/2/10.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WJIMNotifyCacheType) {
    
    WJIMNotifyCacheType_Chat,           //单聊的缓存
    WJIMNotifyCacheType_Group           //群聊的缓存
};

typedef NS_ENUM(NSInteger, WJIMNotifyChatGroupType) {
     WJIMNotifyChatGroupType_ReceiveJoin = 0,            //收到入群邀请
    //join
    WJIMNotifyChatGroupType_AcceptJoin,             //同意入群回调
    WJIMNotifyChatGroupType_DeclineJoin,                //拒绝入群回调
    //Leave
    WJIMNotifyChatGroupType_LeaveReasonBeRemoved,       //被移除
    WJIMNotifyChatGroupType_LeaveReasonUserLeave,       //自己主动离开
    WJIMNotifyChatGroupType_LeaveReasonDestroyed,       //群组销毁
};

@class WJIMNotifyChatGroupModel;

/**
 聊天通知缓存
 */
@interface WJIMNotifyCache : NSObject

@property (nonatomic,strong) YYCache *groupCache;


+ (instancetype)shareManager;

- (void)saveWithType:(WJIMNotifyChatGroupType)type groupId:(NSString *)groupId inviteId:(NSString *)inviteId message:(NSString *)message;

- (WJIMNotifyChatGroupModel *)getChatGroupModelFromCache;

@end

//---------------------------------------------------------------------

/**聊天会话通知模型*/
@interface WJIMNotifyModel : NSObject 

@property (nonatomic,copy) NSString *title;             //标题
@property (nonatomic,copy) NSString *content;           //内容
@property (nonatomic,assign) NSTimeInterval dateTime;   //时间戳

@property (nonatomic,strong) WJIMNotifyChatGroupModel *group;
//@property (nonatomic,assign) NSInteger type;            //类型
//@property (nonatomic,copy) NSString *groupId;           //群ID
//@property (nonatomic,copy) NSString *InviteId;          //邀请人的Id
//@property (nonatomic,copy) NSString *message;           //对方输入的文本

//- (instancetype)initWithGroupId:(NSString *)groupId inviteId:(NSString *)inviteId message:(NSString *)message;

@end

//群聊处理通知的情况
@interface WJIMNotifyChatGroupModel : NSObject <NSCoding>

@property (nonatomic,assign) WJIMNotifyChatGroupType type;          //类型
@property (nonatomic,copy) NSString *groupId;                       //群ID
@property (nonatomic,copy) NSString *inviteId;                      //邀请人的Id
@property (nonatomic,copy) NSString *message;                       //对方输入的文本
@property (nonatomic,assign) NSTimeInterval dateTime;               //时间戳

+ (instancetype)modelWithType:(WJIMNotifyChatGroupType)type groupId:(NSString *)groupId inviteId:(NSString *)inviteId message:(NSString *)message;

@end

