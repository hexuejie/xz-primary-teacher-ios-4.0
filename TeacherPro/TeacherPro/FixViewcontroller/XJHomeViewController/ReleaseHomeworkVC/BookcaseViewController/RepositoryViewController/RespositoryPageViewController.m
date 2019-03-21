//
//  RespositoryPageViewController.m
//  TeacherPro
//
//  Created by 何学杰 on 2018/11/27.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "RespositoryPageViewController.h"
#import "RepositoryViewController.h"
#import "BookSearchViewController.h"
#import "UIView+add.h"


@interface RespositoryPageViewController ()<WMPageControllerDelegate,UITextFieldDelegate>
{
    RepositoryViewController *merchantVc;
    RepositoryViewController *merchantVc1;
    
    UITextField *searchField;
}
@end

@implementation RespositoryPageViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = true;
    
    UIView *uiBarBackground = self.navigationController.navigationBar.subviews.firstObject;
    [uiBarBackground setCornerRadius:0 withShadow:YES withOpacity:0];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    UIView *uiBarBackground = self.navigationController.navigationBar.subviews.firstObject;
//    [uiBarBackground setCornerRadius:0 withShadow:YES withOpacity:8];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyCalculatesItemWidths = YES;
    self.menuViewContentMargin = -57;
    self.delegate = self;
    
    UIView*titleView = [[UIView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth-100,30)];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-13, 0, kScreenWidth - 60, 30)];
    searchBar.placeholder = @"请输入关键字搜索";
    searchBar.layer.cornerRadius = 15;
    searchBar.layer.masksToBounds = YES;
    searchBar.backgroundImage = [[UIImage alloc] init];
    searchBar.backgroundColor = HexRGB(0xF6F6F8);
    searchBar.showsCancelButton = NO;
    searchBar.barStyle=UIBarStyleDefault;
    searchBar.keyboardType = UIKeyboardTypeNamePhonePad;
    searchBar.showsSearchResultsButton = NO;
    [searchBar setImage:[UIImage imageNamed:@"Search_Icon"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];

    searchField = [searchBar valueForKey:@"_searchField"];
    [searchField setBackgroundColor:[UIColor clearColor]];
    searchField.textColor= [UIColor whiteColor];
    searchField.font = [UIFont systemFontOfSize:15];
    [searchField setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    [searchField setValue:HexRGB(0xA1A7B3) forKeyPath:@"_placeholderLabel.textColor"];
    //只有编辑时出现出现那个叉叉
//    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchClick)];
    [searchField addGestureRecognizer:tap];
    
    
    [titleView addSubview:searchBar];
    self.navigationItem.titleView = titleView;
    
    merchantVc = [[RepositoryViewController alloc]init];
    merchantVc.isHome = NO;
    merchantVc.title = @"英语教材";//。。。。book
    merchantVc.bookType = BookTypeBook;

    merchantVc1 = [[RepositoryViewController alloc]init];
    merchantVc1.isHome = NO;
    merchantVc1.title = @"英语绘本";//。。。。
    merchantVc1.bookType = BookTypeCartoon;

    RepositoryViewController *merchantVc2 = [[RepositoryViewController alloc]init];
    merchantVc2.isHome = NO;
    merchantVc2.title = @"自然拼读";//。。。。Phonics
    merchantVc2.bookType = BookTypePhonics;

    self.subViewControllers = @[merchantVc,merchantVc1];

    [self requestQueryBookFilterDic];
    
}


#pragma mark --- request
- (void)requestQueryBookFilterDic{//
    [self sendHeaderRequest:@"ListBookTypeChildDic" parameterDic:nil requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListBookTypeChildDic];
}

- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_ListBookTypeChildDic){
            weakSelf.bookTypeArray = successInfoObj[@"bookTypes"];
            [strongSelf confitgFilterDic:successInfoObj];
        }
    }];
}

- (void)confitgFilterDic:(NSDictionary *)successInfoObj{
    
    for (NSDictionary *tempDic in self.bookTypeArray) {
        
        RespositoryQueryModel *model = [[RespositoryQueryModel alloc]initWithDictionary:tempDic error:nil];
        
        //创建subcollection
        if ([model.bookType isEqualToString:BookTypeBook]) {//BookQueryModel
            
            NSMutableArray *gradeArr = [NSMutableArray new];
            NSMutableSet *publisherSet = [NSMutableSet new];
            for (int i = 1; i<30; i++) {
                SubjectQueryModel *tempQueryModel = [SubjectQueryModel new];
                tempQueryModel.isSelected = NO;
                tempQueryModel.grade = i;
                [gradeArr addObject:tempQueryModel];
            }

            SubjectQueryModel *publisherModel = [SubjectQueryModel new];
            for (int i = 0; i<model.bookDics.count; i++) {
                SubjectQueryModel *queryModel = model.bookDics[i];
                if (i < gradeArr.count) {

                    for (SubjectQueryModel *gradeModel in gradeArr) {
                        if (queryModel.grade == gradeModel.grade) {
                            gradeModel.gradeName = queryModel.gradeName;
                            break;
                        }
                    }
                }
                
    
                NSDictionary *publisher = @{@"publisherName":queryModel.publisherName,
                                            @"publisherId":queryModel.publisherId,
                                            @"isSelected":@(0)
                                            };
                [publisherSet addObject:publisher];
            }
    
            NSMutableArray *newGradeArr = [NSMutableArray new];
            for (int i = 0; i<gradeArr.count; i++) {
                SubjectQueryModel *tempQueryModel = gradeArr[i];
                if (tempQueryModel.gradeName != nil) {
                    [newGradeArr addObject:tempQueryModel];
                }
            }
            NSMutableArray *newPublisherArr = [NSMutableArray new];
            for (NSDictionary *publisherDic in publisherSet) {
                
                SubjectQueryModel *modelPub = [[SubjectQueryModel alloc]initWithDictionary:publisherDic error:nil];
                [newPublisherArr addObject:modelPub];
            }
            
            self.bookQueryModel = [BookQueryModel new];
            self.bookQueryModel.queryGrade = newGradeArr;
            self.bookQueryModel.queryPublisher = newPublisherArr;
            merchantVc.bookQueryModel = self.bookQueryModel;
        }else if([model.bookType isEqualToString:BookTypeCartoon]){//CartoonQueryModel
            
            NSMutableArray *gradeArr = [NSMutableArray new];
            NSMutableArray *levelArr = [NSMutableArray new];
            
            for (int i = 0; i<30; i++) {
                SubjectQueryModel *tempQueryModel = [SubjectQueryModel new];
                tempQueryModel.isSelected = NO;
                tempQueryModel.grade = i;
                [gradeArr addObject:tempQueryModel];
            }
            
            SubjectQueryModel *levelyModel = [SubjectQueryModel new];
            for (int i = 0; i<model.bookDics.count; i++) {
                SubjectQueryModel *queryModel = model.bookDics[i];
                if (i < gradeArr.count) {
                    for (SubjectQueryModel *gradeModel in gradeArr) {
                        if (queryModel.grade == gradeModel.grade) {
                            gradeModel.gradeName = queryModel.gradeName;
                            break;
                        }
                    }
                }
                if (queryModel.level != levelyModel.level) {
                    queryModel.isSelected = NO;
                    levelyModel.level = queryModel.level;
                    [levelArr addObject:queryModel];
                }
            }
            
            NSMutableArray *newGradeArr = [NSMutableArray new];
            for (int i = 0; i<gradeArr.count; i++) {
                SubjectQueryModel *tempQueryModel = gradeArr[i];
                if (tempQueryModel.gradeName != nil) {
                    [newGradeArr addObject:tempQueryModel];
                }
            }
            
        
            self.cartoonQueryModel = [CartoonQueryModel new];
            self.cartoonQueryModel.queryGrade = newGradeArr;
            self.cartoonQueryModel.queryLevel = levelArr;
            merchantVc1.cartoonQueryModel = self.cartoonQueryModel;
        }
    }
}

- (void)searchClick{
    BookSearchViewController *searchVC = [BookSearchViewController new];
    [self.navigationController pushViewController:searchVC animated:YES];
}
@end
