
//
//  StudentListViewController.m
//  TeacherPro
//
//  Created by DCQ on 2018/1/31.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "StudentListViewController.h"
#import "XLPagerTabStripViewController.h"
#import "CheckHomeworkDetailStudentListCell.h"

NSString * const CheckHomeworkDetailStudentListCellIdentifier = @"CheckHomeworkDetailStudentListCellIdentifier";
@interface StudentListViewController ()
@property(nonatomic, assign) StudentListType type;
@property(nonatomic, strong) NSArray* studentArray;
@end

@implementation StudentListViewController
- (instancetype)initWithType:(StudentListType)type withArray:(NSArray *)studentArray{
    self = [super init];
    if (self) {
        self.type = type;
        self.studentArray = studentArray;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
}
- (CGRect)getTableViewFrame{
    CGFloat height =  FITSCALE(44);
    CGRect tableViewFrame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height - height);
    return tableViewFrame;
}
- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CheckHomeworkDetailStudentListCell class]) bundle:nil] forCellReuseIdentifier:CheckHomeworkDetailStudentListCellIdentifier];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row =  0;
    switch (self.type) {
        case StudentListType_Complete:
            row = [self.studentArray count];
            break;
        case StudentListType_NoComplete:
            row = [self.studentArray count];
            break;
        case StudentListType_Wrong:
            row = [self.studentArray count];
            break;
        case StudentListType_Right:
            row = [self.studentArray count];
            break;
        default:
            break;
    }
 
    return  row;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return FITSCALE(44);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = nil;
    CheckHomeworkDetailStudentListCell * tempCell = [tableView dequeueReusableCellWithIdentifier:CheckHomeworkDetailStudentListCellIdentifier];
    [tempCell setupStudentName:self.studentArray[indexPath.row]];
    tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell = tempCell;
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    NSString * title = @"";
    switch (self.type) {
        case StudentListType_Complete:
            title = @"已完成";
            break;
        case StudentListType_NoComplete:
            title = @"未完成";
            break;
        case StudentListType_Wrong:
            title = @"答错";
            break;
        case StudentListType_Right:
            title = @"答对";
            break;
        default:
            break;
    }
    return title;
    
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
