
//
//  WordPracticeViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "WordPracticeViewController.h"
#import "HeardAndWordTypeModel.h"

#import "BookHomeworkItemCell.h"
#import "BookHomeworkUnitSectionHeaderView.h"
#import "BookHomeworkChapterSectionView.h"
#import "ProUtils.h"

NSString * const BookHomeworkItemCellIdentifier = @"BookHomeworkItemCellIdentifier";
NSString * const BookHomeworkUnitSectionHeaderViewIdentifier = @"BookHomeworkUnitSectionHeaderViewIdentifier";
NSString * const BookHomeworkChapterSectionViewIdentifier = @"BookHomeworkChapterSectionViewIdentifier";

@class XLPagerTabStripViewController;
@interface WordPracticeViewController ()
@property(nonatomic, strong) HeardAndWordTypeModel * detailModel;
@property(nonatomic, strong) NSMutableArray * selectedHomeworkArray; //元素是一个字典  key id 章节id   sectionName 章节名字  content 章节下的内容是一个数组
@property(nonatomic, strong) NSMutableArray * selectedIndexArray;
@property(nonatomic, strong) NSDictionary * unityIconDic;//字段对应的图片
@property(nonatomic, strong) NSArray *wordCacheData;
@end

@implementation WordPracticeViewController
- (instancetype)initWithCacheData:(NSArray *)wordCacheData{
    self = [super init];
    if (self) {
        self.wordCacheData = wordCacheData;
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.unityIconDic = [ProUtils getZXLXUnitIconDic];
    [self configCollectionView];
}

- (void)configCollectionView{
    
    self.collectionView.backgroundColor = [UIColor  whiteColor];
    
    
}
- (NSMutableArray *)selectedIndexArray{
    if (!_selectedIndexArray) {
        _selectedIndexArray = [NSMutableArray array];
    }
    return _selectedIndexArray;
}
- (NSMutableArray *)selectedHomeworkArray{

    if (!_selectedHomeworkArray) {
        _selectedHomeworkArray = [[NSMutableArray alloc]init];
    }
    return _selectedHomeworkArray;
}
- (CGRect)getCollectionViewFrame{
   CGFloat  bottomHeight = FITSCALE(50);
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - FITSCALE(44) - bottomHeight);
    return frame;
}
- (void)registerCell{

    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkItemCell class]) bundle:nil] forCellWithReuseIdentifier:BookHomeworkItemCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkChapterSectionView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BookHomeworkChapterSectionViewIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkUnitSectionHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BookHomeworkUnitSectionHeaderViewIdentifier];
}
-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return @"词汇练习";
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)updateViewData:(HeardAndWordTypeModel *)model{

    self.detailModel = model;
    

    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //子线程
    dispatch_async(globalQueue,^{
        
        //
        [self checkCacheData];
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        //异步返回主线程，根据获取的数据，更新UI
        dispatch_async(mainQueue, ^{
            NSLog(@"根据更新UI界面");
            [self updateCollectionView];
            if (self.homeworkBlock) {
                self.homeworkBlock(self.selectedHomeworkArray);
            }
        });
        
    });
    
}
- (void)checkCacheData{
    NSMutableArray * tempCacheArray = [NSMutableArray array];
    
    [tempCacheArray addObjectsFromArray:self.wordCacheData.firstObject[@"appType"]];
    if (tempCacheArray.count > 0 ) {
        WordTypeModel * wordTypeModel =  self.detailModel.words.firstObject;
        for (int i = 0; i< [wordTypeModel.appTypes count]; i++) {
            AppTypesModel * typesModel = wordTypeModel.appTypes[i];
            
            if ([tempCacheArray containsObject: typesModel.typeEn ]) {
//                [self.selectedIndexArray addObject:[NSIndexPath indexPathForRow:i inSection:1]];
                NSIndexPath * index = [NSIndexPath indexPathForRow:i inSection:1];
                [self relsetSelectedIndex:index withOperation:NO];
            }
        }
    }
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger sections = 0;
    if (self.detailModel) {
        sections = [self.detailModel.words count]+ 1;
    }
    return sections;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger  rows =  0;
    if (section == 0) {
        rows = 0;
    }else{
        WordTypeModel * wordModel = self.detailModel.words[section - 1];
        rows = [wordModel.appTypes count];
    }
    return rows;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    
    BookHomeworkItemCell * tempCell = [collectionView dequeueReusableCellWithReuseIdentifier:BookHomeworkItemCellIdentifier forIndexPath:indexPath];
    
     WordTypeModel * wordModel = self.detailModel.words[indexPath.section - 1];
    AppTypesModel * item = wordModel.appTypes[indexPath.row];
    [tempCell setupItem:item withIconImgName:self.unityIconDic[item.typeEn] withType:BookHomeworkItemType_word];
    if ([self.selectedIndexArray containsObject:indexPath]) {
      [tempCell setupChooseState:YES];
    }else{
      [tempCell setupChooseState:NO];
    }
   cell = tempCell;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((IPHONE_WIDTH)/2, FITSCALE(60));
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = nil;
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        
        if (indexPath.section  == 0) {
            BookHomeworkUnitSectionHeaderView * sectionView  = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BookHomeworkUnitSectionHeaderViewIdentifier forIndexPath:indexPath];
            [sectionView setupUnitName:self.detailModel.unitName];
            
            headerView  = sectionView;
        }else{
            BookHomeworkChapterSectionView * sectionView  = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BookHomeworkChapterSectionViewIdentifier forIndexPath:indexPath];
            sectionView.backgroundColor = project_background_gray;
            WordTypeModel * wordModel = self.detailModel.words[indexPath.section -1];
            [sectionView setupChapterName:wordModel.sectionName];
            headerView  = sectionView;
        }
        
    }
    
    return headerView;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){IPHONE_WIDTH,FITSCALE(44)};
}

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self relsetSelectedIndex:indexPath withOperation:YES];
    [self updateCollectionView];
    if (self.homeworkBlock) {
        self.homeworkBlock(self.selectedHomeworkArray);
    }
    
}


- (void)relsetSelectedIndex:(NSIndexPath *)indexPath withOperation:(BOOL)operation  {
    WordTypeModel * wordModel = self.detailModel.words[indexPath.section - 1];
    AppTypesModel * item = wordModel.appTypes[indexPath.row];
    if (self.selectedHomeworkArray.count == 0) {
        [self.selectedHomeworkArray addObject:@{@"id":wordModel.id,@"sectionName":wordModel.sectionName,@"content":@[[item  toDictionary]]}];
        [self.selectedIndexArray addObject:indexPath];
    }else{
        NSMutableArray * tempSelectedIdHomeworkArray =[NSMutableArray array];
            NSMutableDictionary * tempSelectedTypeEnDic=[NSMutableDictionary dictionary];
            NSMutableDictionary * tempSelectedContentDic=[NSMutableDictionary dictionary];
            for (NSDictionary * tempDic in self.selectedHomeworkArray) {
                [tempSelectedIdHomeworkArray addObject: tempDic[@"id"]];
                NSMutableArray * contentArray = [NSMutableArray array];
                for (NSDictionary *contentDic in tempDic[@"content"]) {
                    [contentArray addObject:contentDic[@"typeEn"]];
                }
                [tempSelectedTypeEnDic setObject:contentArray forKey:tempDic[@"id"]];
                [tempSelectedContentDic setObject:tempDic[@"content"] forKey:tempDic[@"id"]];
            }
            
            //单元下有选中的数据
            if ([tempSelectedIdHomeworkArray containsObject:wordModel.id]) {
                
                NSArray * contents = tempSelectedTypeEnDic[wordModel.id];
                NSMutableArray * newContenArray = [NSMutableArray array];
                NSArray * oldContenArray =  tempSelectedContentDic[wordModel.id];
                [newContenArray addObjectsFromArray:oldContenArray];
                if ([contents containsObject:item.typeEn]) {
                    //自己手动操作有删除  缓存的不删除
                    if (operation) {
                        [newContenArray removeObject:[item  toDictionary] ];
                        [self.selectedIndexArray removeObject:indexPath];
                    }
                    
                }else{
                    [newContenArray addObject:[item  toDictionary] ];
                    [self.selectedIndexArray addObject:indexPath];
                }
                
                //获取所在位置
                NSInteger index = [tempSelectedIdHomeworkArray indexOfObject:wordModel.id];
                //是否存在选择作业
                if (newContenArray.count == 0) {
                    [self.selectedHomeworkArray removeObjectAtIndex:index];
                    
                }else{
                    
                    NSMutableDictionary * dic  = [[NSMutableDictionary alloc]initWithDictionary: [self.selectedHomeworkArray objectAtIndex:index]];
                    [dic setObject:newContenArray forKey:@"content"];
                    [self.selectedHomeworkArray replaceObjectAtIndex:index withObject:dic];
                    
                }
            }
            //单元没有选中的数据
            else{
                
                [self.selectedHomeworkArray addObject:@{@"id":wordModel.id,@"sectionName":wordModel.sectionName,@"content":@[[item  toDictionary]]}];
                [self.selectedIndexArray addObject:indexPath];
            }
            
        }
        
 
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"no_book.png"];
}
- (NSString *)getDescriptionText{
    
    return @"该单元没有练习~";
}
@end
