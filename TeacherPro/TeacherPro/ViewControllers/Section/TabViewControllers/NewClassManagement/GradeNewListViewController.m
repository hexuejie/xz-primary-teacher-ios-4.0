

//
//  GradeNewListViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/2.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "GradeNewListViewController.h"
#import "GradeListNewCell.h"

static NSString * const GradeListNewCellIdentifier = @"GradeListNewCellIdentifier";
@interface GradeNewListViewController ()
@property(nonatomic, strong) NSArray * gradeArray;
@end

@implementation GradeNewListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"选择年级"];
    [self configTableView];
    [self reloadTableView];
}

- (void)registerCell{

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GradeListNewCell class]) bundle:nil] forCellReuseIdentifier:GradeListNewCellIdentifier];
}
- (void)configTableView{
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = project_background_gray;
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, FITSCALE(50))];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView =footerView;
}

- (void)reloadTableView{
    
    self.gradeArray = @[ @{@"id":@"1",@"gradeName":@"一年级"},
                           @{@"id":@"2",@"gradeName":@"二年级"},
                           @{@"id":@"3",@"gradeName":@"三年级"},
                           @{@"id":@"4",@"gradeName":@"四年级"},
                           @{@"id":@"5",@"gradeName":@"五年级"},
                           @{@"id":@"6",@"gradeName":@"六年级"},
                           ] ;
    
    
    [self updateTableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger row = [self.gradeArray count];
    
    return row ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    return 48;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return FITSCALE(0.00001);
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    
    return headerView;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footerView = [UIView new];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
 
    return 8;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell ;
    
    GradeListNewCell * gradeCell = [tableView dequeueReusableCellWithIdentifier:GradeListNewCellIdentifier];
    [gradeCell setupGrade:self.gradeArray[indexPath.row][@"gradeName"]];
    cell = gradeCell;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectedGradeBlock) {
        self.selectedGradeBlock(self.gradeArray[indexPath.row]);
    }
    [self backViewController];
    
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
