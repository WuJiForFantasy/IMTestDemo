//
//  WJIMChatAudioBoardView.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/14.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMChatAudioBoardView.h"
#import "WJIMChatAudioBoardAnimation.h"
#import "UIView+IM.h"

@interface WJIMChatAudioBoardView ()

@property (nonatomic,strong) WJIMChatAudioBoardAnimation *animationView;    //动画
@property (nonatomic,strong) UIButton *audioButton;                         //音频按钮
@property (nonatomic,strong) UILabel *timeLabel;                            //时间文本

@end

@implementation WJIMChatAudioBoardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        _animationView = [[WJIMChatAudioBoardAnimation alloc]initWithFrame:CGRectMake((CGRectGetWidth([UIScreen mainScreen].bounds) - 200)/2,0,200, 200)];
        [_animationView startAnimation];
        
        [self addSubview:self.animationView];
        [self addSubview:self.audioButton];
        self.audioButton.frame = CGRectMake(0, 0, 100, 100);
        self.audioButton.center = self.animationView.center;
        
        
        self.timeLabel.frame = CGRectMake(self.audioButton.mj_x, 10, 100, 20);
        [self addSubview:self.timeLabel];
    }
    return self;
}

#pragma mark - 懒加载

- (UIButton *)audioButton {
    if (!_audioButton) {
        _audioButton = [UIButton new];
        _audioButton.backgroundColor = [UIColor whiteColor];
        _audioButton.layer.cornerRadius = 50;
        _audioButton.layer.masksToBounds = YES;
        [_audioButton setTitle:@"录音" forState:UIControlStateNormal];
        [_audioButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _audioButton.layer.borderWidth = 1;
    }
    return _audioButton;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor redColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = @"0:20";
    }
    return _timeLabel;
}

@end
