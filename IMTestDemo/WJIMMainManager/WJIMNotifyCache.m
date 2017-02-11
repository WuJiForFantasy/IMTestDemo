//
//  WJIMNotifyCache.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/10.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMNotifyCache.h"

@implementation WJIMNotifyCache

+ (instancetype)shareManager {
    
    static dispatch_once_t onceToken;
    static WJIMNotifyCache *cache = nil;
    dispatch_once(&onceToken, ^{
        cache = [[WJIMNotifyCache alloc]init];
    });
    return cache;
}

- (YYCache *)groupCache {
    if (!_groupCache) {
        _groupCache = [[YYCache alloc]initWithName:@"imgroupCache"];
    }
    return _groupCache;
}

- (void)saveWithType:(WJIMNotifyChatGroupType)type groupId:(NSString *)groupId inviteId:(NSString *)inviteId message:(NSString *)message {
    
    WJIMNotifyChatGroupModel *model = [WJIMNotifyChatGroupModel modelWithType:type groupId:groupId inviteId:inviteId message:message];
    [self saveGroup:model];
}

- (void)saveGroup:(WJIMNotifyChatGroupModel *)model {
    
    [self.groupCache setObject:model forKey:@"group"];
    
}

- (WJIMNotifyChatGroupModel *)getChatGroupModelFromCache {
    
   return (WJIMNotifyChatGroupModel *)[self.groupCache objectForKey:@"group"];
}

@end

@implementation WJIMNotifyModel

@end

@implementation WJIMNotifyChatGroupModel

+ (instancetype)modelWithType:(WJIMNotifyChatGroupType)type groupId:(NSString *)groupId inviteId:(NSString *)inviteId message:(NSString *)message {
    
    WJIMNotifyChatGroupModel *model = [[self alloc]init];
    model.type = type;
    model.groupId = groupId;
    model.inviteId = inviteId;
    model.message = message;
    //时间戳
    model.dateTime = [NSDate date].timeIntervalSince1970;
    return model;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        
        self.type = [coder decodeIntegerForKey:@"type"];
        self.groupId = [coder decodeObjectForKey:@"groupId"];
        self.inviteId = [coder decodeObjectForKey:@"inviteId"];
        self.message = [coder decodeObjectForKey:@"message"];
        self.dateTime = [coder decodeDoubleForKey:@"dateTime"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeInteger:self.type forKey:@"type"];
    [aCoder encodeObject:self.groupId forKey:@"groupId"];
    [aCoder encodeObject:self.inviteId forKey:@"inviteId"];
    [aCoder encodeObject:self.message forKey:@"message"];
    [aCoder encodeDouble:self.dateTime forKey:@"dateTime"];
}

@end
