

//
//  HWReportUnitDetailVC.m
//  TeacherPro
//
//  Created by DCQ on 2018/7/19.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HWReportZXLXUnitDetailVC.h"
#import "MultilayerItem.h"
#import "HWReportZXLXUnitTypeUnitCell.h"
#import "HWReportZXLXSubUnitTypeCell.h"
#import "HWReportDetailHearCell.h"
#import "HWReportDetailSpellingCell.h"
#import "HWReportZXLXTypeDetailCell.h"
#import "HWReportStudentListVC.h"

NSString * const  HWReportZXLXDetailVCUnitTypeUnitCellIdentifier = @"HWReportZXLXDetailVCUnitTypeUnitCellIdentifier";
NSString * const  HWReportZXLXDetailVCSubUnitTypeCellIdentifier = @"HWReportZXLXDetailVCSubUnitTypeCellIdentifier";
NSString * const  HWReportDetailHearCellIdentifier = @"HWReportDetailHearCellIdentifier";
NSString * const  HWReportDetailSpellingCellIdentifier = @"HWReportDetailSpellingCellIdentifier";
NSString * const  HWReportZXLXDetailVCTypeDetailCellIdentifier = @"HWReportZXLXDetailVCTypeDetailCellIdentifier";

@interface HWReportZXLXUnitDetailVC ()
@property(nonatomic, copy) NSString * titleStr;
@property(nonatomic, assign)  HWReportZXLXUnitDetailStyle style;
/** 当前需要展示的数据 */
@property (nonatomic, strong) NSMutableArray<MultilayerItem *> *latestShowItems;
@property (nonatomic, strong) NSMutableArray<MultilayerItem *> *Items;
@property (nonatomic, strong) NSDictionary  *hwReportDetaiModel;
@property(nonatomic, strong) NSNumber * studentCount;
@end

@implementation HWReportZXLXUnitDetailVC
- (instancetype)initWithStyle:(HWReportZXLXUnitDetailStyle )style withDic:( NSDictionary *)items withTitle:(NSString *)titleStr{
    self = [super init];
    if (self) {
        self.style = style;
         self.hwReportDetaiModel = items;
        self.titleStr = titleStr;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    [self setNavigationItemTitle:self.titleStr];
    [self confightTableViewData:self.hwReportDetaiModel];
    [self setupRowCount];
    [self updateTableView];
}


#pragma mark --配置数据 ui
- (void)confightTableViewData:(NSDictionary *)successInfoObj{
    self.hwReportDetaiModel = successInfoObj;
    NSArray * bookArray = successInfoObj[@"bookHomeworks"];
    self.studentCount = successInfoObj[@"studentCount"];
    for (int i = 0 ; i < [bookArray count]; i++) {
        //英语 且是教材
        if ([bookArray[i][@"subject"]  isEqualToString:@"003"] && [bookArray[i][@"bookType"] isEqualToString:@"Book"]) {
            [self  getEnSecondSubs:bookArray[i][@"homeworkTypes"]];
        }
       
    }
    
}

#pragma mark - < 添加可以展示的选项 >

- (void)setupRowCount
{
    // 清空当前所有展示项
    [self.latestShowItems removeAllObjects];
    
    // 重新添加需要展示项, 并设置层级, 初始化0
    [self setupRouCountWithMenuItems:self.Items index:0];
}

/**
 将需要展示的选项添加到latestShowMenuItems中, 此方法使用递归添加所有需要展示的层级到latestShowMenuItems中
 
 @param menuItems 需要添加到latestShowMenuItems中的数据
 @param index 层级, 即当前添加的数据属于第几层
 */
- (void)setupRouCountWithMenuItems:(NSArray<MultilayerItem *> *)menuItems index:(NSInteger)index
{
    for (int i = 0; i < menuItems.count; i++) {
        MultilayerItem *item = menuItems[i];
        // 设置层级
        item.index = index;
        // 将选项添加到数组中
        [self.latestShowItems addObject:item];
        // 判断该选项的是否能展开, 并且已经需要展开
        if (item.isCanUnfold && item.isUnfold) {
            // 当需要展开子集的时候, 添加子集到数组, 并设置子集层级
            [self setupRouCountWithMenuItems:item.subs index:index + 1];
        }
    }
}

#pragma mark - < 懒加载 >


- (NSMutableArray<MultilayerItem *> *)latestShowItems
{
    if (!_latestShowItems) {
        self.latestShowItems = [[NSMutableArray alloc] init];
    }
    return _latestShowItems;
}
- (NSMutableArray<MultilayerItem *> *)Items{
    if (!_Items) {
        _Items = [NSMutableArray array];
    }
    return _Items;
}

// 英语 书本题目类型
- (void)getEnSecondSubs:(NSArray * )homeworkTypes{
 
    for (int i  = 0; i < [homeworkTypes count]; i++) {
      
        NSDictionary *homeworkInfo  = homeworkTypes[i];
        if ([homeworkInfo[@"practiceType"] isEqualToString:@"zxlx"]) {
             [self getEnZXLXThreeSubs:homeworkInfo[@"units"]];
        }
 
    }
    
}




#pragma mark --- 在线练习
// 单元
- (void )getEnZXLXThreeSubs:(NSArray * )homeworkUnits{
 
    for (int i  = 0; i < [homeworkUnits count]; i++) {
     
      NSDictionary *unitInfo  = homeworkUnits[i];
        if (self.style == HWReportZXLXUnitDetailStyle_words) {
             [self getEnZXLXFourWordsSubs:unitInfo[@"words"]];
        }else  if (self.style == HWReportZXLXUnitDetailStyle_listenAndTalk){
              [self getListenAndTalk:unitInfo[@"listenAndTalk"]];
        }
   
    }
 
}

//  单元下的词汇类型
- (void)getEnZXLXFourWordsSubs:(NSArray * )unitsWordsTypes  {
 
    //词汇
    MultilayerItem * wordsItem = [[MultilayerItem alloc]init];
    wordsItem.index = 3;
    wordsItem.isUnfold = YES;
    wordsItem.isCanUnfold = YES;
    wordsItem.subs = [self getEnZXLXFiveWordsUnitSubs:unitsWordsTypes];
    wordsItem.data = @{@"type":@"词汇练习"};
    [self.Items addObject:wordsItem];
    
   
}
//听说
- (void)getListenAndTalk:(NSArray * )unitsWordsTypes{
        
    //听说
    MultilayerItem * listenAndTalkItem = [[MultilayerItem alloc]init];
    listenAndTalkItem.index = 3;
    listenAndTalkItem.isUnfold = YES;
    listenAndTalkItem.isCanUnfold = YES;
    listenAndTalkItem.subs = [self getEnZXLXFiveListenAndTalkUnitSubs:unitsWordsTypes];
    listenAndTalkItem.data = @{@"type":@"听说练习"};
    [self.Items  addObject:listenAndTalkItem];
}
// 词汇下单元
- (NSArray <MultilayerItem *>*)getEnZXLXFiveWordsUnitSubs:(NSArray * )unitsWords{
    NSMutableArray * tempArray = [NSMutableArray array];
    for (NSDictionary *tempDic in unitsWords) {
        //词汇
        MultilayerItem * wordsItem = [[MultilayerItem alloc]init];
        wordsItem.index = 4;
        wordsItem.isUnfold = YES;
        wordsItem.isCanUnfold = YES;
        wordsItem.data = @{@"sectionName":tempDic[@"sectionName"]};
        
        wordsItem.subs = [self getEnZXLXSixWordsSubs:tempDic[@"appTypes"]];
        [tempArray addObject:wordsItem];
    }
    
    return tempArray;
    
}
//词汇练习下的听说类型下分类
- (NSArray <MultilayerItem *>*)getEnZXLXFiveListenAndTalkUnitSubs:(NSArray * )unitsListenAndTalk{
    NSMutableArray * tempArray = [NSMutableArray array];
    for (NSDictionary *tempDic in unitsListenAndTalk) {
        //词汇
        MultilayerItem * listenAndTalkItem = [[MultilayerItem alloc]init];
        listenAndTalkItem.index = 4;
        listenAndTalkItem.isUnfold = YES;
        listenAndTalkItem.isCanUnfold = YES;
        listenAndTalkItem.data = @{@"sectionName":tempDic[@"sectionName"]};
        listenAndTalkItem.subs = [self getEnZXLXSixListenAndTalkSubs:tempDic[@"appTypes"]];
        [tempArray addObject:listenAndTalkItem];
    }
    
    return tempArray;
    
}
//词汇练习下的单词类型下分类
- (NSArray <MultilayerItem *>*)getEnZXLXSixWordsSubs:(NSArray * )unitsWordsTypes{
    NSMutableArray * tempArray = [NSMutableArray array];
    for (NSDictionary *tempDic in unitsWordsTypes) {
        //词汇
        MultilayerItem * listenAndTalkItem = [[MultilayerItem alloc]init];
        listenAndTalkItem.index = 5;
        listenAndTalkItem.isUnfold = YES;
        listenAndTalkItem.isCanUnfold = YES;
        listenAndTalkItem.data = @{@"title":tempDic[@"title"]};
        listenAndTalkItem.subs = [self getEnZXLXSevenWordsSubs:tempDic[@"items"]];
        [tempArray addObject:listenAndTalkItem];
    }
    
 
    return tempArray;
}

//词汇练习下的听说类型下分类
- (NSArray <MultilayerItem *>*)getEnZXLXSixListenAndTalkSubs:(NSArray * )unitsListenAndTalkTypes{
    
    NSMutableArray * tempArray = [NSMutableArray array];
    for (NSDictionary *tempDic in unitsListenAndTalkTypes) {
        //听说
        MultilayerItem * listenAndTalkItem  = [[MultilayerItem alloc]init];
        listenAndTalkItem .index = 5;
        listenAndTalkItem .isUnfold = YES;
        listenAndTalkItem.isCanUnfold = YES;
        listenAndTalkItem.data = @{@"title":tempDic[@"title"]};
        listenAndTalkItem.subs = [self getEnZXLXSevenListenAndTalkSubs:tempDic[@"items"]];
        [tempArray addObject:listenAndTalkItem];
    }
    
  
    return tempArray;
}
// 拼写  意识 分类
- (NSArray <MultilayerItem *>*)getEnZXLXSevenWordsSubs:(NSArray * )wordsTypeTypes{
    NSMutableArray * tempArray = [NSMutableArray array];
    for (NSDictionary *tempDic in wordsTypeTypes) {
        //词汇
        MultilayerItem * wordsItem = [[MultilayerItem alloc]init];
        wordsItem.index = 6;
        wordsItem.isUnfold = NO;
        //        "typeEn" //类型简写
        //        "homeworkTypeId"://类型id
        //        "typeCn"//类型名称
        //        "logo"://类型icon
        //        "hasScoreLevel"//是否有成绩 用于区分是否 听写
        //        "correctRate": //完成比例
        //        "masteLevel"://掌握程度
        //        "finishStudentCount" //完成学生数
        NSMutableDictionary * itemDic = [NSMutableDictionary dictionary];
        [itemDic addEntriesFromDictionary:@{@"typeEn":tempDic[@"typeEn"],
                                            @"homeworkTypeId":tempDic[@"homeworkTypeId"],
                                            @"typeCn":tempDic[@"typeCn"],
                                            @"finishStudentCount":tempDic[@"finishStudentCount"],
                                            @"hasScoreLevel":tempDic[@"hasScoreLevel"]
                                         
                                            }];
        if (tempDic[@"correctRate"]) {
            [itemDic addEntriesFromDictionary:@{ @"correctRate":tempDic[@"correctRate"]}];
        }
        if (tempDic[@"levels"]) {
            [itemDic addEntriesFromDictionary:@{@"levels":tempDic[@"levels"]}];
        }
        if (tempDic[@"logo"]) {
            [itemDic addEntriesFromDictionary:@{@"logo":tempDic[@"logo"]}];
        }
        if (tempDic[@"masteLevel"]) {
            [itemDic addEntriesFromDictionary:@{@"masteLevel":tempDic[@"masteLevel"]}];
        }
        if ( self.studentCount) {
            [itemDic  addEntriesFromDictionary:@{ @"studentCount":self.studentCount}];
        }
        wordsItem.data = itemDic;
        
        [tempArray addObject:wordsItem];
    }
    
    return tempArray;
}

// 听说 分类
- (NSArray <MultilayerItem *>*)getEnZXLXSevenListenAndTalkSubs:(NSArray * )listenAndTalkTypeTypes{
    NSMutableArray * tempArray = [NSMutableArray array];
    for (NSDictionary *tempDic in listenAndTalkTypeTypes) {
        //词汇
        MultilayerItem * wordsItem = [[MultilayerItem alloc]init];
        wordsItem.index = 6;
        wordsItem.isUnfold = NO;
        //        "typeEn" //类型简写
        //        "homeworkTypeId"://类型id
        //        "typeCn"//类型名称
        //        "logo"://类型icon
        //        "hasScoreLevel"//是否有成绩
        //        "levels": //各成绩分组完成集合   键值队{precent 完成比例 ，studentCount 学生数 }
        //
        //        "finishStudentCount" //完成学生数
        wordsItem.data = @{@"typeEn":tempDic[@"typeEn"],
                           @"homeworkTypeId":tempDic[@"homeworkTypeId"],
                           @"typeCn":tempDic[@"typeCn"],
                           @"logo":tempDic[@"logo"],
                           @"levels":tempDic[@"levels"],
                           @"finishStudentCount":tempDic[@"finishStudentCount"],
                           @"hasScoreLevel":tempDic[@"hasScoreLevel"],
                           @"studentCount":self.studentCount
                           };
        
        [tempArray addObject:wordsItem];
    }
    
    
    return tempArray;
}
- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWReportZXLXUnitTypeUnitCell class]) bundle:nil] forCellReuseIdentifier:HWReportZXLXDetailVCUnitTypeUnitCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWReportZXLXSubUnitTypeCell class]) bundle:nil] forCellReuseIdentifier:HWReportZXLXDetailVCSubUnitTypeCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWReportDetailHearCell class]) bundle:nil] forCellReuseIdentifier:HWReportDetailHearCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWReportDetailSpellingCell class]) bundle:nil] forCellReuseIdentifier:HWReportDetailSpellingCellIdentifier];
     [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HWReportZXLXTypeDetailCell class]) bundle:nil] forCellReuseIdentifier:HWReportZXLXDetailVCTypeDetailCellIdentifier];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.latestShowItems.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    MultilayerItem * item = self.latestShowItems[indexPath.row];
    switch (item.index) {
    
        case 0:
        
            break;
        case 1:
            height = 40;
            break;
        case 2:{
            if([item.data isKindOfClass:[NSString class]]){
                height = 50;
            }else{
                height = 30;
                
            }
            
        }
            break;
        case 3:
        {
              if (item.data[@"hasScoreLevel"] &&[item.data[@"hasScoreLevel"] boolValue]) {
                  height = 140;
                  
              }else{
                  height = 110;
              }
            
        }
            break;
        default:
            break;
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = nil;
    MultilayerItem * item = self.latestShowItems[indexPath.row];
    switch (item.index) {
      
        case 0: //第四层 书本下的分类的单元下分类
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellStyleDefault"];
            break;
        case 1://第五层 书本下的分类的单元下分类下的单元
            cell = [self confightHWReportZXLXUnitTypeUnitCellTableView:tableView withIndexPath:indexPath];
            break;
        case 2://第六层 书本下的分类的单元下分类下的单元下分类
          
               cell = [self confightHWReportZXLXSubUnitTypeCellTableView:tableView withIndexPath:indexPath];
            
            break;
        case 3: //第7层 书本下的分类的单元下分类下的单元下分类下的内容
        {
            
            if (item.data[@"hasScoreLevel"] &&[item.data[@"hasScoreLevel"] boolValue]) {
                //听写
                cell = [self confightHWReportZXLXHearReportCellTableView:tableView withIndexPath:indexPath];
                
            }else{
                //词汇
                cell = [self  confightHWZXLXVocabularyCellTableView:tableView withIndexPath:indexPath];
                
            }
            
        }
            break;
        default:
            break;
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableViewCell *)confightHWReportZXLXUnitTypeUnitCellTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    HWReportZXLXUnitTypeUnitCell  * tempCell = [tableView dequeueReusableCellWithIdentifier:HWReportZXLXDetailVCUnitTypeUnitCellIdentifier];
    MultilayerItem * item = self.latestShowItems[indexPath.row];
    [tempCell setupInfo:item.data];
    return tempCell;
}


- (UITableViewCell *)confightHWReportZXLXSubUnitTypeCellTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    HWReportZXLXSubUnitTypeCell  * tempCell = [tableView dequeueReusableCellWithIdentifier:HWReportZXLXDetailVCSubUnitTypeCellIdentifier];
    MultilayerItem * item = self.latestShowItems[indexPath.row];
    [tempCell setupInfo:item.data];
    return tempCell;
}

//听说统计
- (UITableViewCell *)confightHWReportZXLXHearReportCellTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    HWReportDetailHearCell * tempCell = [tableView dequeueReusableCellWithIdentifier:HWReportDetailHearCellIdentifier];
    MultilayerItem * item = self.latestShowItems[indexPath.row];
    [tempCell setupInfo:item.data];
    return tempCell;
}
//词汇 统计
- (UITableViewCell *)confightHWZXLXVocabularyCellTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    HWReportDetailSpellingCell  * tempCell = [tableView dequeueReusableCellWithIdentifier:HWReportDetailSpellingCellIdentifier];
    MultilayerItem * item = self.latestShowItems[indexPath.row];
    [tempCell setupInfo:item.data];
    return tempCell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
