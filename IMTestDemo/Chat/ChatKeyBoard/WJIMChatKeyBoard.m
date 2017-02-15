//
//  WJIMChatKeyBoard.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/14.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMChatKeyBoard.h"
#import "WJKeyBoardManager.h"
#import "UIView+IM.h"
#import "WJIMChatAudioBoardView.h"
#import "WJIMChatFaceBoardView.h"
#import "WJIMChatMoreBoardView.h"
#import "FaceSourceManager.h"

@interface WJIMChatKeyBoard () <WJIMChatKeyBoardToolBarDelegate>

@property (nonatomic,assign) CGFloat keyBoardTopY;                          //初始的顶部坐标
@property (nonatomic,assign) CGFloat newTopY;                               //
@property (nonatomic,assign) CGFloat customKeyBoardHeight;                  //自定义键盘的高度

@property (nonatomic,strong) WJIMChatAudioBoardView *audioBoardView;        //音频键盘
@property (nonatomic,strong) WJIMChatFaceBoardView *faceBoardView;          //表情键盘
@property (nonatomic,strong) WJIMChatMoreBoardView *moreBoardView;          //更多键盘

@end

@implementation WJIMChatKeyBoard

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.keyBoardTopY = frame.origin.y;
        self.newTopY = self.keyBoardTopY;
        self.customKeyBoardHeight = 216;
        [self common];
        [self addSubview:self.audioBoardView];
        [self addSubview:self.faceBoardView];
        [self addSubview:self.moreBoardView];
    }
    return self;
}

- (void)dealloc {
    
    [[WJKeyBoardManager sharedKeyBoardManager] removeNotification];
}

- (void)resetKeyBoard {
    [self endEditing:YES];
    [self.toolBar resetSelected];
    [UIView animateWithDuration:0.25 animations:^{
        self.top = self.keyBoardTopY - self.toolBar.toolBarChangeHeight;
    }];
}

- (void)layoutSubviews {
    
    self.audioBoardView.frame = CGRectMake(0, 40+self.toolBar.toolBarChangeHeight, CGRectGetWidth(self.bounds), self.customKeyBoardHeight);
    self.faceBoardView.frame = CGRectMake(0, 40+self.toolBar.toolBarChangeHeight, CGRectGetWidth(self.bounds), self.customKeyBoardHeight);
    self.moreBoardView.frame = CGRectMake(0, 40+self.toolBar.toolBarChangeHeight, CGRectGetWidth(self.bounds), self.customKeyBoardHeight);
}

- (void)common {
    
    
    [self addSubview:self.toolBar];
    
    [[WJKeyBoardManager sharedKeyBoardManager] addNotificationAtkeyBoarddwithView:self WillShow:^(CGFloat keyboardHeight) {

        self.top = self.keyBoardTopY - keyboardHeight- self.toolBar.toolBarChangeHeight;
        self.newTopY = self.keyBoardTopY - keyboardHeight;
    } willHide:^{
        
        self.top = self.keyBoardTopY - self.toolBar.toolBarChangeHeight;
        self.newTopY = self.top;
       
    }];
}

#pragma mark - <WJIMChatKeyBoardToolBarDelegate>

- (void)toolBarChangeFrame:(WJIMChatKeyBoardToolBar *)toolBar changeHeight:(CGFloat)changeHeight {
    
    self.top = self.newTopY - changeHeight;
    self.height = changeHeight + 40 + self.customKeyBoardHeight;
}

- (void)toolBarSelectedAtIndex:(NSInteger)index selected:(BOOL)selected textView:(YYTextView *)textView{
    if (index == 0 || index == 2) {
        if (selected) {

            [textView endEditing:YES];
            [UIView animateWithDuration:0.25 animations:^{
                self.top = self.keyBoardTopY - self.toolBar.toolBarChangeHeight - self.customKeyBoardHeight;
            }];
        }else {
            [UIView animateWithDuration:0.25 animations:^{
                self.top = self.keyBoardTopY - self.toolBar.toolBarChangeHeight;
            }];
        }
    }else if (index == 1) {
        if (selected) {
            [textView endEditing:YES];
            [UIView animateWithDuration:0.25 animations:^{
                self.top = self.keyBoardTopY - self.toolBar.toolBarChangeHeight - self.customKeyBoardHeight;
            }];
        }else {
            [textView becomeFirstResponder];
        }
    }
    
    if (selected) {
        switch (index) {
            case 0:
            {
                self.audioBoardView.hidden = NO;
                self.faceBoardView.hidden = YES;
                self.moreBoardView.hidden = YES;
            }
                break;
            case 1:
            {
                self.audioBoardView.hidden = YES;
                self.faceBoardView.hidden = NO;
                self.moreBoardView.hidden = YES;
            }
                break;
            case 2:
            {
                self.audioBoardView.hidden = YES;
                self.faceBoardView.hidden = YES;
                self.moreBoardView.hidden = NO;
            }
                break;
            default:
                break;
        }

    }
}

#pragma mark - 懒加载

- (WJIMChatKeyBoardToolBar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[WJIMChatKeyBoardToolBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 40)];
        _toolBar.delegate = self;
    }
    return _toolBar;
}

- (WJIMChatAudioBoardView *)audioBoardView {
    if (!_audioBoardView) {
        _audioBoardView = [WJIMChatAudioBoardView new];
    }
    return _audioBoardView;
}

- (WJIMChatFaceBoardView *)faceBoardView {
    if (!_faceBoardView) {
        _faceBoardView = [[WJIMChatFaceBoardView alloc]initWithFrame:CGRectMake(0, 40+self.toolBar.toolBarChangeHeight, CGRectGetWidth(self.bounds), self.customKeyBoardHeight)];
        [_faceBoardView loadFaceSubjectItems:[FaceSourceManager loadFaceSource]];
    }
    return _faceBoardView;
}

- (WJIMChatMoreBoardView *)moreBoardView {
    if (!_moreBoardView) {
        _moreBoardView = [WJIMChatMoreBoardView new];
    }
    return _moreBoardView;
}

@end
