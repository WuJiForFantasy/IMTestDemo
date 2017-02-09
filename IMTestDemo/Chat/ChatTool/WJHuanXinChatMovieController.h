//
//  WJHuanXinChatMovieController.h
//  moyouAPP
//
//  Created by 幻想无极（谭启宏） on 2016/12/4.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

/**视频播放控制器*/
@interface WJHuanXinChatMovieController : MPMoviePlayerViewController

- (instancetype)initWithModel:(id<IMessageModel>)model;

@property (nonatomic,copy) void (^didSendReadMsg)(id<IMessageModel> model);
@property (nonatomic,copy) void (^didreloadTableView)(EMMessage* message);

@end
