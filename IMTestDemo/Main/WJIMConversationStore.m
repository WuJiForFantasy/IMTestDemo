//
//  WJIMConversationStore.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/10.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMConversationStore.h"

@implementation WJIMConversationStore

- (void)loadDataFromDB {
    YYCache *cache = [[YYCache alloc]initWithName:@""];
    
}

#pragma mark - 懒加载

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
