//
//  HomeworkConfirmationViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "HomeworkConfirmationViewController.h"
#import "HomeworkConfirmationHeaderView.h"
#import "HomeworkConfirmationItemCell.h"
#import "HomeworkConfirmationChapterCell.h"
#import "HomeworkConfirmationSectionHeaderView.h"
#import "ProUtils.h"
#import "YYCache.h"
#import "HomeworkConfirmationPreviewView.h"
NSString * const HomeworkConfirmationSectionHeaderViewIdentifier = @"HomeworkConfirmationSectionHeaderViewIdentifier";

NSString * const HomeworkConfirmationItemCellIdentifier = @"HomeworkConfirmationItemCellIdentifier";
NSString * const HomeworkConfirmationChapterCellIdentifier = @"HomeworkConfirmationChapterCellIdentifier";

@interface HomeworkConfirmationViewController ()
@property(nonatomic, strong) NSArray *workDataArray;//元素是一个字典  key id 章节id   sectionName 章节名字  content 章节下的内容是一个数组
@property(nonatomic, strong) NSArray *heardDataArray;//元素是一个字典  key id 章节id   sectionName 章节名字  content 章节下的内容是一个数组
@property(nonatomic, strong) NSMutableArray *confirmationShowDataArray;

@property(nonatomic, copy) NSString * wordSectionTitle;
@property(nonatomic, copy) NSString * heardSectionTitle;
@property(nonatomic, assign) NSInteger  totalTime;
@property(nonatomic, strong) NSDictionary * unityIconDic;//字段对应的图片
@property(nonatomic, assign) NSInteger appCount;//布置的本次作业总题数
@property(nonatomic, copy) NSString * unitId;//单元id
@property(nonatomic, strong)HomeworkConfirmationPreviewView * previewView;
@end

@implementation HomeworkConfirmationViewController
- (instancetype)initWithWorkData:(NSArray *)workDataArray withHeardData:(NSArray *)heardDataArray withUnityID:(NSString *)unitId{
    self = [super init];
    if (self) {
        self.workDataArray = workDataArray;
        self.heardDataArray = heardDataArray;
        self.unitId = unitId;
    }
    return self;
}

- (NSMutableArray *)confirmationShowDataArray{

    if (!_confirmationShowDataArray) {
        _confirmationShowDataArray = [[NSMutableArray alloc]init];
    }
    return _confirmationShowDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"确认布置"];
 
    [self setupBottomView];
    self.wordSectionTitle = @"词汇练习";
    self.heardSectionTitle = @"听说练习";
    self.unityIconDic =  [ProUtils getZXLXUnitIconDic];
    
    [self resetDataView];
    [self setupTableviewHeader];
    [self updateTableView];
    [self.view addSubview:self.previewView];
    [self configTableView];
}
- (void)configTableView{
    self.view.backgroundColor = project_background_gray;
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)resetDataView{

  self.totalTime = 0;
   NSDictionary * wordDic = [self  configDataArray:self.workDataArray withSctionTitle:self.wordSectionTitle];
    
    if (wordDic) {
        [self.confirmationShowDataArray addObject:wordDic];
    }
    NSDictionary * heardDic  = [self configDataArray:self.heardDataArray withSctionTitle:self.heardSectionTitle];
    
    if (heardDic) {
        [self.confirmationShowDataArray addObject:heardDic];
    }
    
}

- (NSDictionary * )configDataArray:(NSArray *)dataArray withSctionTitle:(NSString *)sctionTitle{

    NSDictionary * dataDic = nil;
    //
    NSMutableArray * tempArray = [NSMutableArray array];
    //每块总题数
    NSInteger sectionTotalNumber = 0;
    //每块总单词数
    NSInteger sectionTotalCount = 0;
    //每块总时间
    NSInteger sectionTotalTime = 0;
    NSString *sectionTotalTimeStr = @"";
    
    for (NSDictionary * tempDic in dataArray) {
        NSString *sectionName = tempDic[@"sectionName"];
        NSString *id = tempDic[@"id"];
        [tempArray addObject:@{@"id":id,@"sectionName":sectionName}];
        
        NSArray * tempContentArray = tempDic[@"content"];
        [tempArray addObjectsFromArray:tempContentArray];
        for (NSDictionary * itemDic in tempContentArray) {
           NSInteger  tempDurationTime = [itemDic[@"durationTime"] integerValue] * [itemDic[@"count"] integerValue];
            sectionTotalTime = sectionTotalTime + tempDurationTime;
            sectionTotalCount = sectionTotalCount + [itemDic[@"count"] integerValue];
            sectionTotalNumber ++;
            
        }
        
    }
    
    if (tempArray.count >0) {
        
        if (sectionTotalTime < 60) {
            sectionTotalTimeStr = [NSString stringWithFormat:@"%zd",1];
        }else{
            sectionTotalTimeStr = [NSString stringWithFormat:@"%zd",(int)sectionTotalTime/60];
        }
        NSString *sectionTitleDetail = [NSString stringWithFormat:@"(共%zd个练习 词汇总量%zd 预计约%@分钟)",sectionTotalNumber,sectionTotalCount,sectionTotalTimeStr];
        NSString * sectionStr = [sctionTitle stringByAppendingString:sectionTitleDetail];
        
        
        NSRange  range = NSMakeRange(4, sectionStr.length -4);
        NSAttributedString * sectionAttributedString =  [ ProUtils setAttributedText:sectionStr withColor:UIColorFromRGB(0x434343) withRange:range withFont:fontSize_12];
        
//        UIColor * numberColor =  UIColorFromRGB(0xff617a);
        UIColor * numberColor =  project_main_blue;
        NSRange oneRange = [sectionStr rangeOfString:[NSString stringWithFormat:@"%zd",sectionTotalNumber]];
         NSRange twoRange = [sectionStr rangeOfString:[NSString stringWithFormat:@"%zd",sectionTotalCount]];
        
         NSRange threeRange = [sectionStr rangeOfString: sectionTotalTimeStr ];
        
        NSMutableAttributedString *Attributed  = [[NSMutableAttributedString alloc]initWithAttributedString:sectionAttributedString];
        
        [Attributed addAttribute:NSForegroundColorAttributeName
         
                           value:numberColor
         
                           range:oneRange];
 
        [Attributed addAttribute:NSForegroundColorAttributeName

                           value:numberColor

                           range:twoRange];
        
        [Attributed addAttribute:NSForegroundColorAttributeName
         
                           value:numberColor
         
                           range:threeRange];
        
        
        dataDic = @{@"section":Attributed,@"content":tempArray};
    }
    self.totalTime = self.totalTime + sectionTotalTime;
    
    return  dataDic;
}



- (NSMutableArray * )configSubmitDataArray:(NSArray *)dataArray {
    
    //
    NSMutableArray * tempArray = [NSMutableArray array];
   
    for (NSDictionary * tempDic in dataArray) {
    
        NSString *id = tempDic[@"id"];
        
        NSArray * tempContentArray = tempDic[@"content"];
          NSMutableArray * appTypes = [NSMutableArray array];
        for (NSDictionary * itemDic in tempContentArray) {
            
            [appTypes addObject:itemDic[@"typeEn"]];
            self.appCount++;
        }
       [tempArray addObject:@{@"sectionId":id,@"appType":appTypes}];
    }
    return  tempArray;
}


- (UITableViewStyle)getTableViewStyle{

    return UITableViewStyleGrouped;
}
- (void)setupTableviewHeader{

    HomeworkConfirmationHeaderView * headerView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([HomeworkConfirmationHeaderView class]) owner:nil options:nil].firstObject;
     NSString *timeStr  = @"";
    if (self.totalTime < 60) {
        timeStr = [NSString stringWithFormat:@"%zd分钟",1];
    }else{
        timeStr = [NSString stringWithFormat:@"%zd分钟",(int)self.totalTime/60];
    }
    [headerView setupTotalTimer:timeStr];
    self.tableView.tableHeaderView = headerView;
}

- (void)setupBottomView{
    CGFloat bottomHeight = FITSCALE(50);
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - bottomHeight, self.view.frame.size.width, bottomHeight)];
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    sureBtn.frame = CGRectMake(10, 5, bottomView.frame.size.width - 10*2, bottomHeight-5*2);
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = sureBtn.frame.size.height/2;
    sureBtn.backgroundColor = project_main_blue;
    [sureBtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sureBtn];
    [self.view addSubview:bottomView];
}
- (CGRect)getTableViewFrame{

    CGFloat bottomHeight = FITSCALE(44);
    CGRect frame =  CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - bottomHeight);
    return frame;
}
- (void)registerCell{

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeworkConfirmationItemCell class]) bundle:nil] forCellReuseIdentifier:HomeworkConfirmationItemCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeworkConfirmationChapterCell class]) bundle:nil] forCellReuseIdentifier:HomeworkConfirmationChapterCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeworkConfirmationSectionHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:HomeworkConfirmationSectionHeaderViewIdentifier];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    NSInteger section = 0;
    section = [self.confirmationShowDataArray count];
    
    return section;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSInteger rows =  0;
    NSArray * tempArray = self.confirmationShowDataArray[section][@"content"];
    rows = [tempArray count];
    return rows;
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat  height = 0;
     NSArray * tempArray = self.confirmationShowDataArray[indexPath.section][@"content"];
    NSDictionary * tempDic = tempArray[indexPath.row];
    if (tempDic[@"id"] &&[tempDic[@"id"]  isKindOfClass:[NSString class]]) {
        
        height = FITSCALE(44);
    }else{
        
        height = FITSCALE(60);
    }
    
    return height;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = nil;
    NSArray * tempArray = self.confirmationShowDataArray[indexPath.section][@"content"];
    NSDictionary * tempDic = tempArray[indexPath.row];
    if (tempDic[@"id"] &&[tempDic[@"id"]  isKindOfClass:[NSString class]]) {
        
        HomeworkConfirmationChapterCell * tempCell = [tableView dequeueReusableCellWithIdentifier:HomeworkConfirmationChapterCellIdentifier];
        [tempCell setupChapterName:tempDic[@"sectionName"]];
        cell = tempCell;
    }else{
    
        HomeworkConfirmationItemCell * tempCell = [tableView dequeueReusableCellWithIdentifier:HomeworkConfirmationItemCellIdentifier];
        NSInteger totalDurationTime = 0;
        
        NSInteger tempDurationTime = [tempDic[@"durationTime"] integerValue] * [tempDic[@"count"] integerValue];
        
        if ((int)(tempDurationTime/60) <= 0) {
            totalDurationTime = 1;
        }else{
            totalDurationTime = (int)(tempDurationTime/60);
        }
        NSString * detail = [NSString stringWithFormat:@"预计：约%zd分钟",totalDurationTime];
         [tempCell setupTitle:tempDic[@"typeCn"] withDetail:detail  withIcon: self.unityIconDic[tempDic[@"typeEn"]]];
        tempCell.index = indexPath;
        tempCell.previewBlock = ^(NSIndexPath *index) {
           [self showPreviewIndex:indexPath];
        };
        cell = tempCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- ( UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView * headerView =  nil;
    HomeworkConfirmationSectionHeaderView * tempView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HomeworkConfirmationSectionHeaderViewIdentifier];
    
    NSAttributedString * sectionTitle = self.confirmationShowDataArray[section][@"section"];
    
   
    [tempView setupSectionTitle:sectionTitle];
    headerView = tempView;
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return FITSCALE(40);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.000001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self showPreviewIndex:indexPath];
}
- (void)showPreviewIndex:(NSIndexPath *)indexPath{
    
    NSArray * tempArray = self.confirmationShowDataArray[indexPath.section][@"content"];
    NSDictionary * tempDic = tempArray[indexPath.row];
    NSDictionary *iconDic = @{@"dcbs":@"preview_dcbs.jpg",
                              @"dcgc":@"preview_dcgc.jpg",
                              @"dcgd":@"preview_dcgd.jpg",
                              @"dcpaixu":@"preview_dcpxu.jpg",
                              @"dcpinxie":@"preview_dcpxie.jpg",
                              @"ktsc":@"preview_ktsc.jpg",
                              @"tyxc":@"preview_tyxc.jpg",
                              @"gdxl":@"preview_gdxl.jpg",
                              @"qwgd":@"preview_qwgd.jpg",
                              @"qwld":@"preview_qwld.jpg",
                              @"zztl":@"preview_jztl.jpg",
                              
                              };
    
    if (tempDic[@"typeEn"] ) {
        NSString * imageName =iconDic[tempDic[@"typeEn"]];
        self.previewView.hidden = NO;
        [self.previewView setupImageView:imageName];
    }
}
- (HomeworkConfirmationPreviewView *)previewView{
    if (!_previewView) {
       _previewView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([HomeworkConfirmationPreviewView class]) owner:nil options:nil][0];
        _previewView.hidden = YES;
        [_previewView setFrame:self.view.frame];
    }
    return _previewView;
}
- (void)sureAction:(id)sender{
    
    [self cacheHomework];
 
    NSInteger index = [self.navigationController.viewControllers count] -4;
    
    [self.navigationController popToViewController:self.navigationController.viewControllers[index] animated:YES];
}

- (void)cacheHomework{

    //提交服务器格式
    self.appCount = 0;
    
    NSArray * wordsArray = [self configSubmitDataArray:self.workDataArray];
    
    NSArray * heardArray = [self configSubmitDataArray:self.heardDataArray];
    
    
    NSDictionary * submitDic = @{@"words":wordsArray,@"listenAndTalk":heardArray,@"appCount":@(self.appCount),@"unitId":self.unitId};
    
     NSArray *submitArray = @[submitDic];
    
    
    YYCache *cache = [YYCache cacheWithName:HOMEWORK_CONTENT_PATH];
    cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    [cache setObject:submitArray forKey:GAME_PRACTICE_MEMORY_KEY];
}

@end
