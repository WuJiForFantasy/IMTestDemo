//
//  WJIMChatPicMsgCell.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/8.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMChatPicMsgCell.h"
#import "WYArrowImageTool.h"

@interface WJIMChatPicMsgCell ()

@property (nonatomic,strong)YYAnimatedImageView *picImage; //图片

@end

@implementation WJIMChatPicMsgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.bodyBgView addSubview:self.picImage];
    }
    return self;
}

#pragma mark - public 

+ (CGFloat)cellHeight {
    
    return cellHeight+0.001;
}

- (void)setIMMessage:(id<IMessageModel>)message {
    [super setIMMessage:message];
    
    [self borderImageAndFrame];
    UIImage *image = message.thumbnailImage;
    if (!image) {
        image = message.image;
        if (!image) {
            [self.picImage setImageWithURL:[NSURL URLWithString:message.fileURLPath] placeholder:[UIImage imageNamed:message.failImageName]];
        } else {
            self.picImage.image = image;
        }
    } else {
        self.picImage.image = image;
    }
    
//    self.picImage.image = [YYImage imageNamed:@"=====png-02240"];
    self.picImage.frame = self.bodyBgView.bounds;
//    NSLog(@"%@",message.fileURLPath);
//    NSLog(@"%@",message.thumbnailFileURLPath);
//    NSLog(@"%@",message.fileLocalPath);
//    NSLog(@"%@",message.thumbnailFileLocalPath);
    
//    if (!message.isSender) {
//        self.picImage.image = [WYArrowImageTool arrowLeftImage:image size:self.bodyBgView.bounds.size];
//    }else {
//        self.picImage.image = [WYArrowImageTool arrowRightImage:image size:self.bodyBgView.bounds.size];
//    }
    
    cellHeight =  self.bodyBgView.bottom+WJCHAT_CELL_TIMELABELHEIGHT;
    self.cellHeight = cellHeight;
    [self baseFrameLayout];
    [self.bodyBgView setBackgroundImage:nil forState:UIControlStateNormal];
}

#pragma mark - 懒加载

- (YYAnimatedImageView *)picImage {
    if (!_picImage) {
        _picImage = [YYAnimatedImageView new];
//        _picImage.autoPlayAnimatedImage = YES;
//        _picImage.image = [UIImage imageNamed:@"=====png-02300.gif"];
    }
    return _picImage;
}

@end
