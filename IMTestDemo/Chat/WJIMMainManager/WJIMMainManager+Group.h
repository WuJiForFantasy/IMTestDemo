//
//  WJIMMainManager+Group.h
//  IMTestDemo
//
//  Created by tqh on 2017/2/10.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMMainManager.h"

/**群组模块*/

@interface WJIMMainManager (Group)

/**创建群*/
+ (void)groupCreat;

#pragma mark - join

/**邀请成员加入群*/
+ (void)groupInviteJoin;

/**申请加入群*/
+ (void)groupApplyJoin;

#pragma mark - 处理进群申请

/**同意*/
+ (void)groupAcceptInvitationFromGroup:(NSString *)group inviter:(NSString *)inviter;

/**拒绝*/
+ (void)groupRejectJoin;

//acceptInvitationFromGroup

/**同意入群申请*/
+ (void)groupAcceptInvitationFromGroup;
/**拒绝入群申请*/
+ (void)groupDeclineInvitationFromGroup;

#pragma mark - 退出

/**离开*/
+ (void)groupLeave;

#pragma mark - Owner权限

/**解散群*/
+ (void)groupDestroy;

/**修改群名称*/
+ (void)groupchangeGroupName;

/**修改群描述*/
+ (void)groupchangeDescription;

/**移除群成员*/
+ (void)groupRemoveOccupants;

/**加入群黑名单*/
+ (void)groupBlackOccupants;

/**移除群黑名单*/
+ (void)groupUnblackOccupants;

#pragma mark - 否Owner权限

/**屏蔽群消息*/
+ (void)groupBlackGroup;

/**取消屏蔽群消息*/
+ (void)groupUnblockGroup;

#pragma mark - 获取群组

/**1.从服务器获取与我相关的群组列表*/
+ (void)groupMyGroupFromServer;

/**2. 获取数据库中所有的群组*/
+ (void)grouploadAllMyGroupsFromDB;

/**3. 取内存中的值*/
+ (void)groupGetAllGroups;

@end
