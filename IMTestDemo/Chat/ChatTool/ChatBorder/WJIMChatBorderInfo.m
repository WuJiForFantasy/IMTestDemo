//
//  WJIMChatBorderInfo.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/8.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMChatBorderInfo.h"

@implementation WJIMChatBorderInfo

//左边的边框
+ (WJIMChatBorderInfo *)defaultBorderInfoFromOther {
    
    UIImage *normal;
    normal = [UIImage imageNamed:@"new_ic_left_bubble"];
    //(22, 20, 40, 10)
    normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 30, 15)];
    WJIMChatBorderInfo *info = [[WJIMChatBorderInfo alloc]init];
    info.leftPadding = 22;
    info.rightPadding = 10;
    info.topPadding = 5;
    info.bottomPadding = 10;
    info.borderImage = normal;
    return info;
}

//右边的边框
+ (WJIMChatBorderInfo *)defaultBorderInfoFromMe {
    UIImage *normal;
    normal = [UIImage imageNamed:@"new_ic_right_bubble"];
    normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(30, 10, 30, 20) resizingMode:UIImageResizingModeStretch];
    
    WJIMChatBorderInfo *info = [[WJIMChatBorderInfo alloc]init];
    info.leftPadding = 10;
    info.rightPadding = 20;
    info.topPadding = 5;
    info.bottomPadding = 10;
    info.borderImage = normal;
    return info;
}

@end
