//
//  BookHomeworkViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookHomeworkViewController.h"
#import "BookPreviewModel.h"
#import "BookHomeworkSectionView.h"
#import "BookHomeworkTypeCell.h"
#import "BookHomeworkTitleCell.h"
#import "BookHomeworkTypeUnitViewController.h"
#import "SubBookCartoonPreViewController.h"

#import "SubBookBookPreViewController.h"
#import "ProUtils.h"
#import "YYCache.h"
#import "BookHomeworkChildrenUnitGameViewController.h"
#import "BookHomeworkChildrenUnitTKWLYViewController.h"
#import "BookHomeworkChildrenUnitLDKWViewController.h"
#import "BookHomeworkChildrenUnitDCTXViewController.h"
#import "UIViewController+BackButtonHandler.h"
#import "BookPreviewDetailViewController.h"
#import "HomeworkProblemsViewController.h"
#import "ReleaseAddBookworkCell.h"
#import "ReleaseHomeworkViewController.h"
#import "JFBookPreviewViewController.h"
#import "BookBookPreDetailViewController.h"
#import "CheckDetialTipsView.h"

NSString *const BookHomeworkSectionViewIdentifer = @"BookHomeworkSectionViewIdentifer";
NSString *const BookHomeworkTypeCellIdentifer    = @"BookHomeworkTypeCellIdentifer";
NSString *const BookHomeworkTitleCellIdentifer   = @"BookHomeworkTitleCellIdentifer";
#define bottomViewHeight     65


typedef NS_ENUM(NSInteger, BookHomeworkVCType){
    BookHomeworkVCType_normal       = 0  ,
    BookHomeworkVCType_cartoon           ,//绘本
    BookHomeworkVCType_book              ,//教材
    
    
};
@interface BookHomeworkViewController ()<ReleaseAddBookworkCellDelegate>
@property(nonatomic, copy) NSString * bookId;
@property(nonatomic, copy) NSString * bookType;
@property(nonatomic, strong)   BookPreviewModel *detailModel;
@property(nonatomic, strong)   NSDictionary* practiceTypes ;//教材教辅字段类型
@property(nonatomic, strong)   NSDictionary* cartoonTypes  ;//绘本类型字段
@property(nonatomic, strong)   NSDictionary * unityIconDic;//字段对应的图片
@property(nonatomic, strong)   NSArray * HomewordGamesArray;//游戏练习
@property(nonatomic, strong)   NSArray * HomewordTKWLArray;//听课文录音
@property(nonatomic, strong)   NSArray * HomewordLDKWArray;//朗读课文
@property(nonatomic, strong)   NSArray * HomewordDCTXArray;//单词听写
@property(nonatomic, strong)   NSArray * HomewordKhlxArray;//课后习题
@property(nonatomic, strong)   NSArray *HomewordYwddArray ;//语文点读
@property(nonatomic, strong)   NSMutableArray * selectedIndexArray;//
@property(nonatomic, strong)   NSMutableArray * bookPracticeTypes;
@property(nonatomic, assign)   BookHomeworkVCType bookTypes;

@property(strong, nonatomic) CheckDetialTipsView *checkTipView;
@end

@implementation BookHomeworkViewController
- (instancetype)initWithBookId:(NSString *)bookId withBookType:(NSString *)bookType withClear:(BOOL)isClear{
    self = [super init];
    if (self) {
        self.bookId = bookId;
        self.bookType = bookType;
        if (isClear) {
            YYCache *cache = [YYCache cacheWithName:HOMEWORK_CONTENT_PATH];
            [cache removeAllObjects];
        }
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"书本作业"];
    [self clearHomeworkCache];
    [self requestQueryBook];
    
    
    self.practiceTypes = [ProUtils getHomworkDetailPracticeTypes];
    
    self.cartoonTypes = [ProUtils getHomworkDetailCartoonTypes];
    
    self.unityIconDic = [ProUtils getHomworkDetailUnitIconDic];
    
    
    [self configTableView];
    
    [self.view addSubview:self.bottomView];
}
- (void)configTableView{
    
    self.tableView.backgroundColor = project_background_gray;
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.view.backgroundColor = project_background_gray;
}
- (NSMutableArray *)selectedIndexArray{
    if (!_selectedIndexArray) {
        _selectedIndexArray = [[NSMutableArray alloc]init];
    }
    return _selectedIndexArray;
}

- (void)setBackContent:(NSDictionary *)backContent{
    _backContent = backContent;
//    NSDictionary *tempDic = [ProUtils dictionaryWithJsonString:_backContent];
    [_bottomView.addButton setTitle:@"确认修改" forState:UIControlStateNormal];
    
    if (self.detailModel.book.practiceTypes.count&&[_backContent[@"cartoonHomework"] count]) {
        for (int i=0; i<self.detailModel.book.practiceTypes.count; i++) {
            PracticeTypeModel *tempModel =  self.detailModel.book.practiceTypes[i];
//            tempModel.practiceType;
//            self.selectedIndexArray;
            for (NSString *strpracticeType in _backContent[@"cartoonHomework"]) {
                if ([strpracticeType isEqualToString:tempModel.practiceType]) {
                    [self.selectedIndexArray addObject:[NSIndexPath indexPathForRow:i inSection:1]];
                }
            }
        }
    }
    
}
- (NSMutableArray *)bookPracticeTypes{
    
    if (!_bookPracticeTypes) {
        _bookPracticeTypes = [[NSMutableArray alloc]init];
    }
    return _bookPracticeTypes;
}
- (UIView *)bottomView{
    if (!_bottomView) {
        
        _bottomView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ReleaseAddBookworkCell class]) owner:nil options:nil].firstObject;
        _bottomView.frame = CGRectMake(0, self.view.frame.size.height -bottomViewHeight,self.view.frame.size.width, bottomViewHeight);
        if (kScreenWidth == 375&&kScreenHeight>667){
            _bottomView.frame = CGRectMake(0, self.view.frame.size.height -bottomViewHeight-18,self.view.frame.size.width, bottomViewHeight);
        }
        [_bottomView.addButton addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [_bottomView.addButton setTitle:@"布置作业" forState:UIControlStateNormal];
        _bottomView.delegate = self;
        
    }
    return _bottomView;
}

- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkTypeCell class]) bundle:nil] forCellReuseIdentifier:BookHomeworkTypeCellIdentifer];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkTitleCell class]) bundle:nil] forCellReuseIdentifier:BookHomeworkTitleCellIdentifer];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkSectionView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:BookHomeworkSectionViewIdentifer];

//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkAssistantsTitleCell class]) bundle:nil] forCellReuseIdentifier:BookHomeworkAssistantsChildrenTitleCellIdentifer];
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkAssistantsChildrenTitleCell class]) bundle:nil] forCellReuseIdentifier:BookHomeworkAssistantsChildrenTitleCellIdentifer];
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkAssistantsSectionView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:BookHomeworkAssistantsSectionViewIdentifer];
}

#pragma mark ---
- (void)requestQueryBook{
    
    NSDictionary *parameterDic =nil;
    if (self.bookId && self.bookType) {
        parameterDic  = @{@"bookId":self.bookId,@"getUnit":@"true",@"bookType":self.bookType,@"getWordCount":@"true"};
    }
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryBookById] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryBookById];
}

- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_QueryBookById) {
            strongSelf.detailModel = [[BookPreviewModel alloc]initWithDictionary:successInfoObj error:nil];
            dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            //子线程
            dispatch_async(globalQueue,^{
                
                [strongSelf setupData];
                
                dispatch_queue_t mainQueue = dispatch_get_main_queue();
                //异步返回主线程，根据获取的数据，更新UI
                dispatch_async(mainQueue, ^{
                    if (strongSelf.backContent) {
                        strongSelf.backContent = _backContent;
                    }
                      [strongSelf updateTableView];
                  
                });
                
            });
            
          
        }
        
    }];
}

- (void)setupData{
    
    if ([self.detailModel.book.bookType isEqualToString:BookTypeCartoon]) {
        self.bookTypes = BookHomeworkVCType_cartoon;
//        for (int i = 0;i< [self.detailModel.book.practiceTypes count] ;i++) {
//            [self.selectedIndexArray addObject:[NSIndexPath indexPathForRow:i inSection:1]];
//        }
    }else if ([self.detailModel.book.bookType isEqualToString:@"Book"]){
        self.bookTypes = BookHomeworkVCType_book;
        NSMutableArray * onlineArray = [NSMutableArray array];
        NSMutableArray * uonlineArray = [NSMutableArray array];
        
        for (PracticeTypeModel *model in self.detailModel.book.practiceTypes) {
            if ([model.isOnline isEqualToString:@"true"]) {
                 [onlineArray addObject:model];
            }else if ([model.isOnline isEqualToString:@"false"]){
                [uonlineArray addObject:model];
            }
        }
        NSMutableDictionary * onlineDic = nil;
        if ([onlineArray count]  >0) {
           onlineDic = [NSMutableDictionary dictionary];
            [onlineDic setObject:onlineArray forKey:@"conten"];
            [onlineDic setObject:@"在线练习" forKey:@"title"];
            [onlineDic setObject:@"（学生端自动批改，记录成绩）" forKey:@"detail"];
        }
        NSMutableDictionary * uonlineDic = nil;
        if ([uonlineArray count]  >0) {
             uonlineDic = [NSMutableDictionary dictionary];
            [uonlineDic setObject:uonlineArray forKey:@"conten"];
            [uonlineDic setObject:@"离线练习" forKey:@"title"];
            [uonlineDic setObject:@"（家长监督完成，不记录成绩）" forKey:@"detail"];
        }
        if (onlineDic) {
            [self.bookPracticeTypes addObject:onlineDic];
           
        }
        if (uonlineDic) {
             [self.bookPracticeTypes addObject:uonlineDic];
        }
    }else{
    }
}

#pragma mark --- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    NSInteger  section =  0;
    
        switch (self.bookTypes) {
            case BookHomeworkVCType_normal:
                section = 0;
                break;
            case BookHomeworkVCType_book:
                section = 1 + [self.bookPracticeTypes count];
                break;
            case BookHomeworkVCType_cartoon:
                section = 2;
                break;
            default:
                break;
        }
    
    return section;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger row = 0;
    if (section == 0) {
        row = 1;
    }else{
        switch (self.bookTypes) {
            case BookHomeworkVCType_normal:
                row = 0;
                break;
            case BookHomeworkVCType_book:{
                NSArray * types = self.bookPracticeTypes[section-1][@"conten"];
                row = [types count];
                
            }
                break;
            case BookHomeworkVCType_cartoon:
                row = [self.detailModel.book.practiceTypes count];
                break;
            default:
                break;
        }
    }
    return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height =  0;
    if (indexPath.section ==0) {
        height =  140;
    }else{
        height = 48;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0;
    if (section == 0){
        height = 1;
    }else {
        height = 40;
    }
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    CGFloat height = 0.01;
    return height;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
     UIView * footerView = [UIView new];
    footerView.backgroundColor = project_background_gray;
    return footerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [UIView new];
      headerView.backgroundColor = [UIColor whiteColor];
    if (section > 0) {
        
            BookHomeworkSectionView * tempHeader  = [tableView dequeueReusableHeaderFooterViewWithIdentifier:BookHomeworkSectionViewIdentifer];
            [self confightBookHomeworkSectionView:tempHeader withSection:section];
            tempHeader.clearBlock = ^{
                
                [self clearHomeworkSection:section];
            };
        tempHeader.titleLabel.text = @"";
        if (section == 1 ) {
            tempHeader.titleLabel.text = @"在线练习（学生端自动批改，记录成绩）";
        }else if(section == 2){
            tempHeader.titleLabel.text = @"离线练习（家长监督完成，不记录成绩）";
        }
        
            headerView = tempHeader;
//        }
    }
    return headerView;
}

- (void)confightBookHomeworkSectionView: (BookHomeworkSectionView * )tempHeader withSection :(NSInteger)section{
    
    BOOL isEdit = NO;
    
    NSInteger index =  section - 1;
    
    [tempHeader setupEditState:isEdit];
}
- (void)clearHomeworkSection:(NSInteger )section{
    
    YYCache *cache = [YYCache cacheWithName:HOMEWORK_CONTENT_PATH];
    NSArray *contents = self.bookPracticeTypes[section -1][@"conten"];
    NSMutableArray *practiceTypes = [NSMutableArray array];
    for ( PracticeTypeModel * model in contents) {
        [practiceTypes addObject: model.practiceType];
    }
    
    if ([practiceTypes containsObject:@"zxlx"] &&self.HomewordGamesArray.count >0) {
        self.HomewordGamesArray = nil;
        [cache removeObjectForKey:GAME_PRACTICE_MEMORY_KEY];

    }
    
    if ([practiceTypes containsObject:@"ldkw"] &&self.HomewordLDKWArray.count >0) {
        self.HomewordLDKWArray = nil;
        [cache removeObjectForKey:LDKW_PRACTICE_MEMORY_KEY];
    }
    if ([practiceTypes containsObject:@"tkwly"] &&self.HomewordTKWLArray.count >0) {
        self.HomewordTKWLArray = nil;
        [cache removeObjectForKey:TKWLY_PRACTICE_MEMORY_KEY];
    }
    if ([practiceTypes containsObject:@"dctx"] &&self.HomewordDCTXArray.count >0) {
        self.HomewordDCTXArray = nil;
        [cache removeObjectForKey:DCTX_PRACTICE_MEMORY_KEY];
    }
    if ([practiceTypes containsObject:@"ywdd"] &&self.HomewordYwddArray.count >0) {
        self.HomewordYwddArray = nil;
        [cache removeObjectForKey:YWDD_PRACTICE_MEMORY_KEY];
    }
    if ([practiceTypes containsObject:@"khlx"] &&self.HomewordKhlxArray.count >0) {
        self.HomewordKhlxArray = nil;
        [cache removeObjectForKey:KHLX_PRACTICE_MEMORY_KEY];
    }
    [self updateTableView];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =  nil;
    if (indexPath.section == 0) {
        BookHomeworkTitleCell * tempCell = [tableView dequeueReusableCellWithIdentifier:BookHomeworkTitleCellIdentifer];
        [tempCell  setupPreviewDetailInfo:self.detailModel.book];
        tempCell.changeBookBlock = ^{
 
            [self gotoBookPreviewDetailVC];
        };
        cell = tempCell;
    }else {

        BookHomeworkTypeCell * tempCell = [tableView dequeueReusableCellWithIdentifier:BookHomeworkTypeCellIdentifer];
        [self confightCell:tempCell withIndexPath:indexPath];
        cell = tempCell;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)confightCell:(BookHomeworkTypeCell *)tempCell withIndexPath:(NSIndexPath *)indexPath{
    BOOL  isHomework = NO;
    //书本
    if (self.bookTypes == BookHomeworkVCType_book) {
        
        NSArray * types = self.bookPracticeTypes[indexPath.section-1][@"conten"];
        PracticeTypeModel * model = types[indexPath.row];
        if ([model.practiceType isEqualToString:@"zxlx"]) {
            //游戏练习
            if ( self.HomewordGamesArray && self.HomewordGamesArray.count  >0) {
                isHomework = YES;
            }
        }else  if ([model.practiceType isEqualToString:@"ldkw"]){
            //朗读课文
            if ( self.HomewordLDKWArray && self.HomewordLDKWArray.count  >0) {
                isHomework = YES;
            }
            
        }else  if ([model.practiceType isEqualToString:@"tkwly"]){
            //听课文录音
            if ( self.HomewordTKWLArray && self.HomewordTKWLArray.count  >0) {
                isHomework = YES;
            }
            
        }else  if ([model.practiceType isEqualToString:@"dctx"]){
            //单词听写
            if ( self.HomewordDCTXArray && self.HomewordDCTXArray.count  >0) {
                isHomework = YES;
            }
        }else  if ([model.practiceType isEqualToString:@"ywdd"]){
            //语文点读
            if ( self.HomewordYwddArray && self.HomewordYwddArray.count  >0) {
                isHomework = YES;
            }
        }else  if ([model.practiceType isEqualToString:@"khlx"]){
            //课后习题
            if ( self.HomewordKhlxArray && self.HomewordKhlxArray.count  >0) {
                isHomework = YES;
            }
        }
        
       
       
        [tempCell setupBookTitle:model.practiceTypeDes withIsHomework:isHomework withImgName:self.unityIconDic[model.practiceType]];
        tempCell.indexPath = indexPath;
        tempCell.rightButtonBlock = ^(NSIndexPath *indexPath,BookHomeworkType type) {
            [self gotoTypeVCIndex:indexPath withType:type];
        };
        
    }
    //绘本
    else if(self.bookTypes == BookHomeworkVCType_cartoon){
        
        PracticeTypeModel * model = self.detailModel.book.practiceTypes[indexPath.row];
        BOOL  isSelected = YES;
        if ([self.selectedIndexArray containsObject:indexPath]) {
            isSelected = YES;
        }else{
            isSelected = NO;
        }
        [tempCell setupCartoonTitle:model.practiceTypeDes withImgName:self.unityIconDic[model.practiceType] withState:isSelected];
        
    }
}
- (void)gotoBookPreviewDetailVC{
    
    NSString * bookId = self.bookId;
    BOOL existsState = YES;
    NSString * bookType =  self.bookType;
    BookPreviewDetailViewController * detail;
    if ([bookType isEqualToString:BookTypeBookJF]) {
        detail = [[JFBookPreviewViewController alloc]initWithBookId:bookId withExistsBookcase:existsState];
    }else if([bookType isEqualToString:BookTypeCartoon]){
        detail = [[SubBookCartoonPreViewController alloc]init];
        detail.bookId = bookId;
        detail.detailModel = self.detailModel;
    }else if([bookType isEqualToString:BookTypeBook]){
        detail = [[SubBookBookPreViewController alloc]initWithBookId:bookId withExistsBookcase:existsState];
    }
    [self pushViewController:detail];
}


- (void)gotoTypeVCIndex:(NSIndexPath *)indexPath withType:(BookHomeworkType )type{
    
    BOOL  changeState = NO;
    //修改选择的作业
    if (type == BookHomeworkType_change) {
        changeState = YES;
    }
    //新布置作业
    else if (type == BookHomeworkType_setup){
        changeState = NO;
    }
    [self gotoTypeUnitVCindex:indexPath withChangeState:changeState];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [self gotoBookPreviewDetailVC];
    }
    else if (indexPath.section >0) {
        //教材
        if ( self.bookTypes == BookHomeworkVCType_book  ) {
            BOOL  changeState = NO;
            
            [self gotoTypeUnitVCindex:indexPath withChangeState:changeState];
        }
        //绘本
        else if (self.bookTypes == BookHomeworkVCType_cartoon  )
        {
            if ([self.selectedIndexArray containsObject:indexPath]) {
                [self.selectedIndexArray removeObject:indexPath];
            }else{
                
                [self.selectedIndexArray addObject:indexPath];
            }
            
            [self updateTableView];
        }
 
        
    }
   
}



- (void)gotoTypeUnitVCindex:(NSIndexPath *)index withChangeState:(BOOL )changeState{
    
    BookPreviewDetailModel * model = self.detailModel.book;
    BookUnitModel * unitModel = model.bookUnits.firstObject;
    NSArray * cacheData = nil;
    
    
    NSArray * types = self.bookPracticeTypes[index.section-1][@"conten"];
    PracticeTypeModel * typeModel = types[index.row];
    if ([typeModel.practiceType isEqualToString:@"zxlx"]) {
        //游戏练习
        if ( self.HomewordGamesArray && self.HomewordGamesArray.count  >0) {
           cacheData = self.HomewordGamesArray;
        }
        
    }else  if ([typeModel.practiceType isEqualToString:@"ldkw"]){
        //朗读课文
        if ( self.HomewordLDKWArray && self.HomewordLDKWArray.count  >0) {
             cacheData = self.HomewordLDKWArray;
        }
        
    }else  if ([typeModel.practiceType isEqualToString:@"tkwly"]){
        //听课文录音
        if ( self.HomewordTKWLArray && self.HomewordTKWLArray.count  >0) {
          cacheData = self.HomewordTKWLArray;
        }
        
    }else  if ([typeModel.practiceType isEqualToString:@"dctx"]){
        //单词听写
        if ( self.HomewordDCTXArray && self.HomewordDCTXArray.count  >0) {
             cacheData = self.HomewordDCTXArray;
        }
        
    }
    else  if ([typeModel.practiceType isEqualToString:@"ywdd"]){
        //语文点读
        if ( self.HomewordYwddArray && self.HomewordYwddArray.count  >0) {
            cacheData = self.HomewordYwddArray;
        }
        
    }else  if ([typeModel.practiceType isEqualToString:@"khlx"]){
        //课后练习
        if ( self.HomewordKhlxArray && self.HomewordKhlxArray.count  >0) {
            cacheData = self.HomewordKhlxArray;
        }
        
    }
    
    BOOL isChildren = NO;
    if (unitModel.children) {
        isChildren = YES;
    }
    [self gotoVCDetailType:typeModel withModel:model  withCacheData:cacheData withIsChildren:isChildren];
}

- (void)gotoVCDetailType:(PracticeTypeModel *)typeModel withModel:(BookPreviewDetailModel *)model withCacheData:(NSArray *)cacheData withIsChildren:(BOOL)isChildren {
    
    //是否有章节
    if (!isChildren) {
        //无章节 只有单元
        
        if ([typeModel.practiceType isEqualToString:@"ywdd"]){
            //语文点读
            
            BookHomeworkTypeUnitViewController * typeUnitVC = [[BookHomeworkTypeUnitViewController alloc]initWithBookDetail:model withTitle:typeModel withCacheData:cacheData];
            typeUnitVC.bookId = self.bookId;
            typeUnitVC.bookName = model.bookTypeName;
            [self pushViewController:typeUnitVC];
            
        }else if ([typeModel.practiceType isEqualToString:@"khlx"]){
            //课后习题
            HomeworkProblemsViewController * homeworkProblemsVC = [[HomeworkProblemsViewController alloc]initWithBookDetail:model withTitle:typeModel withCacheData:cacheData];
            [self pushViewController:homeworkProblemsVC];
        }else{
            //无章节 只有单元
            BookHomeworkTypeUnitViewController * typeUnitVC = [[BookHomeworkTypeUnitViewController alloc]initWithBookDetail:model withTitle:typeModel withCacheData:cacheData];
            [self pushViewController:typeUnitVC];
            
        }
    }else{
        //有章节 有单元
        if([typeModel.practiceType isEqualToString:@"zxlx"]){
            BookHomeworkChildrenUnitGameViewController * gameVC = [[BookHomeworkChildrenUnitGameViewController alloc]initWithBookDetail:model withTitle:typeModel withCacheData:cacheData];
            [self pushViewController:gameVC];
        }
        else if([typeModel.practiceType isEqualToString:@"ywdd"]){
            //语文点读
            BookHomeworkChildrenUnitGameViewController * gameVC = [[BookHomeworkChildrenUnitGameViewController alloc]initWithBookDetail:model withTitle:typeModel withCacheData:cacheData];
            gameVC.bookId = self.bookId;
            gameVC.bookName = model.bookTypeName;
            [self pushViewController:gameVC];
        } else if ([typeModel.practiceType isEqualToString:@"tkwly"]){
            
            BookHomeworkChildrenUnitTKWLYViewController * tkwlyVC = [[BookHomeworkChildrenUnitTKWLYViewController alloc]initWithBookDetail:model withTitle:typeModel withCacheData:cacheData];
            [self pushViewController:tkwlyVC];
            
        }else if ([typeModel.practiceType isEqualToString:@"ldkw"]){
            BookHomeworkChildrenUnitLDKWViewController *ldkwVC = [[BookHomeworkChildrenUnitLDKWViewController alloc]initWithBookDetail:model withTitle:typeModel withCacheData:cacheData];
            [self pushViewController:ldkwVC];
        }else if ([typeModel.practiceType isEqualToString:@"dctx"]){
            
            BookHomeworkChildrenUnitDCTXViewController * dctxVC =  [[BookHomeworkChildrenUnitDCTXViewController alloc]initWithBookDetail:model withTitle:typeModel withCacheData:cacheData];
            [self pushViewController:dctxVC];
        } else if ([typeModel.practiceType isEqualToString:@"khlx"]){
            //课后习题
            HomeworkProblemsViewController * homeworkProblemsVC = [[HomeworkProblemsViewController alloc]initWithBookDetail:model withTitle:typeModel withCacheData:cacheData];
            [self pushViewController:homeworkProblemsVC];
        }
        
    }
}

//清除 作业缓存
- (void)clearHomeworkCache{
    
//    YYCache *cache = [YYCache cacheWithName:HOMEWORK_CONTENT_PATH];
//    [cache removeAllObjects];
    self.HomewordGamesArray =  nil;
    self.HomewordTKWLArray = nil;
    self.HomewordLDKWArray = nil;
    self.HomewordDCTXArray = nil;
    [self.selectedIndexArray  removeAllObjects];
    [super updateTableView];
}
//读取缓存
- (void)getHomeworkCache{
    
    YYCache *cache = [YYCache cacheWithName:HOMEWORK_CONTENT_PATH];
    
    cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    id gamesObject = [cache objectForKey:GAME_PRACTICE_MEMORY_KEY];
    self.HomewordGamesArray = gamesObject;
    
    id tkwlyObject = [cache objectForKey:TKWLY_PRACTICE_MEMORY_KEY];
    
    self.HomewordTKWLArray = tkwlyObject;
    
    id ldkwObject = [cache objectForKey:LDKW_PRACTICE_MEMORY_KEY];
    
    self.HomewordLDKWArray = ldkwObject;
    
    id dctxObject = [cache objectForKey:DCTX_PRACTICE_MEMORY_KEY];
    
    self.HomewordDCTXArray = dctxObject;
    
    id khlxObject = [cache objectForKey:KHLX_PRACTICE_MEMORY_KEY];
    self.HomewordKhlxArray = khlxObject;
    
    id ywddObject = [cache objectForKey:YWDD_PRACTICE_MEMORY_KEY];
    self.HomewordYwddArray = ywddObject;
    [super updateTableView];
}
//确定布置作业
- (void)sureAction:(id)sender{
    
    NSString * content = @"";
    
    if( [self.detailModel.book.bookType isEqualToString:@"Book"]){
        if (!self.HomewordLDKWArray && !self.HomewordDCTXArray && !self.HomewordTKWLArray && !self.HomewordGamesArray && !self.HomewordYwddArray && !self.HomewordKhlxArray) {
      
            [SVProgressHelper dismissWithMsg:@"请选择需要布置的作业"];
            return  ;
        }
        content = [self getHomeworkBook];
    }
    if ([self.detailModel.book.bookType isEqualToString:BookTypeCartoon]) {
        if (self.selectedIndexArray.count == 0) {
            [SVProgressHelper dismissWithMsg:@"请选择需要布置的作业"];
            return ;
        }
        content = [self getHomeworkCartoon];
    }
    
    
    NSDictionary * userInfo = @{@"content":content};
    
   
//    [[NSNotificationCenter defaultCenter] postNotificationName:BOOK_HOMEWORK_ADD_NEW object:nil userInfo:userInfo];
//    [self clearHomeworkCache];
//    NSInteger index = [self.navigationController.viewControllers count] -3;
//    UIViewController * vc = self.navigationController.viewControllers[index];
    
//    if () {
//
//    }
//    [self.navigationController popToViewController: animated:YES];
    
   
    BOOL popReleaseHomework = NO;
    for(UIViewController*temp in self.navigationController.viewControllers) {
        
        if([temp isKindOfClass:[ReleaseHomeworkViewController class]]){
            popReleaseHomework = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:BOOK_HOMEWORK_ADD_NEW object:nil userInfo:userInfo];
            [self clearHomeworkCache];
            [self.navigationController popToViewController:temp animated:YES];
       }
        
    }
    if (!popReleaseHomework) {
        [self  gotoDecorateHomework:userInfo];
    }
   
}
- (NSString *)getHomeworkCartoon{
    
    NSDictionary * contentDic = [self getCartoonContentData];
    
    NSString * content = [ProUtils dictionaryToJson:contentDic];
    return  content;
    
}
- (NSString *)getHomeworkBook{
    
    
    NSDictionary * contentDic = [self getBookContentData];
    
    
    NSString * content = [ProUtils dictionaryToJson:@{@"bookId":contentDic[@"bookId"]}];

    content = [content stringByAppendingString:[NSString stringWithFormat:@"%@",[ProUtils dictionaryToJson:@{@"zxlx":contentDic[@"zxlx"]}]]];
    content = [content stringByAppendingString:[NSString stringWithFormat:@"%@",[ProUtils dictionaryToJson:@{@"tkwly":contentDic[@"tkwly"]}]]];
 
    
    content = [content stringByAppendingString:[NSString stringWithFormat:@"%@",[ProUtils dictionaryToJson:@{@"ldkw":contentDic[@"ldkw"]}]]];
 
    
    content = [content stringByAppendingString:[NSString stringWithFormat:@"%@",[ProUtils dictionaryToJson:@{@"dctx":contentDic[@"dctx"]}]]];
    NSDictionary * khlxDic = @{@"khlx":contentDic[@"khlx"]};
    NSString *khlxstr = [ProUtils dictionaryToJson:khlxDic];
   content =  [content stringByAppendingString:[NSString stringWithFormat:@"%@",khlxstr]];
    
   content =  [content stringByAppendingString:[NSString stringWithFormat:@"%@",[ProUtils dictionaryToJson:@{@"ywdd":contentDic[@"ywdd"]}]]];
  
    content = [content stringByAppendingString:[NSString stringWithFormat:@"%@",[ProUtils dictionaryToJson:@{@"bookImg":contentDic[@"bookImg"]}]]];
 
    
    content = [content stringByAppendingString:[NSString stringWithFormat:@"%@",[ProUtils dictionaryToJson:@{@"name":contentDic[@"name"]}]]];
 
    
    
    content = [content stringByAppendingString:[NSString stringWithFormat:@"%@",[ProUtils dictionaryToJson:@{@"subjectName":contentDic[@"subjectName"]}]]];
  
    content = [content stringByAppendingString:[NSString stringWithFormat:@"%@",[ProUtils dictionaryToJson:@{@"bookTypeName":contentDic[@"bookTypeName"]}]]];
  
    content = [content stringByAppendingString:[NSString stringWithFormat:@"%@",[ProUtils dictionaryToJson:@{@"bookType":contentDic[@"bookType"]}]]];
 
    content = [content stringByAppendingString:[NSString stringWithFormat:@"%@",[ProUtils dictionaryToJson:@{@"workTotal":contentDic[@"workTotal"]}]]];
    content = [content stringByReplacingOccurrencesOfString:@"}{" withString:@","];
  
//    NSString * content = [ProUtils dictionaryToJson:contentDic];
    return  content;
}


- (NSDictionary *)getCartoonContentData{
    
    NSMutableArray * cartoonHomework = [NSMutableArray array];
    NSArray *cartoonArray = @[@"chxx", @"yyyd",@"hbxt",@"hbpy"];
    for (NSIndexPath *index in self.selectedIndexArray) {
        [cartoonHomework addObject: cartoonArray[index.row]];
    }
    
    NSDictionary *contentDic = @{@"bookId":self.bookId,@"cartoonHomework":cartoonHomework,@"bookImg":self.detailModel.book.coverImage,@"name":self.detailModel.book.name,@"subjectName":self.detailModel.book.subjectName,@"bookTypeName":self.detailModel.book.bookTypeName,@"bookType":self.detailModel.book.bookType,@"workTotal":@([self.selectedIndexArray count])};
    return contentDic;
}

- (NSDictionary *)getBookContentData{
    
    NSArray * submitZxlxArray = @[];
    NSArray * submitDctxArray = @[];
    NSArray * submitLdkwArray = @[];
    NSArray * submitTkwlyArray = @[];
    NSArray * submitKhlxArray = @[];
    NSArray * submitYwddArray = @[];
    NSInteger appCount  = 0;
    
    if (self.HomewordGamesArray.count >0) {
        submitZxlxArray= @[self.HomewordGamesArray.firstObject];
        appCount =  [self.HomewordGamesArray.firstObject[@"appCount"] integerValue];
        
    }
    if (self.HomewordDCTXArray.count >0) {
        
        submitDctxArray = @[ self.HomewordDCTXArray.firstObject];
        appCount ++;
    }
    if (self.HomewordLDKWArray.count > 0) {
        submitLdkwArray = @[self.HomewordLDKWArray.firstObject];
        appCount++;
    }
    if (self.HomewordTKWLArray.count >0) {
        submitTkwlyArray = @[self.HomewordTKWLArray.firstObject];
        appCount++;
    }
    if (self.HomewordKhlxArray.count > 0) {
        submitKhlxArray = self.HomewordKhlxArray.firstObject;
        appCount = [self.HomewordKhlxArray[1] integerValue];
    }
    if (self.HomewordYwddArray.count > 0) {
        submitYwddArray =  @[self.HomewordYwddArray.firstObject];
         appCount = [self.HomewordYwddArray[1] integerValue];
    }
    
//    NSDictionary *contentDic = @{@"bookId":self.bookId,@"zxlx":submitZxlxArray,@"dctx":submitDctxArray,@"ldkw":submitLdkwArray,@"tkwly":submitTkwlyArray,@"bookImg":self.detailModel.book.coverImage,@"name":self.detailModel.book.name,@"subjectName":self.detailModel.book.subjectName,@"bookTypeName":self.detailModel.book.bookTypeName,@"bookType":self.detailModel.book.bookType,@"workTotal":@(appCount)};
    NSMutableDictionary * contentDic = [NSMutableDictionary dictionary];
    [contentDic addEntriesFromDictionary:@{@"bookId":self.bookId}];
     [contentDic addEntriesFromDictionary:@{@"zxlx":submitZxlxArray}];
     [contentDic addEntriesFromDictionary:@{@"dctx":submitDctxArray}];
     [contentDic addEntriesFromDictionary:@{@"ldkw":submitLdkwArray}];
     [contentDic addEntriesFromDictionary:@{@"tkwly":submitTkwlyArray}];
     [contentDic addEntriesFromDictionary:@{@"khlx":submitKhlxArray}];
     [contentDic addEntriesFromDictionary:@{@"ywdd":submitYwddArray}];
     [contentDic addEntriesFromDictionary:@{@"bookImg":self.detailModel.book.coverImage}];
     [contentDic addEntriesFromDictionary:@{@"name":self.detailModel.book.name}];
     [contentDic addEntriesFromDictionary:@{@"subjectName":self.detailModel.book.subjectName}];
     [contentDic addEntriesFromDictionary:@{@"bookTypeName":self.detailModel.book.bookTypeName}];
     [contentDic addEntriesFromDictionary:@{@"bookType":self.detailModel.book.bookType}];
     [contentDic addEntriesFromDictionary:@{@"workTotal":@(appCount)}];
 
    
    return  contentDic;
}

- (CheckDetialTipsView *)checkTipView {
    if (!_checkTipView) {
        
        _checkTipView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CheckDetialTipsView class]) owner:nil options:nil].firstObject;
        _checkTipView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        _checkTipView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }
    return _checkTipView;
}
- (void)checkTipViewSure{
    
    if (self.backContent) {
        [self sureAction:nil];
    }else{
        [self clearHomeworkCache];
        [super backViewController];
    }
    [self.checkTipView removeFromSuperview];
}
- (void)backViewController{
    
    if ([self hasCache] || self.selectedIndexArray.count) {
        NSString *tipStr = @"您还未布置作业，是否返回 上一页面？";
        if (self.backContent) {
            tipStr = @"是否确认修改？";
        }
        UIWindow *firstWindow = [UIApplication.sharedApplication.windows firstObject];
        [firstWindow addSubview: self.checkTipView];
        self.checkTipView.titleLabel.text = tipStr;
        [self.checkTipView.querenButton addTarget:self action:@selector(checkTipViewSure) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
       [super backViewController];
    }
}

- (BOOL)hasCache{
    
    BOOL isCache = NO;
    if( self.HomewordDCTXArray.count > 0 || self.HomewordLDKWArray.count >0 ||self.HomewordTKWLArray.count >0 ||self.HomewordGamesArray.count > 0 ){
    
        isCache = YES;
    }
    return isCache;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self getHomeworkCache];
    
}
/**
 * 协议中的方法，获取返回按钮的点击事件
 */
- (BOOL)navigationShouldPopOnBackButton
{
    return NO;
    
}

- (void)gotoDecorateHomework:(NSDictionary *)userInfo{
    
    ReleaseHomeworkViewController * homeworkVC = [[ReleaseHomeworkViewController alloc]initWithData:userInfo];
    [self pushViewController:homeworkVC]; 
    [self clearHomeworkCache];
}
@end
