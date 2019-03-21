
//
//  JFHomeworkDoubtStudentListViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/26.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "JFHomeworkDoubtStudentListViewController.h"

NSString * const  JFDoubtStudentUITableViewCellIdentifier = @"JFDoubtStudentUITableViewCellIdentifier";
@interface JFHomeworkDoubtStudentListViewController ()
@property(nonatomic, strong) NSArray * doubtStudents;
@end

@implementation JFHomeworkDoubtStudentListViewController
- (instancetype)initWithData:(NSArray *)doubtStudents{
    if (self == [super init]) {
        self.doubtStudents = doubtStudents;
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self setTitle:@"不会做的学生"];
    [self configTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = project_line_gray;
}
- (void)registerCell{
    
    [self.tableView registerClass:[UITableViewCell  class] forCellReuseIdentifier:JFDoubtStudentUITableViewCellIdentifier];
}
- (void)configTableView{
    self.tableView.backgroundColor = [UIColor clearColor];
    // 隐藏UITableViewStyleGrouped上边多余的间隔
    self.view.backgroundColor = project_background_gray;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
 
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.doubtStudents count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [ tableView dequeueReusableCellWithIdentifier:JFDoubtStudentUITableViewCellIdentifier];
    cell.textLabel.text =  self.doubtStudents[indexPath.row];
    cell.textLabel.textColor = UIColorFromRGB(0x6b6b6b);
    cell.textLabel.font = fontSize_14;
    return cell;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
      CGFloat height = FITSCALE(10);
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
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
