//
//  UICollectionView+LXMoveDeleteCell.h
//  lexiwed2
//
//  Created by ganyue on 2018/7/2.
//  Copyright © 2018年 乐喜网. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LXCollectionViewCellMoveSoreDelegate <NSObject>

@optional

- (BOOL)collectionView:(nonnull UICollectionView *)collectionView
        shouldMoveCell:(nonnull UICollectionViewCell *)cell
           atIndexPath:(nonnull NSIndexPath *)indexPath;

- (void)collectionView:(nonnull UICollectionView *)collectionView
           putDownCell:(nonnull UICollectionViewCell *)cell
           atIndexPath:(nonnull NSIndexPath *)indexPath;

- (BOOL)collectionView:(nonnull UICollectionView *)collectionView
        shouldMoveCell:(nonnull UICollectionViewCell *)cell
         fromIndexPath:(nonnull NSIndexPath *)fromIndexPath
           toIndexPath:(nonnull NSIndexPath *)toIndexPath;

- (void)collectionView:(nonnull UICollectionView *)collectionView
           didMoveCell:(nonnull UICollectionViewCell *)cell
         fromIndexPath:(nonnull NSIndexPath *)fromIndexPath
           toIndexPath:(nonnull NSIndexPath *)toIndexPath;


@end

@interface UICollectionView (LXMoveDeleteCell)

@property (nonatomic, weak) id<LXCollectionViewCellMoveSoreDelegate> _Nullable moveDelegate;

@property (nonatomic, assign) BOOL rearrangementEnable;

/**
 *  长按cell接触边缘时collectionView自动滚动的速率，每1/60秒移动的距离
 */
@property (nonatomic, assign) CGFloat autoScrollSpeet;

/**
 *  长按放大倍数
 *  默认为1.2
 */
@property (nonatomic, assign) CGFloat longPressMagnification;

/**
 *  滑动类型,是否需要阴影
 */
@property (nonatomic, assign) BOOL moveTypeEnable;


@end
