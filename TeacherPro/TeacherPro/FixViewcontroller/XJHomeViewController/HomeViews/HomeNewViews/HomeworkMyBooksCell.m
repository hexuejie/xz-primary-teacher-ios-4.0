
//
//  HomeworkMyBooksCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/5/28.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HomeworkMyBooksCell.h"
#import "MyBooksCell.h"
#import "HomeListModel.h"
#import "PublicDocuments.h"
NSString * const MyBooksCellIdentifier  = @"MyBooksCellIdentifier";
@interface HomeworkMyBooksCell()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) HomeListModel * booksModel;
@property (weak, nonatomic) IBOutlet UIButton *recentlyBtn;
@end
@implementation HomeworkMyBooksCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupView];
}
- (void)setupView{
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    [self registerCell];
}

-(void)registerCell{
  
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MyBooksCell class]) bundle:nil] forCellWithReuseIdentifier:MyBooksCellIdentifier];
}

- (void)setupHomeBooksModel:(HomeListModel *)model{
    
    self.booksModel = model;
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger rows = 1;
    if (self.booksModel.books && [self.booksModel.books count] > 0) {
          rows =  [self.booksModel.books count];
    }
    return rows;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    MyBooksCell * tempCell = [collectionView dequeueReusableCellWithReuseIdentifier:MyBooksCellIdentifier forIndexPath:indexPath];
     if (self.booksModel.books && [self.booksModel.books count] > 0) {
         [tempCell setupBookData:self.booksModel.books[indexPath.row]]; 
     }else{
         [tempCell setupAddBookUI];
     }
    cell = tempCell;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeBooksModel * model = nil;
     if (self.booksModel.books && [self.booksModel.books count] > 0) {
        model  = self.booksModel.books[indexPath.row];
     }
    if (self.selectedBooksBlock) {
        self.selectedBooksBlock(model);
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.width/3, self.collectionView.frame.size.height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)lookBookSelfAction:(id)sender {
    
    if (self.bookSelfBlock) {
        self.bookSelfBlock();
    }
    
}

@end
