//
//  WJIMChatBaseCell.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/7.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMChatBaseCell.h"

@interface WJIMChatBaseCell ()

@property (nonatomic) EMChatType chatType; //聊天类型，群聊，单聊，聊天室

@end

@implementation WJIMChatBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self defaultCommon];
        [self.contentView addSubview:self.avatarView];
        [self.headerView addSubview:self.nickNameLabel];
        [self.contentView addSubview:self.bodyBgView];
        [self.contentView addSubview:self.footerView];
        [self.contentView addSubview:self.headerView];
        [self.footerView addSubview:self.timeLabel];
        [self.contentView addSubview:self.errorView];
        [self.contentView addSubview:self.readView];
        [self.contentView addSubview:self.activity];
        self.readView.hidden = YES;
        [self addEvent];

    }
    return self;
}

//添加事件
- (void)addEvent {
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleViewTapAction:)];
    [self.bodyBgView addGestureRecognizer:tapRecognizer];

    UITapGestureRecognizer *tapRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarViewTapAction:)];
    [self.avatarView addGestureRecognizer:tapRecognizer2];
}


#pragma mark - public

+ (CGFloat)cellHeight {
    return cellHeight + 0.001;
}

- (void)setIMMessage:(id<IMessageModel>)message {
    
    self.message = message;
    self.timeLabel.text = @"";
    
    if (self.chatType != EMChatTypeChat) {
        self.nickNameLabel.text = message.nickname;
        [self.avatarView setImageWithURL:[NSURL URLWithString:message.avatarURLPath] placeholder:nil];
    }
  
    //显示基础逻辑控件的逻辑
    switch (message.message.status) {
        case EMMessageStatusDelivering:
        {
            
            self.readView.hidden = YES;
            self.errorView.hidden = YES;
            [self.activity setHidden:NO];
            [self.activity startAnimating];
        }
            break;
        case EMMessageStatusSuccessed:
        {
            self.errorView.hidden = YES;
            if (message.isMessageRead) {
                self.readView.hidden = NO;
            }
            [self.activity stopAnimating];
        }
            break;
        case EMMessageStatusPending:
        case EMMessageStatusFailed:
        {
            self.errorView.hidden = NO;
            if (message.isSender) {
                self.timeLabel.text = @"信息发送失败";
                self.timeLabel.textColor = [UIColor redColor];
            }
            self.readView.hidden = YES;
            [self.activity stopAnimating];
            [self.activity setHidden:YES];
            
        }
            break;
        default:
            break;
    }
    
    
}


- (WJIMChatBorderManager *)borderImageAndFrame {
    
    CGFloat left = WJCHAT_CELL_LEFT_PADDING;
    CGFloat right = WJCHAT_CELL_RIGHT_PADDING;
    CGFloat minY = WJCHAT_CELL_HEADER;
    if (self.chatType == EMChatTypeChat) {
        left = 0;
        right = 0;
        minY = 0;
    }
    
    WJIMChatBorderManager *manager = [[WJIMChatBorderManager alloc]initWithIMMessage:self.message];
    [self.bodyBgView setBackgroundImage:manager.borderImage forState:UIControlStateNormal];
    if (!self.message.isSender) {
        
        self.bodyBgView.frame = CGRectMake(left+WJCHAT_CELL_PADDING, minY, manager.width, manager.height);
    }else {
        self.bodyBgView.frame = CGRectMake(WJCHAT_CELL_WIDTH-right-WJCHAT_CELL_PADDING-manager.width, minY, manager.width, manager.height);
    }
    return manager;
}

//基础布局汇总
- (void)baseFrameLayout {
    
    [self avatarFrameLayout];
    [self timeLabelFrameLayout];
    [self errorViewFrameLayout];
}

//头像布局
- (void)avatarFrameLayout {

    CGFloat minY = WJCHAT_CELL_HEADER;
    //如果是单独聊天
    if (self.chatType == EMChatTypeChat) {
        minY = 0;
    }
    if (!self.message.isSender) {
        self.avatarView.frame = CGRectMake(15, minY, WJCHAT_CELL_AVATARWIDTH, WJCHAT_CELL_AVATARWIDTH);
        if (self.chatType != EMChatTypeChat) {
            self.nickNameLabel.frame = CGRectMake(self.avatarView.right + 20, 0, 100, 20);
        }else {
            self.nickNameLabel.frame = CGRectZero;
            self.avatarView.frame = CGRectZero;
        }
        
    }else {
        self.avatarView.frame = CGRectMake(WJCHAT_CELL_WIDTH-WJCHAT_CELL_RIGHT_PADDING,minY, WJCHAT_CELL_AVATARWIDTH, WJCHAT_CELL_AVATARWIDTH);
        self.nickNameLabel.frame = CGRectZero;
        if (self.chatType == EMChatTypeChat) {
            self.avatarView.frame = CGRectZero;
        }
    }
}

//时间布局
- (void)timeLabelFrameLayout {
    
    if (!self.message.isSender) {
        self.footerView.frame = CGRectMake(self.bodyBgView.left, self.cellHeight-WJCHAT_CELL_TIMELABELHEIGHT, WJCHAT_CELL_CONTENT_MAXWIDTH, WJCHAT_CELL_TIMELABELHEIGHT);
        self.timeLabel.frame = CGRectMake(10, 4, 80, 20);
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
    }else {
        self.footerView.frame = CGRectMake(self.bodyBgView.left, self.cellHeight-WJCHAT_CELL_TIMELABELHEIGHT, WJCHAT_CELL_CONTENT_MAXWIDTH, WJCHAT_CELL_TIMELABELHEIGHT);
        self.timeLabel.frame = CGRectMake(self.bodyBgView.width - 80 - 20, 4, 80, 20);
        self.timeLabel.textAlignment = NSTextAlignmentRight;
    }
}

//错误布局
- (void)errorViewFrameLayout {
    
    if (!self.message.isSender) {
        self.errorView.frame = CGRectMake(self.bodyBgView.right, self.bodyBgView.centerY-20, 40, 40);
        self.readView.frame = CGRectZero;
    }else {
        self.readView.frame =  CGRectMake(self.bodyBgView.left-20-7, self.bodyBgView.top + 2, 20, 12.5);
        self.errorView.frame = CGRectMake(self.bodyBgView.left-40, self.bodyBgView.centerY-20, 40, 40);
    }
    
    self.activity.frame = self.errorView.frame;
}

#pragma mark - 事件监听

- (void)bubbleViewTapAction:(UITapGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (!_delegate) {
            return;
        }
        if ([_delegate respondsToSelector:@selector(messageCellSelected:)]) {
            [_delegate messageCellSelected:self.message];
        }
        
        if ([_delegate respondsToSelector:@selector(messageCellSelected:cell:)]) {
            [_delegate messageCellSelected:self.message cell:self];
        }
        
    }
}

- (void)avatarViewTapAction:(UITapGestureRecognizer *)sender {
    
    if ([_delegate respondsToSelector:@selector(avatarViewSelcted:)]) {
        [_delegate avatarViewSelcted:self.message];
    }
    
}

- (void)errorViewPressed {
    
    if ([_delegate respondsToSelector:@selector(errorViewSelcted:)]) {
        [_delegate errorViewSelcted:self.message];
    }
}


#pragma mark - others

//默认
- (void)defaultCommon {
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.detailTextLabel.hidden = YES;
    self.textLabel.hidden = YES;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

// 用于UIMenuController显示，缺一不可
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - 懒加载

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [UIImageView new];
        _avatarView.layer.cornerRadius = 5;
        _avatarView.layer.masksToBounds = YES;
        _avatarView.userInteractionEnabled = YES;
        _avatarView.backgroundColor = [UIColor whiteColor];
    }
    return _avatarView;
}

- (UILabel *)nickNameLabel {
    if (!_nickNameLabel) {
        _nickNameLabel = [UILabel new];
        _nickNameLabel.font = [UIFont systemFontOfSize:11];
        _nickNameLabel.textColor = [UIColor whiteColor];
    }
    return _nickNameLabel;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [UIView new];
    }
    return _headerView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [UIView new];
    }
    return _footerView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = [UIColor colorWithHexString:@"a3a3a3"];
    
    }
    return _timeLabel;
}


- (UIButton *)bodyBgView {
    if (!_bodyBgView) {
        _bodyBgView = [UIButton new];
    }
    return _bodyBgView;
}

- (UIButton *)errorView {
    if (!_errorView) {
        _errorView = [UIButton new];
        [_errorView setImage:[UIImage imageNamed:@"new_ic_failure"] forState:UIControlStateNormal];
        [_errorView addTarget:self action:@selector(errorViewPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _errorView;
}


- (UIButton *)readView {
    if (!_readView) {
        _readView = [[UIButton alloc]init];
        [_readView setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"93d050"]] forState:UIControlStateNormal];
        [_readView setTitle:@"已读" forState:UIControlStateNormal];
        _readView.titleLabel.font = [UIFont systemFontOfSize:7];
        _readView.layer.cornerRadius = 3;
        _readView.layer.masksToBounds = YES;
    }
    return _readView;
}

- (UIActivityIndicatorView *)activity {
    if (!_activity) {
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activity.hidden = YES;
    }
    return _activity;
}

- (EMChatType)chatType {
    
    return self.message.message.chatType;
}

@end
