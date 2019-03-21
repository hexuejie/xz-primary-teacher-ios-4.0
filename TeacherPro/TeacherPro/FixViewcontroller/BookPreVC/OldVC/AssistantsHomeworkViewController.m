//
//  AssistantsHomeworkViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/11/17.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "AssistantsHomeworkViewController.h"
#import "BookPreviewModel.h"
#import "BookHomeworkAssistantsTitleCell.h"
#import "BookHomeworkAssistantsChildrenTitleCell.h"
#import "BookHomeworkAssistantsSectionView.h"
#import "BookHomeworkTitleCell.h"
#import "BookPreviewDetailViewController.h"
#import "TeachingAssistantsDetailViewController.h"
#import "JFBookPreviewViewController.h"
#import "BookBookPreDetailViewController.h"
#import "SubJFBookPreViewController.h"
#import "BookHomeworkSectionView.h"

NSString *const AssistantsHomeworkTitleCellIdentifer = @"AssistantsHomeworkTitleCellIdentifer";
NSString *const BookHomeworkAssistantsChildrenTitleCellIdentifer    = @"BookHomeworkAssistantsChildrenTitleCellIdentifer";
NSString *const BookHomeworkAssistantsSectionViewIdentifer   = @"BookHomeworkAssistantsSectionViewIdentifer";
NSString *const BookHomeworkAssistantsTitleCellIdentifer   = @"BookHomeworkAssistantsTitleCellIdentifer";

#define kBookType  @"JFBook"
@interface AssistantsHomeworkViewController ()
@property(nonatomic, copy) NSString * bookId;
@property(nonatomic, strong)   BookPreviewModel *detailModel;
@end

@implementation AssistantsHomeworkViewController
- (instancetype)initWithBookId:(NSString *)bookId  {
    self = [super init];
    if (self) {
        self.bookId = bookId;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestQueryBook];
    [self configTableView];
    [self setNavigationItemTitle:@"教辅作业"];
    // Do any additional setup after loading the view.
}
- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkTitleCell class]) bundle:nil]  forCellReuseIdentifier :AssistantsHomeworkTitleCellIdentifer];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkAssistantsTitleCell class]) bundle:nil]  forCellReuseIdentifier :BookHomeworkAssistantsTitleCellIdentifer];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkAssistantsChildrenTitleCell class]) bundle:nil] forCellReuseIdentifier:BookHomeworkAssistantsChildrenTitleCellIdentifer];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkAssistantsSectionView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:BookHomeworkAssistantsSectionViewIdentifer];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookHomeworkSectionView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:@"BookHomeworkSectionView"];
    
}
- (void)configTableView{
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    // 隐藏UITableViewStyleGrouped上边多余的间隔
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.view.backgroundColor = project_background_gray;
}
- (UITableViewStyle)getTableViewStyle{
    UITableViewStyle style = UITableViewStyleGrouped;
    return style;
}

#pragma mark ---
- (void)requestQueryBook{
    
    NSDictionary *parameterDic =nil;
    if (self.bookId  ) {
        parameterDic  = @{@"bookId":self.bookId,@"getUnit":@"true",@"bookType":kBookType};
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
                
                
                dispatch_queue_t mainQueue = dispatch_get_main_queue();
                //异步返回主线程，根据获取的数据，更新UI
                dispatch_async(mainQueue, ^{
                    
                    [strongSelf updateTableView];
                    
                });
                
            });
        }
    }];
}

#pragma mark ---

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    NSInteger  section =  0;
    if (self.detailModel) {
        if (self.detailModel &&  [self.detailModel.book.bookUnits count]>0) {
            
            section =  1 + [self.detailModel.book.bookUnits count];
        }
    }

    return section;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger row = 0;
    if (section == 0) {
        row = 1;
    }else{
        if (self.detailModel &&  [self.detailModel.book.bookUnits count]>0) {
       
            if ([self isHasChildren:section]) {
                BookUnitModel * model =  self.detailModel.book.bookUnits[section -1];
                row = [model.children count]+1;
            }else{
                 row = 1;
            }
        }
        
    }
    return row;
}
- (BOOL)isHasChildren:(NSInteger)section{
    BOOL  yesOrNo = NO;
    BookUnitModel * model = self.detailModel.book.bookUnits[section -1];
    if ([model.children count] >0) {
        yesOrNo = YES;
    }else{
         yesOrNo = NO;
    }
    return yesOrNo;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height =  0;
    if (indexPath.section ==0) {
        height =  140;
    }else{
        if (indexPath.row == 0) {
            height = 42;
        }else{
           height = 34;
        }
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGFloat height = 0;
    if (  section == 0) {
        height = 46;
    } else{
        height = 0.001;
    }
    return height;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        BookHomeworkSectionView * tempHeader  = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"BookHomeworkSectionView"];
        tempHeader.titleLabel.text = @"可布置作业目录";
        return tempHeader;
    }else{
        UIView * headerView =  [UIView new];
        headerView.backgroundColor = project_background_gray;
        return headerView;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =  nil;
    if (indexPath.section == 0) {
        BookHomeworkTitleCell * tempCell = [tableView dequeueReusableCellWithIdentifier:AssistantsHomeworkTitleCellIdentifer];
        [tempCell  setupPreviewDetailInfo:self.detailModel.book];
        tempCell.changeBookBlock = ^{
            [self gotoBookPreviewDetailVC];
        };

        cell = tempCell;
    }else {
        if (indexPath.row == 0) {
            BookHomeworkAssistantsTitleCell * tempCell = [tableView dequeueReusableCellWithIdentifier:BookHomeworkAssistantsTitleCellIdentifer];
            BookUnitModel * model = self.detailModel.book.bookUnits[indexPath.section -1];
            [tempCell setupTitle:model.unitName];
            if (model.children &&[model.children count]>0) {
                [tempCell hiddenArrow];
            }
            
            cell = tempCell;
        }else{
            BookHomeworkAssistantsChildrenTitleCell * tempCell = [tableView dequeueReusableCellWithIdentifier:BookHomeworkAssistantsChildrenTitleCellIdentifer];
            BookUnitModel * model = self.detailModel.book.bookUnits[indexPath.section -1];
            if (model.children) {
                ChildrenUnitModel * unitModel =  model.children[indexPath.row -1];
                [tempCell  setupChildrenTitle: unitModel.unitName];
            }
            cell = tempCell;
        }
         
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [self gotoBookPreviewDetailVC];
    }else{
        if ([self isHasChildren:indexPath.section]) {
            if (indexPath.row >0) {
              [self  gotoTeachingAssistantsDetailVC:indexPath];
            }
        }else{
            [self  gotoTeachingAssistantsDetailVC:indexPath];
        }
    }
    
}

#pragma mark ---

- (void)gotoBookPreviewDetailVC{
    
    NSString * bookId = self.bookId;
    BOOL existsState = YES;
    NSString * bookType =  kBookType;
    
    SubJFBookPreViewController *subBookVC = [SubJFBookPreViewController new];
    subBookVC.bookId = self.bookId;
    subBookVC.detailModel = self.detailModel;
    [self pushViewController:subBookVC];
}

- (void)gotoTeachingAssistantsDetailVC:(NSIndexPath *)indexPath{
    
    
    BookUnitModel * model = self.detailModel.book.bookUnits[indexPath.section -1];
    NSString * unitId =  model.unitId;
    NSString * bookName =  self.detailModel.book.name;
    NSString * bookId = self.bookId;
    if (model.children) {
        BookUnitModel * childrenModel =  model.children[indexPath.row -1];
        unitId = childrenModel.unitId;
       
    }
    
    TeachingAssistantsDetailViewController * detail = [[TeachingAssistantsDetailViewController alloc]initWithBookId:bookId   withUnitId:unitId  withBookName: bookName withBookInfo:self.detailModel.book];
    [self pushViewController:detail];
}
-(void)dealloc{
    self.detailModel = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
