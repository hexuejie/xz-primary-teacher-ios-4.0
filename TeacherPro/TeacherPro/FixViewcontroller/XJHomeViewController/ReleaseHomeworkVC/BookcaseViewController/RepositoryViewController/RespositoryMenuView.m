//
//  RespositoryMenuView.m
//  TeacherPro
//
//  Created by 何学杰 on 2018/11/28.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "RespositoryMenuView.h"
#import "RespostioryMenuQueryItem.h"
#import "ResopositoryQueryHeadView.h"
#import "SVProgressHelper.h"

static CGFloat widthMargin = 278.0;

@interface RespositoryMenuView ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property (strong, nonatomic) UIView *maskView;

@property (strong, nonatomic) UIView *collectionMaskView;
@property (strong, nonatomic) UICollectionView *menuCollectionView;
@property (strong, nonatomic) UIView *bottomView;

@property (strong, nonatomic) NSArray *sectionArray;

@property (strong, nonatomic) NSMutableArray *selectGradeNameArray;
@end


@implementation RespositoryMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.maskView = [[UIView alloc]initWithFrame:self.bounds];
    self.maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    [self addSubview:self.maskView];
    UITapGestureRecognizer *maskTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeMenuView)];
    [self.maskView addGestureRecognizer:maskTap];
    
    self.collectionMaskView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth-widthMargin, 0, widthMargin, kScreenHeight)];
    self.collectionMaskView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.collectionMaskView];
    
    [self setbottomView];
    
    
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc]init];
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//设置布局方向为垂直流布局
    
    self.menuCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, widthMargin, kScreenHeight-76) collectionViewLayout:collectionViewLayout];
    self.menuCollectionView.showsVerticalScrollIndicator = NO;
    self.menuCollectionView.showsHorizontalScrollIndicator = NO;
    self.menuCollectionView.dataSource = self;
    self.menuCollectionView.delegate = self;
    self.menuCollectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionMaskView addSubview:self.menuCollectionView];
//    [self.collectionMaskView regis];
    
    
    [self.menuCollectionView registerClass:[ResopositoryQueryHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ResopositoryQueryHeadView"];
    [self.menuCollectionView registerClass:[RespostioryMenuQueryItem class] forCellWithReuseIdentifier:@"RespostioryMenuQueryItem"];
    
    self.maskView.alpha = 0.0;
    self.collectionMaskView.hidden = YES;
}

- (void)setbottomView{
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-76, widthMargin, 76)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.collectionMaskView addSubview:self.bottomView];
    UIButton *resetButton = [[UIButton alloc]initWithFrame:CGRectMake(16, 16, 123, 44)];
    resetButton.backgroundColor = HexRGB(0xD1EFFF);
    [self.bottomView addSubview:resetButton];
    UIButton *finishButton = [[UIButton alloc]initWithFrame:CGRectMake(16+123, 16, 123, 44)];
    finishButton.backgroundColor = HexRGB(0x2DB5FF);
    [self.bottomView addSubview:finishButton];
    [resetButton setTitle:@"重置" forState:UIControlStateNormal];
    [finishButton setTitle:@"确定" forState:UIControlStateNormal];
    resetButton.titleLabel.font = systemMediumFontSize(16);
    finishButton.titleLabel.font = systemMediumFontSize(16);
    [resetButton setTitleColor:HexRGB(0x2DB5FF) forState:UIControlStateNormal];
    [finishButton setTitleColor:HexRGB(0xffffff) forState:UIControlStateNormal];
    
    [resetButton addTarget:self action:@selector(resetClick:) forControlEvents:UIControlEventTouchUpInside];
    [finishButton addTarget:self action:@selector(finishClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:resetButton.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(4,4)];//圆角大小
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = resetButton.bounds;
    maskLayer.path = maskPath.CGPath;
    resetButton.layer.mask = maskLayer;
    
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:resetButton.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadii:CGSizeMake(4,4)];//圆角大小
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = finishButton.bounds;
    maskLayer2.path = maskPath2.CGPath;
    finishButton.layer.mask = maskLayer2;
}

#pragma mark ---- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.sectionArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.bookQueryModel) {
        if (section == 0) {
            return self.bookQueryModel.queryGrade.count;
        }else if(section == 1){
            return self.bookQueryModel.queryPublisher.count;
        }
    }else if (self.cartoonQueryModel) {
        if (section == 0) {
            return self.cartoonQueryModel.queryGrade.count;
        }else if(section == 1){
            if (self.selectGradeNameArray != nil) {
                return self.selectGradeNameArray.count;
            }
            return self.cartoonQueryModel.queryLevel.count;
        }
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RespostioryMenuQueryItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RespostioryMenuQueryItem" forIndexPath:indexPath];
    SubjectQueryModel *model;
    if (self.bookQueryModel) {
        if (indexPath.section == 0) {
            model = self.bookQueryModel.queryGrade[indexPath.row];
            cell.titleLabel.text = model.gradeName;
        }else if(indexPath.section == 1){
            model = self.bookQueryModel.queryPublisher[indexPath.row];
            cell.titleLabel.text = model.publisherName;
        }
    }else if (self.cartoonQueryModel) {
        if (indexPath.section == 0) {
            model = self.cartoonQueryModel.queryGrade[indexPath.row];
            cell.titleLabel.text = model.gradeName;
        }else if(indexPath.section == 1){
            if (self.selectGradeNameArray != nil) {
                model = self.selectGradeNameArray[indexPath.row];
            }else{
                model = self.cartoonQueryModel.queryLevel[indexPath.row];
            }
            
            cell.titleLabel.text = model.level;
        }
    }
    if (model.isSelected) {
        cell.contentView.backgroundColor = HexRGB(0x2DB5FF);
        cell.titleLabel.textColor = HexRGB(0xffffff);
    }else{
        cell.contentView.backgroundColor = HexRGB(0xf4f4f4);
        cell.titleLabel.textColor = HexRGB(0x4D4D4D);
    }
    return cell;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(74, 36);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 16, 8, 16);//16 12
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){widthMargin,45};
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    ResopositoryQueryHeadView * sectionView  = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ResopositoryQueryHeadView" forIndexPath:indexPath];
    sectionView.titleLbel.text = self.sectionArray[indexPath.section];
    sectionView.topLineView.hidden = NO;
    if (indexPath.section == 0) {
        sectionView.topLineView.hidden = YES;
    }
    return sectionView;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.bookQueryModel) {
        if (indexPath.section == 0) {
            for (int i = 0; i<self.bookQueryModel.queryGrade.count; i++) {
                SubjectQueryModel *model = self.bookQueryModel.queryGrade[i];
                if (indexPath.row == i) {
                   
                    if (model.isSelected == YES) {
                        model.isSelected = NO;
                        self.gradeModel = nil;
                    }else{
                        model.isSelected = YES;
                        self.gradeModel = model;
                    }
                }else{
                    model.isSelected = NO;
                }
            }
        }else if(indexPath.section == 1){
           
            for (int i = 0; i<self.bookQueryModel.queryPublisher.count; i++) {
                SubjectQueryModel *model = self.bookQueryModel.queryPublisher[i];
                if (indexPath.row == i) {
                    
                    if (model.isSelected == YES) {
                        model.isSelected = NO;
                        self.publisherModel = nil;
                    }else{
                        model.isSelected = YES;
                        self.publisherModel = model;
                    }
                }else{
                    model.isSelected = NO;
                }
            }
        }
    }else if (self.cartoonQueryModel) {
        if (indexPath.section == 0) {
            
            for (int i = 0; i<self.cartoonQueryModel.queryGrade.count; i++) {
                SubjectQueryModel *model = self.cartoonQueryModel.queryGrade[i];
                if (indexPath.row == i) {
                    
                    if (model.isSelected == YES) {
                        model.isSelected = NO;
                        self.gradeModel = nil;
                    }else{
                        model.isSelected = YES;
                        self.gradeModel = model;
                    }
                    
                    //jilian
                    self.selectGradeNameArray = nil;
//                    for (SubjectQueryModel *tempModel in self.cartoonQueryModel.queryLevel) {
//                        if (tempModel.gradeName == self.gradeModel.gradeName) {
//                            [self.selectGradeNameArray addObject:tempModel];
//                        }
//                    }
                    [self.menuCollectionView reloadData];
                    
                }else{
                    model.isSelected = NO;
                }
            }
        }else if(indexPath.section == 1){
            
            for (int i = 0; i<self.cartoonQueryModel.queryLevel.count; i++) {
                SubjectQueryModel *model = self.cartoonQueryModel.queryLevel[i];
                if (indexPath.row == i) {
                    
                    if (model.isSelected == YES) {
                        model.isSelected = NO;
                        self.levelModel = nil;
                    }else{
                        model.isSelected = YES;
                        self.levelModel = model;
                    }
                    
                }else{
                    model.isSelected = NO;
                }
            }
        }
    }
    [self.menuCollectionView reloadData];
}

- (void)resetClick:(UIButton *)button{
    self.gradeModel = nil;
    self.publisherModel = nil;
    self.levelModel = nil;
    self.selectGradeNameArray = nil;
    
    [self collectionView:self.menuCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:999 inSection:0]];
    [self collectionView:self.menuCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:999 inSection:1]];
    
    if ([self.delegate respondsToSelector:@selector(respositoryMenuViewFinish:)]) {
        [self.delegate respositoryMenuViewFinish:self];
    }
    [self closeMenuView];
}

- (void)finishClick:(UIButton *)button{
    
    if(self.levelModel == nil && self.cartoonQueryModel && self.gradeModel){
    
        [SVProgressHelper dismissWithMsg:@"请选择级别"];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(respositoryMenuViewFinish:)]) {
        [self.delegate respositoryMenuViewFinish:self];
    }
    [self closeMenuView];
}

- (void)beginShowMenuView{
    self.collectionMaskView.frame = CGRectMake(kScreenWidth, 0, widthMargin, kScreenHeight);
    self.maskView.alpha = 1.0;
    self.collectionMaskView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.collectionMaskView.frame = CGRectMake(kScreenWidth-widthMargin, 0, widthMargin, kScreenHeight);
    }];
    [self.menuCollectionView reloadData];
}

- (void)closeMenuView{
    [UIView animateWithDuration:0.2 animations:^{
        self.maskView.alpha = 0.0;
        self.collectionMaskView.frame = CGRectMake(kScreenWidth, 0, widthMargin, kScreenHeight);
    } completion:^(BOOL finished) {
        
        if ([self.delegate respondsToSelector:@selector(respositoryMenuViewClose:)]) {
            [self.delegate respositoryMenuViewClose:self];
        }
    }];
}

- (void)setBookQueryModel:(BookQueryModel *)bookQueryModel{
    _bookQueryModel = bookQueryModel;
    if (_bookQueryModel) {
        self.sectionArray = @[@"年级",@"版本"];
        [self.menuCollectionView reloadData];
    }
}

- (void)setCartoonQueryModel:(CartoonQueryModel *)cartoonQueryModel{
    _cartoonQueryModel = cartoonQueryModel;
    if (_cartoonQueryModel) {
        self.sectionArray = @[@"年级",@"级别"];
        [self.menuCollectionView reloadData];
    }
}

@end
