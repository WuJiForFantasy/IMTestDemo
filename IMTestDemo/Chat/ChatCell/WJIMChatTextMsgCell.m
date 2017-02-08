//
//  WJIMChatTextMsgCell.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/8.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMChatTextMsgCell.h"
#import "MLEmojiLabel.h"
#import "WJIMMessageModel.h"
#import "WJIMChatBorderManager.h"

@interface WJIMChatTextMsgCell () <MLEmojiLabelDelegate>

@property (nonatomic, strong) MLEmojiLabel *emojiLabel; //富文本

@end

@implementation WJIMChatTextMsgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.bodyBgView addSubview:self.emojiLabel];
    }
    return self;
}

#pragma mark - public

+ (CGFloat)cellHeight {
    return cellHeight + 0.001;
}

- (void)setIMMessage:(id<IMessageModel>)message {
    [super setIMMessage:message];
    
    NSString *contentString = message.text;
    [self.emojiLabel setText:contentString];
    
    WJIMChatBorderManager *manager =  [self borderImageAndFrame];
    
    self.emojiLabel.frame = CGRectMake(manager.leftPadding, manager.topPadding,  manager.labelWidth,  manager.labelHeight);
    
    cellHeight = self.bodyBgView.bottom + WJCHAT_CELL_TIMELABELHEIGHT;
    self.cellHeight = cellHeight;
    
    [self baseFrameLayout];
}

#pragma mark - <MLEmojiLabelDelegate>

- (void)mlEmojiLabel:(MLEmojiLabel *)emojiLabel didSelectLink:(NSString *)link withType:(MLEmojiLabelLinkType)type {
    
}

#pragma mark - 懒加载

- (MLEmojiLabel *)emojiLabel
{
    if (!_emojiLabel) {
        _emojiLabel = [MLEmojiLabel new];
        _emojiLabel.numberOfLines = 0;
        _emojiLabel.disableThreeCommon = YES;
        _emojiLabel.font = [UIFont systemFontOfSize:14.0f];
        _emojiLabel.delegate = self;
        _emojiLabel.backgroundColor = [UIColor clearColor];
        _emojiLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _emojiLabel.textColor = [UIColor blackColor];
        _emojiLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _emojiLabel.isNeedAtAndPoundSign = YES;
        _emojiLabel.disableEmoji = NO;
        _emojiLabel.lineSpacing = 3.0f;
        _emojiLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        _emojiLabel.customEmojiPlistName = @"face.plist";
        _emojiLabel.customEmojiBundleName = @"Face_Expression.bundle";
    }
    return _emojiLabel;
}

@end
