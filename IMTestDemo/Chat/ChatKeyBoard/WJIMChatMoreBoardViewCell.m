//
//  WJIMChatMoreBoardViewCell.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/14.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMChatMoreBoardViewCell.h"
#import "UIView+IM.h"

@interface WJIMChatMoreBoardViewCell ()

@end

@implementation WJIMChatMoreBoardViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (void)layoutSubviews {

    self.imageView.frame = CGRectMake(0, 0, self.width, self.height - 20);
    self.label.frame = CGRectMake(0, self.width, self.width, 20);
    
}

#pragma mark - 懒加载

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:12];
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}

@end
