//
//  WJIMConversationCell.h
//  IMTestDemo
//
//  Created by tqh on 2017/2/11.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJIMConversationModel.h"

@interface WJIMConversationCell : UITableViewCell

@property (nonatomic,strong) WJIMConversationModel *model;

+ (CGFloat)cellHeight;

@end
