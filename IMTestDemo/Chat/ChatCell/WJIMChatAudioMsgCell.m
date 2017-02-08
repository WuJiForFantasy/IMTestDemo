//
//  WJIMChatAudioMsgCell.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/8.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMChatAudioMsgCell.h"

@interface WJIMChatAudioMsgCell ()

@property (nonatomic,strong) UIButton *playButton;              //播放按钮
@property (nonatomic,strong) UILabel *audioLabel;               //音频文本
@property (nonatomic,strong) UIImageView *audioNoReadImage;     //音频未读的小圆点
@property (nonatomic,strong) UIImageView *playStateView;        //播放状态视图

@end

@implementation WJIMChatAudioMsgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.bodyBgView addSubview:self.playButton];
        [self.bodyBgView addSubview:self.playStateView];
        [self.contentView addSubview:self.audioLabel];
        [self.contentView addSubview:self.audioNoReadImage];
    }
    return self;
}

#pragma public - public

+ (CGFloat)cellHeight {
    
    return cellHeight + 0.001;
}

- (void)setIMMessage:(id<IMessageModel>)message {
    [super setIMMessage:message];
    
    [self borderImageAndFrame];
    
    if (!message.isSender) {
        if (message.isMessageRead) {
            self.audioNoReadImage.hidden = YES;
        }else {
            self.audioNoReadImage.hidden = NO;
        }
        
        self.playButton.frame = CGRectMake(0, 7, 30, 30);
        self.playStateView.frame = CGRectMake(0, 7, self.bodyBgView.width - 30 - 10, 30);
        self.audioLabel.frame = CGRectMake(self.bodyBgView.right + 5, 7, 40, 30);
        self.audioLabel.textAlignment = NSTextAlignmentRight;
    }else {
        self.audioNoReadImage.hidden = YES;
        
        self.playButton.frame = CGRectMake(0, 7, 30, 30);
        self.playStateView.frame = CGRectMake(30, 7,  self.bodyBgView.width - 30 - 10, 30);
        self.audioLabel.frame = CGRectMake(self.bodyBgView.left - 40 - 5 , 7, 40, 30);
        self.audioLabel.textAlignment = NSTextAlignmentRight;
    }
    
    if (message.mediaDuration > 0) {
        self.audioLabel.text = [NSString stringWithFormat:@"%d''",(int)message.mediaDuration];
    }
    
    self.audioNoReadImage.frame = CGRectMake(self.bodyBgView.right + 3, self.bodyBgView.top + 3, 6, 6);
    
    cellHeight =  self.bodyBgView.bottom + WJCHAT_CELL_TIMELABELHEIGHT;
    self.cellHeight = cellHeight;
    [self baseFrameLayout];
}

#pragma mark - 懒加载

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton new];
        _playButton.layer.borderWidth = 1;
    }
    return _playButton;
}

- (UILabel *)audioLabel {
    if (!_audioLabel) {
        _audioLabel = [UILabel new];
        _audioLabel.text = @"01'19'";
        _audioLabel.font = [UIFont systemFontOfSize:16];
        _audioLabel.textColor = [UIColor lightGrayColor];
        _audioLabel.layer.borderWidth = 1;
    }
    return _audioLabel;
}

- (UIImageView *)audioNoReadImage {
    if (!_audioNoReadImage) {
        _audioNoReadImage = [UIImageView new];
        _audioNoReadImage.backgroundColor = [UIColor redColor];
        _audioNoReadImage.layer.cornerRadius = 3;
        _audioNoReadImage.layer.masksToBounds = YES;
    }
    return _audioNoReadImage;
}

- (UIImageView *)playStateView {
    if (!_playStateView) {
        _playStateView = [UIImageView new];
        _playStateView.layer.borderWidth = 1;
    }
    return _playStateView;
}

@end
