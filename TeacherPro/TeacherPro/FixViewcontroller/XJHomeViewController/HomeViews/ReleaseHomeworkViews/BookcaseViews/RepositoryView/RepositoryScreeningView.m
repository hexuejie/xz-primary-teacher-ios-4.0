//
//      ┏┛ ┻━━━━━┛ ┻┓
//      ┃　　　　　　 ┃
//      ┃　　　━　　　┃
//      ┃　┳┛　  ┗┳　┃
//      ┃　　　　　　 ┃
//      ┃　　　┻　　　┃
//      ┃　　　　　　 ┃
//      ┗━┓　　　┏━━━┛
//        ┃　　　┃   神兽保佑
//        ┃　　　┃   代码无BUG！
//        ┃　　　┗━━━━━━━━━┓
//        ┃　　　　　　　    ┣┓
//        ┃　　　　         ┏┛
//        ┗━┓ ┓ ┏━━━┳ ┓ ┏━┛
//          ┃ ┫ ┫   ┃ ┫ ┫
//          ┗━┻━┛   ┗━┻━┛
//
//  RepositoryScreeningView.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/19.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "RepositoryScreeningView.h"
#import "PublicDocuments.h"
#import "RepositoryScreeningCell.h"
#import "QueryBookFilterModel.h"

NSString * const  RepositoryScreeningCellIdentifier = @"RepositoryScreeningCellIdentifier";

#define   cellHeight   FITSCALE(40)
@interface RepositoryScreeningView()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView * tableView;

@end
@implementation RepositoryScreeningView

- (instancetype)initWithFrame:(CGRect)frame{
    self  = [super initWithFrame:frame];
    if (self) {
      [self setupSubview];
    }
    return self;
}

- (void)setupSubview{

    UIView * backgroundLayerView = [[UIView alloc]initWithFrame:self.frame];
    backgroundLayerView.backgroundColor = [UIColor blackColor];
    backgroundLayerView.alpha = 0.5;
    [self addSubview:backgroundLayerView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideView)];
    [backgroundLayerView addGestureRecognizer:tap];
    [self addSubview:self.tableView];
   
   
    
}

- (UITableView *)tableView{

    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, cellHeight *7) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RepositoryScreeningCell class]) bundle:nil] forCellReuseIdentifier:RepositoryScreeningCellIdentifier];
         
    }
    return _tableView;
}
- (void)updateTableView{
    
    if (self.rows  >7) {
        self.tableView.frame = CGRectMake(0, 0, self.frame.size.width, cellHeight * 7+10);
    }else{
        self.tableView.frame = CGRectMake(0, 0, self.frame.size.width, cellHeight * self.rows );
    }
    
    if (self.screeningType == RepositoryScreeningType_version) {
        self.selectedIndex = 0;
        for (int i = 0; i< [self.publishersModel.publishers count]; i++) {
            PublisherModel * model  = self.publishersModel.publishers[i];
            if ([self.publisherId integerValue] == [model.id integerValue]) {
                self.selectedIndex = i+1;
            }
        }
    }
    [self.tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    NSInteger section = 0;
    if (self.rows == 0) {
        section = 0;
    }else{
        section = 1;
    }
    return section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return  self.rows ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell;
    RepositoryScreeningCell * tempCell = [tableView dequeueReusableCellWithIdentifier:RepositoryScreeningCellIdentifier];

   NSString * name = @"";
    switch (self.screeningType) {
        case RepositoryScreeningType_type:
            if (indexPath.row == 0) {
                name = @"全部";
            }else{
              BookTypeModel * model  = self.typesModel.bookTypes[indexPath.row -1];
              name =  model.bookTypeName;
            }
           
            break;
        case RepositoryScreeningType_grade:
            if (indexPath.row == 0) {
                name = @"全部";
            }else{
                GradeModel * model  = self.gradesModel.grades [indexPath.row -1];
                name =  model.gradeName;
            }
            break;
        case RepositoryScreeningType_version:
            if (indexPath.row == 0) {
                name = @"全部";
            }else{
                PublisherModel * model  = self.publishersModel.publishers[indexPath.row -1];
                name =  model.versionName;
            }
            break;
        case RepositoryScreeningType_subjects:
            if (indexPath.row == 0) {
                name = @"全部";
            }else{
                SubjectModel * model  = self.subjectsModel.subjects[indexPath.row -1];
                name =  model.subjectName;
            }
            break;
        default:
            break;
    }
 
     BOOL isSelected = NO;
      if (indexPath.row == self.selectedIndex) {
            isSelected = YES;
      }
  
    [tempCell setupName:name  withChoose:isSelected];
    tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell = tempCell;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    self.selectedIndex = indexPath.row;
  
     [self updateTableView];
    if ([self.delegate respondsToSelector:@selector(selectedType:withIndexItem: withIndex:)]) {
        id item = nil;
 
        switch (self.screeningType) {
            case RepositoryScreeningType_type:
                if (indexPath.row == 0) {
                    item = @"全部";
                }else{
                    BookTypeModel * model  = self.typesModel.bookTypes[indexPath.row -1];
                    item =  model;
                }
                
                break;
            case RepositoryScreeningType_grade:
                if (indexPath.row == 0) {
                    item = @"全部";
                }else{
                    GradeModel * model  = self.gradesModel.grades [indexPath.row -1];
                    item =  model ;
                }
                break;
            case RepositoryScreeningType_version:
                if (indexPath.row == 0) {
                    item = @"全部";
                }else{
                    PublisherModel * model  = self.publishersModel.publishers[indexPath.row -1];
                    item =  model ;
                }
                break;
            case RepositoryScreeningType_subjects:
                if (indexPath.row == 0) {
                    item = @"全部";
                }else{
                    SubjectModel * model  = self.subjectsModel.subjects[indexPath.row -1];
                    item =  model ;
                }
                break;
            default:
                break;
        }
        
        [self.delegate selectedType:self.screeningType withIndexItem:item withIndex:self.selectedIndex];
   
    }
   
}

- (void)showView{

    self.hidden = NO;
}
- (void)hideView{
    self.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(hiddScreeningView)]) {
        [self.delegate hiddScreeningView];
    }
}
@end
