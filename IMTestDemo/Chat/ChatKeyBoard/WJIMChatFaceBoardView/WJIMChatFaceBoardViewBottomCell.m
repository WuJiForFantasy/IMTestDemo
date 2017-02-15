//
//  WJIMChatFaceBoardViewBottomCell.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/15.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMChatFaceBoardViewBottomCell.h"
#import "UIView+IM.h"

@interface WJIMChatFaceBoardViewBottomCell ()

@property (nonatomic,strong) UIView *lineView;          //线条


@end

@implementation WJIMChatFaceBoardViewBottomCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.label];
        [self addSubview:self.imageView];
        [self addSubview:self.lineView];
    }
    return self;
}

- (void)layoutSubviews {
    
    self.lineView.frame = CGRectMake(self.width - 1, 3, 1, self.height - 6);
    self.label.frame = self.bounds;
    self.imageView.frame = self.bounds;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = [UIColor lightGrayColor];
    }else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

#pragma mark - 懒加载

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        _lineView.alpha = 0.3;
    }
    return _lineView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        _label.font = [UIFont systemFontOfSize:14];
        _label.text = @"全部表情";
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.image = [UIImage imageNamed:@"f_static_000"];
    }
    return _imageView;
}

@end
