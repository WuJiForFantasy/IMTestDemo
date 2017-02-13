//
//  WJIMConversationCell.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/11.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMConversationCell.h"
#import "UIView+IM.h"

@interface WJIMConversationCell ()

@property (nonatomic,strong) UIImageView *avatarImageView;  //头像
@property (nonatomic,strong) UILabel *titleLabel;           //标题
@property (nonatomic,strong) UILabel *contentLabel;         //内容
@property (nonatomic,strong) UIView *lineView;              //线条

@end

@implementation WJIMConversationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

- (void)layoutSubviews {
    
    self.avatarImageView.frame = CGRectMake(10, 10, 40, 40);
    self.titleLabel.frame = CGRectMake(self.avatarImageView.right + 10, 10, 100, 20);
    self.contentLabel.frame = CGRectMake(self.avatarImageView.right + 10, 50, 100, 20);
    self.lineView.frame = CGRectMake(0, self.height - 1, self.width, 1);
}

#pragma mark - public

- (void)setModel:(WJIMConversationModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
}

+ (CGFloat)cellHeight {
    
    return 70;
}

#pragma mark - 懒加载

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.backgroundColor = [UIColor redColor];
    }
    return _avatarImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
    }
    return _contentLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor redColor];
    }
    return _lineView;
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
