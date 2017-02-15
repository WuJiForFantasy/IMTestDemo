//
//  WJKeyBoardManager.m
//  moyouAPP
//
//  Created by 幻想无极（谭启宏） on 16/10/12.
//  Copyright © 2016年 幻想无极（谭启宏）. All rights reserved.
//

#import "WJKeyBoardManager.h"

@interface WJKeyBoardManager ()

@property (nonatomic,weak)UIScrollView *scrollview;

@end

static keyBoarddWillShowBlock _willShow;
static keyBoarddWillHideBlock _willHide;


@implementation WJKeyBoardManager

+ (instancetype)sharedKeyBoardManager {
    static dispatch_once_t onceToken;
    static WJKeyBoardManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WJKeyBoardManager alloc]init];
    });
    return instance;
}

- (void)addNotificationAtkeyBoarddwithView:(UIView *)view WillShow:(keyBoarddWillShowBlock)willShow willHide:(keyBoarddWillHideBlock)willHide; {
    _willShow = [willShow copy];
    _willHide = [willHide copy];
    
    if ([view isKindOfClass:[UIScrollView class]]) {
        self.scrollview = (UIScrollView *)view;
    }
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)scrollsToBottomAnimated:(BOOL)animated scrollview:(UIScrollView *)scrollview
{
    CGFloat offset = scrollview.contentSize.height - scrollview.bounds.size.height;
    if (offset > 0)
    {
        [scrollview setContentOffset:CGPointMake(0, offset) animated:animated];
    }
}


- (void)removeNotification {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    self.keyboardHeight = height;
    if (_willShow) {
        _willShow(self.keyboardHeight);
    }
    [self scrollsToBottomAnimated:NO scrollview:self.scrollview];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    if (_willHide) {
        _willHide();
    }
}

@end
