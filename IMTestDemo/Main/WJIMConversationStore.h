//
//  WJIMConversationStore.h
//  IMTestDemo
//
//  Created by tqh on 2017/2/10.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJIMConversationStore : NSObject

@property (nonatomic,strong) NSMutableArray *dataArray;

- (void)loadDataFromDB;

@end
