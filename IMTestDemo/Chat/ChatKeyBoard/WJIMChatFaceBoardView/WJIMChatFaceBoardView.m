//
//  WJIMChatFaceBoardView.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/14.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMChatFaceBoardView.h"
#import "UIView+IM.h"
#import "WJCollectionViewHorizontalLayout.h"
#import "WJIMChatFaceBoardViewBottomCell.h"
#import "WBEmoticonInputView.h"

@interface WJIMChatFaceBoardView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *toolView;//工具管理视图
@property (nonatomic,strong) UIButton *sendButton;  //发送按钮
@property (nonatomic,strong) UIView *lineView;      //线条
//@property (nonatomic,strong) WBEmoticonInputView *faceView;
//@property
@end

//UICollectionViewFlowLayout
@implementation WJIMChatFaceBoardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
       
//        [self addSubview:self.faceView];
        [self addSubview:self.toolView];
        [self addSubview:self.sendButton];
        [self addSubview:self.lineView];
    }
    return self;
}

- (void)reloadSelected {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.toolView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionRight];
}

- (void)layoutSubviews {
    
    self.toolView.frame = CGRectMake(0, self.height - 35, self.width - 60, 35);
    self.sendButton.frame = CGRectMake(self.width - 60, self.height - 35, 60, 35);
    self.lineView.frame = CGRectMake(0, self.height - 35, self.width, 1);
}

#pragma mark - public

- (void)changeFaceSubjectIndex:(NSInteger)subjectIndex {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:subjectIndex inSection:0];
    [self.toolView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionRight];
}

#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WJIMChatFaceBoardViewBottomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.imageView.hidden = YES;
    }else {
        cell.imageView.hidden = NO;
    }

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 3;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
         return CGSizeMake(100, 35);
    }else {
         return CGSizeMake(35, 35);
    }
   
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    [_scrollView setContentOffset:CGPointMake(indexPath.row*self.frame.size.width, 0) animated:YES];
//    [collectionView cellForItemAtIndexPath:indexPath].backgroundColor = [UIColor redColor];
//    [collectionView reloadData];
}
//
//#pragma mark - <WBStatusComposeEmoticonViewDelegate>
//
//- (void)emoticonInputDidTapText:(NSString *)text {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(emoticonInputDidTapText:)]) {
//        [self.delegate emoticonInputDidTapText:text];
//    }
//}
//
//- (void)emoticonInputDidTapBackspace {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(emoticonInputDidTapBackspace)]) {
//        [self.delegate emoticonInputDidTapBackspace];
//    }
//}

#pragma mark - 懒加载

- (UICollectionView *)toolView {
    if (!_toolView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _toolView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _toolView.delegate = self;
        _toolView.dataSource = self;
        
        _toolView.backgroundColor = [UIColor whiteColor];
        [_toolView registerClass:[WJIMChatFaceBoardViewBottomCell class] forCellWithReuseIdentifier:@"cellID"];
    }
    return _toolView;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton new];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.backgroundColor = [UIColor whiteColor];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _sendButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        _lineView.alpha = 0.3;
    }
    return _lineView;
}

//- (WBEmoticonInputView *)faceView {
//    if (!_faceView) {
//        _faceView = [WBEmoticonInputView sharedView];
//        _faceView.delegate = self;
//    }
//    return _faceView;
//}

@end
