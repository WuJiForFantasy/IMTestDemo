//
//  WJIMChatLocationMsgCell.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/8.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMChatLocationMsgCell.h"
#import "WYArrowImageTool.h"

@interface WJIMChatLocationMsgCell ()

@end

@implementation WJIMChatLocationMsgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.bodyBgView addSubview:self.picImage];
        [self.bodyBgView addSubview:self.bottomView];
        [self.bottomView addSubview:self.locationIcon];
        [self.bottomView addSubview:self.locationLabel];
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
    UIImage *image = [UIImage imageNamed:@"new_ic_send_location"] ;
    //    self.picImage.image = [[UIImage imageNamed:@"EaseUIResource.bundle/chat_location_preview"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    
    if (!self.message.isSender) {
        self.picImage.image = [WYArrowImageTool arrowLeftImage:image size:image.size];
    }else {
        self.picImage.image = [WYArrowImageTool arrowRightImage:image size:image.size];
    }
    self.locationLabel.text = message.address;
    
    if (!self.message.isSender) {
        self.picImage.frame = CGRectMake(20, 10, self.bodyBgView.width - 30, self.bodyBgView.height - 20);
        self.bottomView.frame = CGRectMake(10, self.bodyBgView.height - 35, self.bodyBgView.width-10, 35);
    }else {
        self.picImage.frame = CGRectMake(10, 10, self.bodyBgView.width - 30, self.bodyBgView.height - 20);
        self.bottomView.frame = CGRectMake(0, self.bodyBgView.height - 35, self.bodyBgView.width-10-2, 35);
    }
    
    self.locationIcon.frame = CGRectMake(0, 0, 35, 35);
    self.locationLabel.frame = CGRectMake(self.locationIcon.right, 0, self.bottomView.width - self.locationIcon.right, 35);
    
    cellHeight =  self.bodyBgView.bottom+WJCHAT_CELL_TIMELABELHEIGHT;
    self.cellHeight = cellHeight;
    [self baseFrameLayout];
    
    self.picImage.frame = self.bodyBgView.bounds;
    [self.bodyBgView setBackgroundImage:nil forState:UIControlStateNormal];
    
}

#pragma mark - 懒加载

- (UIImageView *)picImage {
    if (!_picImage) {
        _picImage = [UIImageView new];
        //        _picImage.backgroundColor = [UIColor redColor];
    }
    return _picImage;
}

- (UIButton *)locationIcon {
    if (!_locationIcon) {
        _locationIcon = [UIButton new];
        [_locationIcon setImage:[UIImage imageNamed:@"new_ic_pos1"] forState:UIControlStateNormal];
    }
    return _locationIcon;
}

- (UILabel *)locationLabel {
    if (!_locationLabel) {
        _locationLabel = [UILabel new];
        _locationLabel.text = @"我来自火星";
        _locationLabel.font = [UIFont systemFontOfSize:15];
        _locationLabel.textColor = [UIColor blackColor];
        
    }
    return _locationLabel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor redColor];
//        [_bottomView jm_setJMRadius:JMRadiusMake(0, 0, 5, 5) withBackgroundColor:[UIColor colorWithHexString:@"7fccfb"]];
        
    }
    return _bottomView;
}


@end
