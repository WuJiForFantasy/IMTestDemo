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

- (void)save {
    
    NSDictionary *dic = @{@"type":@"1",
                         @"aGroupId":@"123",
                         @"aInviter":@"123",
                         @"aMessage":@"123"};
    [self.groupCache setObject:dic forKey:@"qunsetting"];
    
}

@end
