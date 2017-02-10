//
//  WJIMNotifyCache.h
//  IMTestDemo
//
//  Created by tqh on 2017/2/10.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJIMNotifyCache : NSObject

@property (nonatomic,strong) YYCache *groupCache;


+ (instancetype)shareManager;

@end

//@interface WJIMNotifyCache : NSObject
//
//@end
