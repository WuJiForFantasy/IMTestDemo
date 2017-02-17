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

@interface WJIMChatKeyBoard () <WJIMChatKeyBoardToolBarDelegate,FacePanelDelegate>

@property (nonatomic,assign) CGFloat keyBoardTopY;                          //初始的顶部坐标
@property (nonatomic,assign) CGFloat newTopY;                               //
@property (nonatomic,assign) CGFloat customKeyBoardHeight;                  //自定义键盘的高度

@property (nonatomic,strong) WJIMChatAudioBoardView *audioBoardView;        //音频键盘
@property (nonatomic,strong) WJIMChatFaceBoardView *faceBoardView;          //表情键盘
@property (nonatomic,strong) WJIMChatMoreBoardView *moreBoardView;          //更多键盘
@property (nonatomic,strong) NSArray *faceNameArray;                        //名字

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
//        self.newTopY = self.top;
       
    }];
}

#pragma mark - <FacePanelDelegate>

- (void)facePanelFacePicked:(FacePanel *)facePanel faceSize:(NSInteger)faceSize faceName:(NSString *)faceName delete:(BOOL)isDelete
{

    NSString *text = self.toolBar.textView.text;
    if (isDelete) {
        if (text.length > 1) {
            
            [self deleteEmojiStringAction:self.toolBar.textView isCustom:YES];
//            self.toolBar.textView.text = [text substringToIndex:text.length - 1];
        }else {
            self.toolBar.textView.text = @"";
        }
    }else {
        self.toolBar.textView.text = [text stringByAppendingString:faceName];
    }
    
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardFacePicked:faceSize:faceName:delete:)]) {
        [self.delegate chatKeyBoardFacePicked:self faceSize:faceSize faceName:faceName delete:isDelete];
    }
    
}

- (void)facePanelSendTextAction:(FacePanel *)facePanel
{
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardSendText:)]) {
        [self.delegate chatKeyBoardSendText:self.toolBar.textView.text];
    }
    self.toolBar.textView.text = @"";
}

- (void)facePanelAddSubject:(FacePanel *)facePanel
{
    //    if ([self.delegate respondsToSelector:@selector(chatKeyBoardAddFaceSubject:)]) {
    //        [self.delegate chatKeyBoardAddFaceSubject:self];
    //    }
}
- (void)facePanelSetSubject:(FacePanel *)facePanel
{
    //    if ([self.delegate respondsToSelector:@selector(chatKeyBoardSetFaceSubject:)]) {
    //        [self.delegate chatKeyBoardSetFaceSubject:self];
    //    }
}

#pragma mark - <WJIMChatKeyBoardToolBarDelegate>

- (void)toolBarDeleteFrom:(YYTextView *)textView {
    
    [self deleteEmojiStringAction:textView isCustom:NO];
}

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

#pragma mark - others

#pragma mark 删除表情按钮处理

- (void)deleteEmojiStringAction:(YYTextView *)textView isCustom:(BOOL)isCustom

{
    
    NSString *souceText = textView.text;
    
    NSRange range = textView.selectedRange;
    NSLog(@"%lu",(unsigned long)range.location);
    NSLog(@"``````%lu",(unsigned long)range.length);
    if (range.location == NSNotFound) {
        
        range.location = textView.text.length;
        
    }
    
    if (range.length > 0) {
        if (isCustom) {
            [textView deleteBackward];
        }
        return;
        
    }else
        
    {
        //正则匹配要替换的文字的范围
        //正则表达式
        NSString * pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        NSError *error = nil;
        NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        if (!re) {
            
            NSLog(@"%@", [error localizedDescription]);
        }
        //通过正则表达式来匹配字符串
        
        NSArray *resultArray = [re matchesInString:souceText options:0 range:NSMakeRange(0, souceText.length)];
        
        NSTextCheckingResult *checkingResult = resultArray.lastObject;
        
        for (NSString *faceName in self.faceNameArray) {
            
            if ([souceText hasSuffix:@"]"]) {
                
                if ([[souceText substringWithRange:checkingResult.range] isEqualToString:faceName]) {
                    
                    NSLog(@"faceName %@", faceName);
                    
                    NSString *newText = [souceText substringToIndex:souceText.length - checkingResult.range.length];
                    
                    if (!isCustom) {
                        newText =[newText stringByAppendingString:@" "];
                        //                    [textView deleteBackward];
                    }
                    if (faceName) {
                        textView.text = newText;
                    }else {
                        [textView deleteBackward];
                    }
                    
                    return;
                }
            }
            else
            {
                if (isCustom) {
                    [textView deleteBackward];
                }
                
                return;
            }
        }
    }
}

- (NSArray *)faceNameArray {
    if (!_faceNameArray) {
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"face" ofType:@"plist"];
        NSDictionary *faceDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        NSArray *allkeys = faceDic.allKeys;
        _faceNameArray = allkeys;
    }
    return _faceNameArray;
}


#pragma mark - 懒加载

- (WJIMChatKeyBoardToolBar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[WJIMChatKeyBoardToolBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 40)];
        _toolBar.delegate = self;
        _toolBar.textView.text = @"[偷笑][偷笑][偷笑][偷笑][偷笑]";
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
        _faceBoardView.delegate = self;
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
