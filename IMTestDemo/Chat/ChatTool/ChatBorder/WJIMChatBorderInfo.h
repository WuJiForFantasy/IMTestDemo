//
//  WJIMChatBorderInfo.h
//  IMTestDemo
//
//  Created by tqh on 2017/2/8.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import <Foundation/Foundation.h>

/**边框+详细参数*/

@interface WJIMChatBorderInfo : NSObject

@property (nonatomic,assign)CGFloat leftPadding;    //左边
@property (nonatomic,assign)CGFloat rightPadding;   //右边
@property (nonatomic,assign)CGFloat topPadding;     //顶部
@property (nonatomic,assign)CGFloat bottomPadding;  //底部

@property (nonatomic,strong)UIImage *borderImage;   //边框图片

+ (WJIMChatBorderInfo *)defaultBorderInfoFromOther;
+ (WJIMChatBorderInfo *)defaultBorderInfoFromMe;

@end
