
//
//  HeardPracticeViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "HeardPracticeViewController.h"
#import "HeardAndWordTypeModel.h"
#import "BookHomeworkItemCell.h"
#import "BookHomeworkSectionView.h"
#import "BookHomeworkChapterSectionView.h"

#import "BookHomeworkItemCell.h"
#import "BookHomeworkUnitSectionHeaderView.h"
#import "BookHomeworkChapterSectionView.h"
#import "ProUtils.h"


NSString * const BookHomeworkHeardItemCellIdentifier = @"BookHomeworkItemCellIdentifier";
NSString * const  BookHomeworkHeardUnitSectionHeaderViewIdentifier = @"BookHomeworkUnitSectionHeaderViewIdentifier";
NSString * const BookHomeworkHeardChapterSectionViewIdentifier = @"BookHomeworkChapterSectionViewIdentifier";

@class XLPagerTabStripViewController;
@interface HeardPracticeViewController ()
@property(nonatomic, strong) HeardAndWordTypeModel * detailModel;
@property(nonatomic, strong) NSMutableArray * selectedHomeworkArray;//元素是一个字典  key id 章节id   sectionName 章节名字  content 章节下的内容是一个数组
@property(nonatomic, strong) NSMutableArray * selectedIndexArray;
@property(nonatomic,strong)    NSDictionary * unityIconDic;//字段对应的图片
@property(nonatomic, strong) NSArray *heardCacheData;
@end

@implementation HeardPracticeViewController
- (instancetype)initWithCacheData:(NSArray *)heardCacheData{
    self = [super init];
    if (self) {
        self.heardCacheData = heardCacheData;
        
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
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
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
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkItemCell class]) bundle:nil] forCellWithReuseIdentifier:BookHomeworkHeardItemCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkChapterSectionView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BookHomeworkHeardChapterSectionViewIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkUnitSectionHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BookHomeworkHeardUnitSectionHeaderViewIdentifier];
}
-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    return @"听说练习";
    
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


- (void)setupCacheHeardData:(HeardAndWordTypeModel *)model{
    
    self.detailModel = model;
     
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //子线程
    dispatch_async(globalQueue,^{
        
        //
        [self checkCacheData];
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        //异步返回主线程，根据获取的数据，更新UI
        dispatch_async(mainQueue, ^{
 
          
            if (self.homeworkBlock) {
                self.homeworkBlock(self.selectedHomeworkArray);
            }
        });
        
    });
    
}


- (void)checkCacheData{
    //获取所有缓存选中的单元id
    NSMutableArray * tempCacheSectionIds = [NSMutableArray array];
    //根据单元id 存储对应的内容
    NSMutableDictionary * tempCacheSectionDic = [NSMutableDictionary dictionary];
    for (NSDictionary * dic in self.heardCacheData) {
        [tempCacheSectionIds addObject:dic[@"sectionId"]];
        [tempCacheSectionDic setObject:dic[@"appType"] forKey:dic[@"sectionId"]];
    }
    
    if (tempCacheSectionIds.count > 0 ) {
        
        for (int section = 0; section< [self.detailModel.listenAndTalk count]; section++) {
            
            ListenAndTalkModel * listenAndTalkModel =  self.detailModel.listenAndTalk[section];
            //缓存的单元id 是否与当前显示的id相同
            if ([tempCacheSectionIds containsObject:listenAndTalkModel.id]) {
                for (int row = 0; row <[listenAndTalkModel.appTypes count]; row++) {
                    AppTypesModel * typesModel = listenAndTalkModel.appTypes[row];
                    //根据单元id 获取对应的内容
                    NSArray *tempCacheTypes = tempCacheSectionDic[listenAndTalkModel.id];
                    //判断当前显示的内容是否缓存的数据
                    if ([tempCacheTypes containsObject: typesModel.typeEn ]) {
                        //存在记录当前的位置
                        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:section+1];
                        [self relsetSelectedIndex:indexPath withOperation:NO];
                    }
                }
            }
            
        }
    }
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger  section = 0;
    if (self.detailModel) {
        section = [self.detailModel.listenAndTalk count]+ 1;
    }
    return section;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger  rows =  0;
    if (section == 0) {
        rows = 0;
    }else{
        ListenAndTalkModel * listenAndTalk = self.detailModel.listenAndTalk[section - 1];
        rows = [listenAndTalk.appTypes count];
    }
    return rows;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = nil;
    
    BookHomeworkItemCell * tempCell = [collectionView dequeueReusableCellWithReuseIdentifier:BookHomeworkHeardItemCellIdentifier forIndexPath:indexPath];
    
    ListenAndTalkModel * listenAndTalk = self.detailModel.listenAndTalk[indexPath.section - 1];
    AppTypesModel * item = listenAndTalk.appTypes[indexPath.row];
    [tempCell setupItem:item withIconImgName:self.unityIconDic[item.typeEn] withType:BookHomeworkItemType_heard];
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
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        UICollectionReusableView *headerView = nil;
        
        if (indexPath.section  == 0) {
            BookHomeworkUnitSectionHeaderView * sectionView  = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BookHomeworkHeardUnitSectionHeaderViewIdentifier forIndexPath:indexPath];
            [sectionView setupUnitName:self.detailModel.unitName];
            headerView  = sectionView;
        }else{
            BookHomeworkChapterSectionView * sectionView  = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BookHomeworkHeardChapterSectionViewIdentifier forIndexPath:indexPath];
            sectionView.backgroundColor = project_background_gray;
            ListenAndTalkModel * listenAndTalkModel = self.detailModel.listenAndTalk[indexPath.section -1];
            [sectionView setupChapterName:listenAndTalkModel.sectionName];
            headerView  = sectionView;
        }
        return headerView;
    }
    
    
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){IPHONE_WIDTH,FITSCALE(44)};
}
 
// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //子线程
    dispatch_async(globalQueue,^{
       //
       [self relsetSelectedIndex:indexPath withOperation:YES];
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
- (void)relsetSelectedIndex:(NSIndexPath *)indexPath withOperation:(BOOL)operation  {
    ListenAndTalkModel * listenAndTalk = self.detailModel.listenAndTalk[indexPath.section - 1];
    AppTypesModel * item = listenAndTalk.appTypes[indexPath.row];
    
    if (self.selectedHomeworkArray.count == 0) {
        [self.selectedHomeworkArray addObject:@{@"id":listenAndTalk.id,@"sectionName":listenAndTalk.sectionName,@"content":@[[item  toDictionary]]}];
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
        if ([tempSelectedIdHomeworkArray containsObject:listenAndTalk.id]) {
            
            NSArray * contents = tempSelectedTypeEnDic[listenAndTalk.id];
            NSMutableArray * newContenArray = [NSMutableArray array];
            NSArray * oldContenArray =  tempSelectedContentDic[listenAndTalk.id];
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
            NSInteger index = [tempSelectedIdHomeworkArray indexOfObject:listenAndTalk.id];
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
            
            [self.selectedHomeworkArray addObject:@{@"id":listenAndTalk.id,@"sectionName":listenAndTalk.sectionName,@"content":@[[item  toDictionary]]}];
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
