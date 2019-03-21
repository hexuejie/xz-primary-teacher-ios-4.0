//
//  ReleaseImageCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/13.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ReleaseImageCell.h"
#import "DecorateImageViewCell.h"
#import "PublicDocuments.h"
#import "UIImageView+WebCache.h"
#import "LxGridViewFlowLayout.h"


typedef NS_ENUM(NSInteger, ReleaseImageCellType){

    ReleaseImageCellType_normal =  0,
    ReleaseImageCellType_local      ,//本地
    ReleaseImageCellType_network    ,//网络
};
static NSString *const DecorateImageCellIdentifier = @"DecorateImageCellIdentifier";

@interface ReleaseImageCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *selectedPhotos;//图片数据
@property(nonatomic, strong) NSMutableArray *selectedAssets;

@property(nonatomic, strong) NSArray *selectedPhotosUrl;
@property(nonatomic, assign) CGFloat  itemWH;
@property(nonatomic, assign) CGFloat  margin;
@property(weak, nonatomic) IBOutlet UIImageView *bottomLine;
@property(nonatomic, assign) ReleaseImageCellType  type;
@end
@implementation ReleaseImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled =  NO;
    self.collectionView.collectionViewLayout =  [self getCollectionViewLayout];
    self.collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
   
    [self registCell];
    [self.bottomLine setBackgroundColor:project_line_gray];
    
}
- (void)registCell{

    [self.collectionView registerClass: [DecorateImageViewCell class]  forCellWithReuseIdentifier:DecorateImageCellIdentifier];
}
- (UICollectionViewFlowLayout *)getCollectionViewLayout{
    CGFloat itemWidth = (IPHONE_WIDTH -20)/3;
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    collectionViewLayout.itemSize = CGSizeMake(itemWidth,itemWidth);
    collectionViewLayout.minimumInteritemSpacing = 0;
    collectionViewLayout.minimumLineSpacing = 0;
    return collectionViewLayout;
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger row = 0;
    self.bottomLine.hidden = NO;
    if (self.type == ReleaseImageCellType_local) {
        row = self.selectedPhotos.count;
    }else if (self.type  == ReleaseImageCellType_network){
       row = self.selectedPhotosUrl.count;
    }else{
        self.bottomLine.hidden = YES;
    }
    if (row>0&&row<9) {
        return row+1;
    }
    return row;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
      DecorateImageViewCell * imageViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:DecorateImageCellIdentifier forIndexPath:indexPath];
        imageViewCell.videoImageView.hidden = YES;
    if (indexPath.row == _selectedPhotos.count) {
        imageViewCell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn"];
        imageViewCell.deleteBtn.hidden = YES;
        imageViewCell.image.hidden = YES;//删除按钮
    }else if (self.type == ReleaseImageCellType_local) {
        imageViewCell.imageView.image = _selectedPhotos[indexPath.row];
        imageViewCell.asset = _selectedAssets[indexPath.row];
        imageViewCell.deleteBtn.hidden = NO;
        imageViewCell.image.hidden = NO;//删除按钮
    }else  if (self.type == ReleaseImageCellType_network){
        [imageViewCell.imageView sd_setImageWithURL:_selectedPhotosUrl[indexPath.row]];
        imageViewCell.deleteBtn.hidden = NO;
        imageViewCell.image.hidden = NO;//删除按钮
    }
    imageViewCell.deleteBtn.tag = indexPath.row;
    [imageViewCell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    
    return imageViewCell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.lookImageBlock) {
        self.lookImageBlock(indexPath);
    }

}

- (void)deleteBtnClik:(UIButton *)sender {
    if (_selectedPhotos.count<sender.tag) {
        return;
    }
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    [self.collectionView reloadData];
    
#warning 待优化
    
    if ([_selectedPhotos count] ==0 || [_selectedPhotos count] ==6 || [_selectedPhotos count] == 3) {
        if (self.deleteBlock) {
            self.deleteBlock(sender);
        }
    }
}

- (void)setupReleaseImageCellPhotos:(NSMutableArray *)selectedPhotos withAssets:(NSMutableArray *)selectedAssets{
 
     self.type = ReleaseImageCellType_local;
    self.selectedPhotos = selectedPhotos;
    self.selectedAssets = selectedAssets;
    [self.collectionView reloadData];

}

#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.row < _selectedPhotos.count && destinationIndexPath.row < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = _selectedPhotos[sourceIndexPath.row];
    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.row];
    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.row];
    
    id asset = _selectedAssets[sourceIndexPath.row];
    [_selectedAssets removeObjectAtIndex:sourceIndexPath.row];
    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.row];
    
    [_collectionView reloadData];
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 0, 10);
}


@end
