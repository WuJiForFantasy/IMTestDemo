//
//  WJIMChatBorderManager.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/8.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMChatBorderManager.h"
#import "WJIMChatBorderInfo.h"
#import "MLEmojiLabel.h"

@interface WJIMChatBorderManager ()

@property (nonatomic,strong) WJIMChatBorderInfo *info;      //坐标配置参数
@property (nonatomic,strong) WJIMMessageModel *message;     //消息

@end

@implementation WJIMChatBorderManager

- (instancetype)initWithIMMessage:(id<IMessageModel>)msg {
    self = [super init];
    if (self) {
        
        self.message = msg;
        
        //创建不同的坐标位置参数
        if (msg.message.direction == EMMessageDirectionReceive) {
            self.info = [WJIMChatBorderInfo defaultBorderInfoFromOther];
            
        }else {
            self.info = [WJIMChatBorderInfo defaultBorderInfoFromMe];
        }
        
        switch (self.message.bodyType) {
        
            case EMMessageBodyTypeText:
                
                [self messageText];
                break;
                
            default:
                break;
        }
        
    }
    return self;
}

#pragma mark - private

- (void)messageText {
    
    static MLEmojiLabel *protypeLabel = nil;
    if (!protypeLabel) {
        protypeLabel = [MLEmojiLabel new];
        protypeLabel.numberOfLines = 0;
        protypeLabel.font = [UIFont systemFontOfSize:14.0f];
        protypeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        //                protypeLabel.textInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        protypeLabel.isNeedAtAndPoundSign = YES;
        protypeLabel.disableEmoji = NO;
        protypeLabel.lineSpacing = 3.0f;
        protypeLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        protypeLabel.customEmojiPlistName = @"face.plist";
        protypeLabel.customEmojiBundleName = @"Face_Expression.bundle";
    }
    NSString *contentString = self.message.text;
    [protypeLabel setText:contentString];
    CGSize size = [protypeLabel preferredSizeWithMaxWidth:WJCHAT_CELL_CONTENT_MAXWIDTH-20];
    
    self.labelWidth = size.width;
    self.labelHeight = size.height+5;
    
    if (self.labelHeight < 25) {
        self.labelHeight = 30;
    }
    if (self.labelWidth < 10) {
        self.labelWidth = 10;
    }
    
    self.width = self.labelWidth + self.info.leftPadding + self.info.rightPadding;
    self.height = self.labelHeight + self.info.bottomPadding ;
    
    self.leftPadding = self.info.leftPadding;
    self.topPadding = self.info.topPadding;
    
}

- (UIImage *)borderImage {
    return self.info.borderImage;
}

@end