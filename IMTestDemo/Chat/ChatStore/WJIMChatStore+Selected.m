//
//  WJIMChatStore+Selected.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/9.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMChatStore+Selected.h"
#import "EMCDDeviceManager.h"

@implementation WJIMChatStore (Selected)

- (void)_imageMessageCellSelected:(id<IMessageModel>)model
{
    __weak typeof(self) weakSelf = self;
    //图片文本
    EMImageMessageBody *imageBody = (EMImageMessageBody*)[model.message body];
    
    if ([imageBody type] == EMMessageBodyTypeImage) {
        if (imageBody.thumbnailDownloadStatus == EMDownloadStatusSuccessed) {
            if (imageBody.downloadStatus == EMDownloadStatusSuccessed)
            {
                //发送消息已读回执
                [weakSelf _sendHasReadResponseForMessages:@[model.message] isRead:YES];
                NSString *localPath = model.message == nil ? model.fileLocalPath : [imageBody localPath];
                if (localPath && localPath.length > 0) {
                    UIImage *image = [UIImage imageWithContentsOfFile:localPath];
                    
                    if (image)
                    {
#pragma mark - 显示图片 (image)
//                        [[EaseMessageReadManager defaultManager] showBrowserWithImages:@[image]];
                    }
                    else
                    {
                        NSLog(@"Read %@ failed!", localPath);
                    }
                    return;
                }
            }
#pragma mark - 图片正在下载中...
//            [weakSelf showHudInView:weakSelf.view hint:NSEaseLocalizedString(@"message.downloadingImage", @"downloading a image...")];
            [[EMClient sharedClient].chatManager downloadMessageAttachment:model.message progress:nil completion:^(EMMessage *message, EMError *error) {
//                [weakSelf hideHud];
                if (!error) {
                    //send the acknowledgement
                    [weakSelf _sendHasReadResponseForMessages:@[model.message] isRead:YES];
                    NSString *localPath = message == nil ? model.fileLocalPath : [(EMImageMessageBody*)message.body localPath];
                    if (localPath && localPath.length > 0) {
                        UIImage *image = [UIImage imageWithContentsOfFile:localPath];
                        //                                weakSelf.isScrollToBottom = NO;
                        if (image)
                        {
#pragma mark - 显示图片 (image)
//                            [[EaseMessageReadManager defaultManager] showBrowserWithImages:@[image]];
                        }
                        else
                        {
                            NSLog(@"Read %@ failed!", localPath);
                        }
                        return ;
                    }
                }
#pragma mark - 图片下载失败
//                [weakSelf showHint:NSEaseLocalizedString(@"message.imageFail", @"image for failure!")];
            }];
        }else{
            //get the message thumbnail
            [[EMClient sharedClient].chatManager downloadMessageThumbnail:model.message progress:nil completion:^(EMMessage *message, EMError *error) {
                if (!error) {
                    
                    [weakSelf _reloadTableViewDataWithMessage:model.message];
                }else{
#pragma mark - 缩略图下载失败
//                    [weakSelf showHint:NSEaseLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
                }
            }];
        }
    }
}

- (void)_videoMessageCellSelected:(id<IMessageModel>)model
{
    self.scrollToBottomWhenAppear = NO;
    
    EMVideoMessageBody *videoBody = (EMVideoMessageBody*)model.message.body;
    
    NSString *localPath = [model.fileLocalPath length] > 0 ? model.fileLocalPath : videoBody.localPath;
    if ([localPath length] == 0) {
#pragma mark - 视频下载失败
//        [self showHint:NSEaseLocalizedString(@"message.videoFail", @"video for failure!")];
        return;
    }
    
    dispatch_block_t block = ^{
        //发送已读回执
        [self _sendHasReadResponseForMessages:@[model.message]
                                       isRead:YES];
#pragma mark - 弹出视频播放器
//        NSURL *videoURL = [NSURL fileURLWithPath:localPath];
//        MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
//        [moviePlayerController.moviePlayer prepareToPlay];
//        moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
//        [self presentMoviePlayerViewControllerAnimated:moviePlayerController];
    };
    
    __weak typeof(self) weakSelf = self;
    void (^completion)(EMMessage *aMessage, EMError *error) = ^(EMMessage *aMessage, EMError *error) {
        if (!error)
        {
            //刷新cell
            [weakSelf _reloadTableViewDataWithMessage:aMessage];
        }
        else
        {
#pragma mark - 视频缩略图下载失败
//            [weakSelf showHint:NSEaseLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
        }
    };
    
    if (videoBody.thumbnailDownloadStatus == EMDownloadStatusFailed || ![[NSFileManager defaultManager] fileExistsAtPath:videoBody.thumbnailLocalPath]) {
//        [self showHint:@"begin downloading thumbnail image, click later"];
#pragma mark - 开始进行缩略图的下载
        [[EMClient sharedClient].chatManager downloadMessageThumbnail:model.message progress:nil completion:completion];
        return;
    }
    
    if (videoBody.downloadStatus == EMDownloadStatusSuccessed && [[NSFileManager defaultManager] fileExistsAtPath:localPath])
    {
        block();
        return;
    }
    
//    [self showHudInView:self.view hint:NSEaseLocalizedString(@"message.downloadingVideo", @"downloading video...")];
#pragma mark - 开始进行视频的下载
    [[EMClient sharedClient].chatManager downloadMessageAttachment:model.message progress:nil completion:^(EMMessage *message, EMError *error) {
//        [weakSelf hideHud];
        if (!error) {
            block();
        }else{
#pragma mark - 视频下载失败
//            [weakSelf showHint:NSEaseLocalizedString(@"message.videoFail", @"video for failure!")];
        }
    }];
}

- (void)_locationMessageCellSelected:(id<IMessageModel>)model {
    
}

- (void)_audioMessageCellSelected:(id<IMessageModel>)model {
    self.scrollToBottomWhenAppear = NO;
    EMVoiceMessageBody *body = (EMVoiceMessageBody*)model.message.body;
    EMDownloadStatus downloadStatus = [body downloadStatus];
    if (downloadStatus == EMDownloadStatusDownloading) {
//        [self showHint:NSEaseLocalizedString(@"message.downloadingAudio", @"downloading voice, click later")];
#pragma mark - 音频下载中...
        return;
    }
    else if (downloadStatus == EMDownloadStatusFailed)
    {
#pragma mark - 音频下载中...
//        [self showHint:NSEaseLocalizedString(@"message.downloadingAudio", @"downloading voice, click later")];
        [[EMClient sharedClient].chatManager downloadMessageAttachment:model.message progress:nil completion:nil];
        return;
    }
    
    // play the audio
    if (model.bodyType == EMMessageBodyTypeVoice) {
        //发送已读回执
        [self _sendHasReadResponseForMessages:@[model.message] isRead:YES];
        __weak typeof(self) weakSelf = self;
        BOOL isPrepare = [[WJIMMessageReadManager shareManager] prepareMessageAudioModel:model updateViewCompletion:^(WJIMMessageModel *prevAudioModel, WJIMMessageModel *currentAudioModel) {
            if (prevAudioModel || currentAudioModel) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(IMChatStoreIsTableViewReloadData)]) {
                    [weakSelf.delegate IMChatStoreIsTableViewReloadData];
                }
            }
        }];
        
        if (isPrepare) {
            self.isPlayingAudio = YES;
            __weak typeof(self) weakSelf = self;
            [[EMCDDeviceManager sharedInstance] enableProximitySensor];
            [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:model.fileLocalPath completion:^(NSError *error) {
                
                [[WJIMMessageReadManager shareManager] stopMessageAudioModel];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //刷新列表
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(IMChatStoreIsTableViewReloadData)]) {
                        [weakSelf.delegate IMChatStoreIsTableViewReloadData];
                    }
                    weakSelf.isPlayingAudio = NO;
                    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
                });
            }];
        }
        else{
            self.isPlayingAudio = NO;
        }
    }
}

@end
