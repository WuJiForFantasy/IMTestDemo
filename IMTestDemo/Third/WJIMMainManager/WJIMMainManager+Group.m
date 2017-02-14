//
//  WJIMMainManager+Group.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/10.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMMainManager+Group.h"



@implementation WJIMMainManager (Group)

+ (void)groupCreat {
    EMError *error = nil;
    //群组邀请选项
    EMGroupOptions *setting = [[EMGroupOptions alloc] init];
    setting.maxUsersCount = 500;
    setting.style = EMGroupStylePublicOpenJoin;// 创建不同类型的群组，这里需要才传入不同的类型
    
    NSString *username = [[EMClient sharedClient] currentUsername];
    //邀请信息
    NSString *joinMessage = [NSString stringWithFormat:@"%@xxxxx邀请您加入群组",username];
    //创建群主的时候
    NSArray *userIdArray = @[@"123456"];
    
    EMGroup *group = [[EMClient sharedClient].groupManager createGroupWithSubject:@"群组名称" description:@"群组描述" invitees:userIdArray message:joinMessage setting:setting error:&error];
    if(!error){
        NSLog(@"创建成功 -- 群组id: %@",group.groupId);
    }else {
        NSLog(@"创建失败 -- %@",error);
    }
}

+ (void)groupInviteJoin {
    
    EMError *error = nil;
    [[EMClient sharedClient].groupManager addOccupants:@[@"1234567"] toGroup:@"1486694145795" welcomeMessage:@"message" error:&error];
    if(!error){
        NSLog(@"创建成功 ");
    }else {
        NSLog(@"创建失败 -- %@",error);
    }
}

+ (void)groupApplyJoin {

    EMError *error = nil;
    [[EMClient sharedClient].groupManager applyJoinPublicGroup:@"1486694145795" message:@"我要加入群哦" error:&error];
}

+ (void)groupAcceptJoin {
    
    EMError *error = nil;
    [[EMClient sharedClient].groupManager acceptJoinApplication:@"1486694145795" applicant:@""];
    
}

+ (void)groupRejectJoin {
    
    EMError *error = nil;
    [[EMClient sharedClient].groupManager declineJoinApplication:@"1486694145795" applicant:@"" reason:@""];
}

/**同意入群申请*/
+ (void)groupAcceptInvitationFromGroup:(NSString *)group inviter:(NSString *)inviter {
    
    EMError *error = nil;
     [[EMClient sharedClient].groupManager acceptInvitationFromGroup:group inviter:inviter error:&error];
}
/**拒绝入群申请*/
+ (void)groupDeclineInvitationFromGroup {
    
}


- (void)groupLeave {
    
    EMError *error = nil;
    [[EMClient sharedClient].groupManager leaveGroup:@"1486694145795" error:&error];
}

#pragma mark - Owner权限

/**解散群*/
+ (void)groupDestroy {
    EMError *error = nil;
    [[EMClient sharedClient].groupManager destroyGroup:@"1486694145795" error:&error];
    if (!error) {
        NSLog(@"解散成功");
    }
}

/**修改群名称*/
+ (void)groupchangeGroupName {
    EMError *error = nil;
    // 修改群名称
    [[EMClient sharedClient].groupManager changeGroupSubject:@"要修改的名称" forGroup:@"1486694145795" error:&error];
    if (!error) {
        NSLog(@"修改成功");
    }
}

/**修改群描述*/
+ (void)groupchangeDescription {
    
    EMError *error = nil;
    // 修改群描述
    EMGroup* group = [[EMClient sharedClient].groupManager changeDescription:@"修改的群描述" forGroup:@"1486694145795" error:&error];
    if (!error) {
        NSLog(@"修改成功");
    }
}

/**移除群成员*/
+ (void)groupRemoveOccupants {
    
    EMError *error = nil;
    [[EMClient sharedClient].groupManager removeOccupants:@[@"user1"] fromGroup:@"1486694145795" error:&error];
}

/**加入群黑名单*/
+ (void)groupBlackOccupants {
    
    EMError *error = nil;
    EMGroup *group = [[EMClient sharedClient].groupManager blockOccupants:@[@"user1"] fromGroup:@"1486694145795" error:&error];
}

/**移除群黑名单*/
+ (void)groupUnblackOccupants {
    
    EMError *error = nil;
    EMGroup *group = [[EMClient sharedClient].groupManager unblockOccupants:@[@"user1"] forGroup:@"1486694145795" error:&error];
}

#pragma mark - 否Owner权限

/**屏蔽群消息*/
+ (void)groupBlackGroup {
    
    [[EMClient sharedClient].groupManager blockGroup:@"" error:nil];
}

/**取消屏蔽群消息*/
+ (void)groupUnblockGroup {
    
    [[EMClient sharedClient].groupManager unblockGroup:@"" error:nil];
}

#pragma mark - 获取群组

/**1.从服务器获取与我相关的群组列表*/
+ (void)groupMyGroupFromServer {
    
    EMError *error = nil;
    NSArray *myGroups = [[EMClient sharedClient].groupManager getMyGroupsFromServerWithError:&error];
    if (!error) {
        NSLog(@"获取成功 -- %@",myGroups);
    }
}

/**2. 获取数据库中所有的群组*/
+ (void)grouploadAllMyGroupsFromDB {

    NSArray *groupList = [[EMClient sharedClient].groupManager loadAllMyGroupsFromDB];
}

/**3. 取内存中的值*/
+ (void)groupGetAllGroups {
    
    NSArray *groupList = [[EMClient sharedClient].groupManager getAllGroups];
}
@end
