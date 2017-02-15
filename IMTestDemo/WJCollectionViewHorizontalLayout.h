//
//  WJCollectionViewHorizontalLayout.h
//  IMTestDemo
//
//  Created by tqh on 2017/2/15.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJCollectionViewHorizontalLayout : UICollectionViewFlowLayout

// 一行中 cell的个数
@property (nonatomic) NSUInteger itemCountPerRow;
// 一页显示多少行
@property (nonatomic) NSUInteger rowCount;

@end
