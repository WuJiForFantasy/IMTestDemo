//
//  WJIMChatVideoMsgCell.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/8.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMChatVideoMsgCell.h"
#import "WYArrowImageTool.h"

@interface WJIMChatVideoMsgCell ()

@property (nonatomic,strong)UIImageView *picImage;      //图片
@property (nonatomic,strong)UIImageView *playImageView; //播放图片
@end

@implementation WJIMChatVideoMsgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self.bodyBgView addSubview:self.picImage];
        [self.bodyBgView addSubview:self.playImageView];
    }
    return self;
}

#pragma mark - public

+ (CGFloat)cellHeight {
    
    return cellHeight + 0.001;
}

- (void)setIMMessage:(id<IMessageModel>)message {
    
    [super setIMMessage:message];
    [self borderImageAndFrame];
    self.playImageView.hidden = NO;
    
    UIImage *image = message.isSender ? message.image : message.thumbnailImage;
    if (!self.message.isSender) {
        self.picImage.image = [WYArrowImageTool arrowLeftImage:image size:self.bodyBgView.bounds.size];
    }else {
        self.picImage.image = [WYArrowImageTool arrowRightImage:image size:self.bodyBgView.bounds.size];
    }
    
    self.picImage.frame = self.bodyBgView.bounds;
    self.playImageView.center = self.picImage.center;
    [self.bodyBgView setBackgroundImage:nil forState:UIControlStateNormal];
    
    cellHeight =  self.bodyBgView.bottom+WJCHAT_CELL_TIMELABELHEIGHT;
    self.cellHeight = cellHeight;
    [self baseFrameLayout];
}

#pragma mark - 懒加载

- (UIImageView *)picImage {
    if (!_picImage) {
        _picImage = [UIImageView new];

    }
    return _picImage;
}

- (UIImageView *)playImageView {
    if (!_playImageView) {
        _playImageView = [UIImageView new];
        _playImageView.hidden = YES;
        _playImageView.image = [UIImage imageNamed:@"home_ic_normal_video"];
        _playImageView.bounds = CGRectMake(0, 0, 50, 50);
    }
    return _playImageView;
}

@end
