//
//  WJIMChatTimeCell.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/8.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMChatTimeCell.h"

@interface WJIMChatTimeCell ()

@property (nonatomic,strong) UILabel *timeLabel;

@end

@implementation WJIMChatTimeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self defaultCommon];
        [self.contentView addSubview:self.timeLabel];
    }
    return self;
}

- (void)defaultCommon {
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.detailTextLabel.hidden = YES;
    self.textLabel.hidden = YES;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}
- (void)layoutSubviews {
    
    self.timeLabel.frame = self.contentView.bounds;
}
#pragma mark - public 

- (void)setTimeText:(NSString *)text {
    self.timeLabel.text = text;
}

#pragma mark - 懒加载

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
