//
//  WJHuanXinChatMovieController.m
//  moyouAPP
//
//  Created by 幻想无极（谭启宏） on 2016/12/4.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "WJHuanXinChatMovieController.h"

@interface WJHuanXinChatMovieController ()

@property (nonatomic,strong)id<IMessageModel> model;
@property (nonatomic,strong)UIActivityIndicatorView *activityView;

@end

@implementation WJHuanXinChatMovieController

- (instancetype)initWithModel:(id<IMessageModel>)model {
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_activityView startAnimating];
        _activityView.frame = CGRectMake(0, 0, 50, 50);
        _activityView.center = self.view.center;
    }
    return _activityView;
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.activityView];
    [self _videoMessageCellSelected:self.model];
}

- (void)_videoMessageCellSelected:(id<IMessageModel>)model {
    EMVideoMessageBody *videoBody = (EMVideoMessageBody*)model.message.body;
    
    NSString *localPath = [model.fileLocalPath length] > 0 ? model.fileLocalPath : videoBody.localPath;
    if ([localPath length] == 0) {
        return;
    }
    dispatch_block_t block = ^{

        if (self.didSendReadMsg) {
            self.didSendReadMsg(model);
        }
       dispatch_async(dispatch_get_main_queue(), ^{
           
           NSURL *videoURL = [NSURL fileURLWithPath:localPath];
           self.moviePlayer.contentURL = videoURL;
           [self.activityView stopAnimating];
           
       });

    };
    
    __weak typeof(self) weakSelf = self;
    void (^completion)(EMMessage *aMessage, EMError *error) = ^(EMMessage *aMessage, EMError *error) {
        if (!error)
        {
            if (self.didreloadTableView) {
                self.didreloadTableView(aMessage);
            }
        }
        else
        {
        }
        [self.activityView stopAnimating];
    };
    
    //如果加载失败或者没有缩略图就下载缩略图
    if (videoBody.thumbnailDownloadStatus == EMDownloadStatusFailed || ![[NSFileManager defaultManager] fileExistsAtPath:videoBody.thumbnailLocalPath]) {

        [[EMClient sharedClient].chatManager downloadMessageThumbnail:model.message progress:nil completion:completion];
        return;
    }
    
    //如果是下载成功状态就播放视频，否则进入下载视频
    if (videoBody.downloadStatus == EMDownloadStatusSuccessed && [[NSFileManager defaultManager] fileExistsAtPath:localPath])
    {
        block();
        return;
    }

    [[EMClient sharedClient].chatManager downloadMessageAttachment:model.message progress:nil completion:^(EMMessage *message, EMError *error) {
//        [weakSelf hideHud];
        if (!error) {
            block();
        }else{

        }
         [self.activityView stopAnimating];
    }];
}

@end
