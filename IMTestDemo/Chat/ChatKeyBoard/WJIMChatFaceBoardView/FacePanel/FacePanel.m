//
//  ChatFacePanel.m
//  FaceKeyboard

//  Company：     SunEee
//  Blog:        devcai.com
//  Communicate: 2581502433@qq.com

//  Created by ruofei on 16/3/30.
//  Copyright © 2016年 ruofei. All rights reserved.
//
//  2581502433@qq.com

/**
    尝试了 scroll + scroll
          collection + collection
    最终确定方案  scroll + collection
 */

#import "FacePanel.h"
#import "FaceView.h"
#import "PanelBottomView.h"
#import "ChatKeyBoardMacroDefine.h"

extern NSString * SmallSizeFacePanelfacePickedNotification;
extern NSString * MiddleSizeFacePanelfacePickedNotification;

@interface FacePanel () < PanelBottomViewDelegate>


@property (nonatomic,strong) UIButton *sendButton;//发送按钮

@end

@implementation FacePanel
{
//    UIScrollView *_scrollView;
    PanelBottomView  *_panelBottomView;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton new];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:12];
//        _sendButton.backgroundColor = [UIColor yellowColor];
        [_sendButton addTarget:self action:@selector(sendButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

- (void)sendButtonPressed {
    NSLog(@"表情键盘发送---from%@",[self class]);
    if (_delegate && [_delegate respondsToSelector:@selector(facePanelSendTextAction:)]) {
        [_delegate facePanelSendTextAction:self];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SmallSizeFacePanelfacePickedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MiddleSizeFacePanelfacePickedNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        //暂时将底部隐藏
        _panelBottomView.hidden = YES;
    }
    return self;
}

#pragma mark -- 数据源
- (void)loadFaceSubjectItems:(NSArray<FaceSubjectModel *>*)subjectItems
{
    self.faceSources = subjectItems;
    
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * self.faceSources.count, 0);
    
    for (int i = 0; i < self.faceSources.count; i++) {
        FaceView *faceView = [[FaceView alloc] initWithFrame:CGRectMake(i*CGRectGetWidth(_scrollView.frame), 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
        [faceView loadFaceSubject:self.faceSources[i]];
        [_scrollView addSubview:faceView];
    }
    
    [_panelBottomView loadfaceSubjectPickerSource:self.faceSources];
    [self reloadSelected];
}

- (void)reloadSelected {
    
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView) {
    
        CGFloat pageWidth = scrollView.frame.size.width;
    
        NSInteger currentIndex = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
        [_panelBottomView changeFaceSubjectIndex:currentIndex];
    }
}

#pragma mark -- PanelBottomViewDelegate
- (void)panelBottomView:(PanelBottomView *)panelBottomView didPickerFaceSubjectIndex:(NSInteger)faceSubjectIndex
{
    [_scrollView setContentOffset:CGPointMake(faceSubjectIndex*self.frame.size.width, 0) animated:YES];
}

- (void)panelBottomViewSendAction:(PanelBottomView *)panelBottomView
{
    if ([self.delegate respondsToSelector:@selector(facePanelSendTextAction:)]) {
        [self.delegate facePanelSendTextAction:self];
    }
}

#pragma mark -- NSNotificationCenter
- (void)smallFaceClick:(NSNotification *)noti
{
    NSDictionary *info = [noti object];
    NSString *faceName = [info objectForKey:@"FaceName"];
    BOOL isDelete = [[info objectForKey:@"IsDelete"] boolValue];
    
    if ([self.delegate respondsToSelector:@selector(facePanelFacePicked:faceSize:faceName:delete:)]) {
        [self.delegate facePanelFacePicked:self faceSize:0 faceName:faceName delete:isDelete];
    }
}

- (void)middleFaceClick:(NSNotification *)noti
{
    NSString *faceName = [noti object];
    if ([self.delegate respondsToSelector:@selector(facePanelFacePicked:faceSize:faceName:delete:)]) {
        [self.delegate facePanelFacePicked:self faceSize:1 faceName:faceName delete:NO];
    }
}

- (void)initSubViews
{
    self.backgroundColor = kChatKeyBoardColor;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kFacePanelHeight-kFacePanelBottomToolBarHeight)];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    
    _panelBottomView = [[PanelBottomView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame), self.frame.size.width, kFacePanelBottomToolBarHeight)];
    _panelBottomView.delegate = self;
    [self addSubview:_panelBottomView];
    self.sendButton.frame = CGRectMake(kScreenWidth - 60, CGRectGetMaxY(_scrollView.frame)-40+5, 60, 40);
    [self addSubview:self.sendButton];
    
    __weak __typeof(self) weakSelf = self;
    _panelBottomView.addAction = ^(){
        if ([weakSelf.delegate respondsToSelector:@selector(facePanelAddSubject:)]) {
            [weakSelf.delegate facePanelAddSubject:weakSelf];
        }
    };
    
    _panelBottomView.setAction = ^(){
        if ([weakSelf.delegate respondsToSelector:@selector(facePanelSetSubject:)]) {
            [weakSelf.delegate facePanelSetSubject:weakSelf];
        }
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(smallFaceClick:) name:SmallSizeFacePanelfacePickedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(middleFaceClick:) name:MiddleSizeFacePanelfacePickedNotification object:nil];
}

@end
