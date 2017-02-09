//
//  WJHuanXinChatPhotosBrowserController.h
//  moyouAPP
//
//  Created by 幻想无极（谭启宏） on 2016/12/4.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJHuanXinChatPhotosBrowserController : UIViewController

- (instancetype)initWithModel:(id<IMessageModel>)model;

@property (nonatomic,copy) void (^didSendReadMsg)(id<IMessageModel> model);
@property (nonatomic,copy) void (^didreloadTableView)(id<IMessageModel> model);

@end
