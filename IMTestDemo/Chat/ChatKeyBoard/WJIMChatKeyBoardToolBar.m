//
//  WJIMChatKeyBoardToolBar.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/14.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMChatKeyBoardToolBar.h"
#import "YYText.h"
#import "WJKeyBoardManager.h"

@interface WJIMChatKeyBoardToolBar () <YYTextViewDelegate>

@property (nonatomic,strong) UIButton *audioButton;     //音频按钮
@property (nonatomic,strong) UIButton *faceButton;      //表情按钮
@property (nonatomic,strong) UIButton *moreButton;      //更多按钮
@property (nonatomic,strong) YYTextView *textView;      //文本输入
@property (nonatomic,strong) UIView *topLineView;       //顶部线条
@property (nonatomic,strong) UIView *bottomLineView;    //底部线条

@property (nonatomic,assign) UIEdgeInsets contentInset;    //内容
@property (nonatomic,assign) CGFloat toolBarTopY;       //键盘弹起的时候监听
@property (nonatomic,assign) CGFloat toolBarHeight;     //键盘弹起的工具条的高度

@end

@implementation WJIMChatKeyBoardToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.toolBarTopY = frame.origin.y;
        self.toolBarHeight = frame.size.height;
        self.backgroundColor = [UIColor whiteColor];
        [self common];
    }
    return self;
}

- (void)common {
    
    [self addSubview:self.audioButton];
    [self addSubview:self.faceButton];
    [self addSubview:self.moreButton];
    [self addSubview:self.textView];
    [self addSubview:self.topLineView];
    [self addSubview:self.bottomLineView];
    
}



- (void)resetSelected {
    self.audioButton.selected = NO;
    self.faceButton.selected = NO;
    self.moreButton.selected = NO;
}

- (void)layoutSubviews {
    
    self.contentInset = UIEdgeInsetsMake(5, 40, 5, 80);
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat contentHeight = CGRectGetHeight(self.textView.bounds);
    CGFloat contentWidth = width - self.contentInset.left - self.contentInset.right;
    CGFloat contentDefaultHeight = height - self.contentInset.top - self.contentInset.bottom;
    
    [UIView animateWithDuration:0.2 animations:^{

        if (self.textView.textLayout.textBoundingRect.size.height < 35) {
            
            self.textView.frame = CGRectMake(self.contentInset.left, self.contentInset.top,contentWidth,contentDefaultHeight);
            self.toolBarChangeHeight = 0;
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(toolBarChangeFrame:changeHeight:)]) {
                self.frame = CGRectMake(0, 0, width, self.toolBarHeight);
                [self.delegate toolBarChangeFrame:self changeHeight:0];
            }else {
                self.frame = CGRectMake(0, self.toolBarTopY , width, self.toolBarHeight);
            }
            
        }else {
            
            self.textView.frame = CGRectMake(self.contentInset.left, self.contentInset.top,contentWidth+1,self.textView.textLayout.textBoundingRect.size.height + self.contentInset.top + self.contentInset.bottom+1);
            
            self.toolBarChangeHeight = self.textView.textLayout.textBoundingRect.size.height + 2 * (self.contentInset.top + self.contentInset.bottom) - self.toolBarHeight;
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(toolBarChangeFrame:changeHeight:)]) {
                self.frame = CGRectMake(0, 0, width, self.toolBarChangeHeight + self.toolBarHeight);
                [self.delegate toolBarChangeFrame:self changeHeight:self.toolBarChangeHeight];
            }else {
                self.frame = CGRectMake(0, self.toolBarTopY - contentHeight + self.toolBarHeight - ( self.contentInset.top + self.contentInset.bottom), width, self.textView.textLayout.textBoundingRect.size.height + 2 * (self.contentInset.top + self.contentInset.bottom));
            }
            
        }
    }];
    
    self.audioButton.frame = CGRectMake(0, 0, 40, 40);
    self.faceButton.frame = CGRectMake(width - 80, 0, 40, 40);
    self.moreButton.frame = CGRectMake(width - 40, 0, 40, 40);
    self.topLineView.frame = CGRectMake(0, 0, width, 1);
    self.bottomLineView.frame = CGRectMake(0, 39, width, 1);
}

#pragma mark - 事件监听

- (void)audioButtonPressed:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.faceButton.selected = NO;
    self.moreButton.selected = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(toolBarSelectedAtIndex:selected:textView:)]) {
        [self.delegate toolBarSelectedAtIndex:0 selected:sender.selected textView:self.textView];
    }
}

- (void)faceButtonPressed:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.audioButton.selected = NO;
    self.moreButton.selected = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(toolBarSelectedAtIndex:selected:textView:)]) {
        [self.delegate toolBarSelectedAtIndex:1 selected:sender.selected textView:self.textView];
    }
}

- (void)moreButtonPressed:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.audioButton.selected = NO;
    self.faceButton.selected = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(toolBarSelectedAtIndex:selected:textView:)]) {
        [self.delegate toolBarSelectedAtIndex:2 selected:sender.selected textView:self.textView];
    }
}

#pragma mark - <YYTextViewDelegate>

- (void)textViewDidBeginEditing:(YYTextView *)textView {
    self.audioButton.selected = NO;
    self.faceButton.selected = NO;
    self.moreButton.selected = NO;
   
}



- (void)textViewDidChange:(YYTextView *)textView {
    //改变的时候刷新布局
    [self setNeedsLayout];
    
//    if (self.ContentBlock && textView.text.length != 0) {
//        //点击发送这里有置为空的操作，所以要判断是否为空
//        self.ContentBlock(textView.text);
//    }
}

-(BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //如果为回车则将键盘收起
    if ([text isEqualToString:@"\n"]) {
        
        //刷新布局
        [self setNeedsLayout];
        [textView resignFirstResponder];
        textView.placeholderText = @"说点什么吧...";
        if (self.didFinishBlock) {
            self.didFinishBlock(textView.text,textView.attributedText);
        }
        textView.text = @"";
        return NO;
    }
    return YES;
}

#pragma mark - 懒加载

- (UIButton *)audioButton {
    if (!_audioButton) {
        _audioButton = [UIButton new];
        [_audioButton setImage:[UIImage imageNamed:@"news_ic_Voice"] forState:UIControlStateNormal];
        [_audioButton addTarget:self action:@selector(audioButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _audioButton;
}

- (UIButton *)faceButton {
    if (!_faceButton) {
        _faceButton = [UIButton new];
        [_faceButton setImage:[UIImage imageNamed:@"news_ic_Expression"] forState:UIControlStateNormal];
        [_faceButton setImage:[UIImage imageNamed:@"news_ic_keyboard"] forState:UIControlStateSelected];
        [_faceButton addTarget:self action:@selector(faceButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _faceButton;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton new];
        [_moreButton setImage:[UIImage imageNamed:@"news_ic_more"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(moreButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (YYTextView *)textView {
    if (!_textView) {
        _textView = [[YYTextView alloc]init];
        _textView.autocorrectionType=UITextAutocorrectionTypeNo;
        _textView.autocapitalizationType=UITextAutocapitalizationTypeNone;
        _textView.delegate = self;
        _textView.placeholderText = @"说点什么吧...";
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.placeholderFont = [UIFont systemFontOfSize:15];
        _textView.textContainerInset = UIEdgeInsetsMake(10, 10, 0, 10);
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.layer.cornerRadius = 20;
        _textView.layer.masksToBounds = YES;
    }
    return _textView;
}

- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [UIView new];
        _topLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _topLineView;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [UIView new];
        _bottomLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _bottomLineView;
}

@end
