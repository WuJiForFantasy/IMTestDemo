//
//  WJHuanXinChatPhotosBrowserController.m
//  moyouAPP
//
//  Created by 幻想无极（谭启宏） on 2016/12/4.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "WJHuanXinChatPhotosBrowserController.h"

@interface WJHuanXinChatPhotosBrowserController ()

@property (nonatomic,strong)UIActivityIndicatorView *activityView;
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)id<IMessageModel> model;
@property (nonatomic,strong)UIButton *cancelButton;

@end

@implementation WJHuanXinChatPhotosBrowserController

- (instancetype)initWithModel:(id<IMessageModel>)model {
    self = [super init];
    if (self) {
        self.model = model;
    }
    return self;
}

#pragma mark - 懒加载

- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_activityView startAnimating];
        _activityView.frame = self.view.bounds;
    }
    return _activityView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds) - 44, CGRectGetWidth([UIScreen mainScreen].bounds), 44)];
        [_cancelButton setImage:[UIImage imageNamed:@"home_ic_down"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.backgroundColor = [UIColor blackColor];
    }
    return _cancelButton;
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.activityView];
    [self.view addSubview:self.cancelButton];
    self.imageView.image = self.model.thumbnailImage;
    [self _imageMessageCellSelected:self.model];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//图片选中
- (void)_imageMessageCellSelected:(id<IMessageModel>)model {
    __weak typeof(self) weakSelf = self;
    EMImageMessageBody *imageBody = (EMImageMessageBody*)[model.message body];
    if ([imageBody type] == EMMessageBodyTypeImage) {
        //如果是成功状态
        if (imageBody.thumbnailDownloadStatus == EMDownloadStatusSuccessed) {
            if (imageBody.downloadStatus == EMDownloadStatusSuccessed)
            {
                //发送已经读消息

                if (self.didSendReadMsg) {
                    self.didSendReadMsg(model);
                }
                NSString *localPath = model.message == nil ? model.fileLocalPath : [imageBody localPath];
                if (localPath && localPath.length > 0) {
                    UIImage *image = [UIImage imageWithContentsOfFile:localPath];
                    
                    if (image)
                    {
                        NSLog(@"弹出图片");
                        
                        self.imageView.image = image;
                        //弹出图片视图

                    }
                    else
                    {
                        NSLog(@"Read %@ failed!", localPath);
                    }
                    [self.activityView stopAnimating];
                    return;
                }
            }

            //如果成功不走下载方法
            NSLog(@"正在下载...");
            [[EMClient sharedClient].chatManager downloadMessageAttachment:model.message progress:nil completion:^(EMMessage *message, EMError *error) {

                if (!error) {

                    if (self.didSendReadMsg) {
                        self.didSendReadMsg(model);
                    }
                    NSString *localPath = message == nil ? model.fileLocalPath : [(EMImageMessageBody*)message.body localPath];
                    if (localPath && localPath.length > 0) {
                        UIImage *image = [UIImage imageWithContentsOfFile:localPath];
                        //                                weakSelf.isScrollToBottom = NO;
                        if (image)
                        {
                            NSLog(@"弹出图片");
                            self.imageView.image = image;

                        }

                        else
                        {
                            NSLog(@"Read %@ failed!", localPath);
                        }
                        [self.activityView stopAnimating];
                        return ;
                    }
                }

            }];
        }else{
            //get the message thumbnail
            [[EMClient sharedClient].chatManager downloadMessageThumbnail:model.message progress:nil completion:^(EMMessage *message, EMError *error) {
                [self.activityView stopAnimating];
                if (!error) {
                    if (self.didreloadTableView) {
                        self.didreloadTableView(model);
                    }

                }else{

                    NSLog(@"%@缩略图下载失败",[weakSelf class]);
                }
            }];
        }
    }
}

#pragma mark - 事件监听

- (void)cancelButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
