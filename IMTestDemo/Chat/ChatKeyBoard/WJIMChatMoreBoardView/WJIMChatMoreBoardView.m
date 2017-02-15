//
//  WJIMChatMoreBoardView.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/14.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "WJIMChatMoreBoardView.h"
#import "WJIMChatMoreBoardViewCell.h"

@interface WJIMChatMoreBoardView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *dataTitleArray;
@property (nonatomic,strong) NSArray *dataImageArray;

@end

@implementation WJIMChatMoreBoardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)layoutSubviews {
    self.collectionView.frame = self.bounds;
}

#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WJIMChatMoreBoardViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:self.dataImageArray[indexPath.row]];
    cell.label.text = self.dataTitleArray[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataImageArray.count;
}

#pragma mark - 懒加载

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        CGFloat width = 60;
        CGFloat paddding = (CGRectGetWidth([UIScreen mainScreen].bounds) - width *4 - 40)/3;
        layout.itemSize = CGSizeMake(width, width);
        layout.minimumLineSpacing = 30;
        layout.minimumInteritemSpacing = paddding;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor lightGrayColor];
        _collectionView.contentInset = UIEdgeInsetsMake(15, 20, 15, 20);
        [_collectionView registerClass:[WJIMChatMoreBoardViewCell class] forCellWithReuseIdentifier:@"cellID"];
    }
    return _collectionView;
}

- (NSArray *)dataTitleArray {
    if (!_dataTitleArray) {
        _dataTitleArray = @[@"照片",@"拍摄",@"视频",@"红包",@"测试"];
    }
    return _dataTitleArray;
}

- (NSArray *)dataImageArray {
    if (!_dataImageArray) {
        _dataImageArray = @[@"news_ic_Photo",@"news_ic_Photograph",@"news_ic_video",@"news_ic_red",@"news_ic_red"];
    }
    return _dataImageArray;
}

@end
