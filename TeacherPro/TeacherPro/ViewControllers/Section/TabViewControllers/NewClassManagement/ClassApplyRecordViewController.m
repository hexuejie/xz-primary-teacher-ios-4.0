
//
//  ClassApplyRecordViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ClassApplyRecordViewController.h"
#import "ApplyRecordCell.h"
#import "ApplyRecordModel.h"
static   NSString * const ApplyRecordCellIdentifier = @"ApplyRecordCellIdentifier";
@interface ClassApplyRecordViewController ()
@property(nonatomic, strong) ApplyRecordsModel * applyRecords;
@property(nonatomic, assign) NSInteger selectedIndex;
@end

@implementation ClassApplyRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"申请记录"];
    [self configTableView];
}
- (NSString *)getDescriptionText{

    return @"暂无记录";
}
- (void)registerCell{

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ApplyRecordCell class]) bundle:nil] forCellReuseIdentifier:ApplyRecordCellIdentifier];
}

- (void)configTableView{
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = project_background_gray;
    
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, FITSCALE(50))];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView =footerView;
}


- (void)getNormalTableViewNetworkData{
    
    [self requestApplyRecord];
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if ([self.applyRecords.applyClazzs  count] == 0) {
        return 0;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.applyRecords.applyClazzs  count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return FITSCALE(60);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return FITSCALE(7);
}
- ( UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIImageView * footV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, FITSCALE (7))];
    [footV setImage:[UIImage imageNamed:@"speack_line"]];
    return footV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return  FITSCALE(12);
    }else
        return  FITSCALE(0);
    
}

- ( UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;{
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH,  FITSCALE(13))];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell ;
    ApplyRecordCell * tempCell = [tableView dequeueReusableCellWithIdentifier:ApplyRecordCellIdentifier];
    tempCell.index = indexPath;
    WEAKSELF
    tempCell.urgedBlock = ^(NSIndexPath *index) {
      
        [weakSelf selectedUrgedApply:index];
    };
    [tempCell setupCellInfo:self.applyRecords.applyClazzs[indexPath.row]];
    cell = tempCell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)selectedUrgedApply:(NSIndexPath *)index{
     self.selectedIndex = index.row;
     ApplyRecordModel * model = self.applyRecords.applyClazzs[index.row];
     [self requestUrgedApplyRecord:model.applyId];
    
}


#pragma mark -----
- (void)requestUrgedApplyRecord:(NSString *)applyId{
    if (!applyId) {
        
        return;
    }
    NSDictionary * parameterDic = @{@"applyId":applyId};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherCallApplyAddClazz] parameterDic: parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherCallApplyAddClazz];
    
}
- (void)requestApplyRecord{
    
    
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_ListTeacherApplyClazzHistory] parameterDic: nil requestMethodType:RequestMethodType_POST requestTag:NetRequestType_ListTeacherApplyClazzHistory];
    
}


- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_ListTeacherApplyClazzHistory) {
            if (successInfoObj) {
                strongSelf.applyRecords = [[ApplyRecordsModel alloc]initWithDictionary:successInfoObj error:nil];
                [strongSelf updateTableView];
            }
        }else if (request.tag == NetRequestType_TeacherCallApplyAddClazz){
        
            ApplyRecordModel * model = strongSelf.applyRecords.applyClazzs[strongSelf.selectedIndex];
            model.callStatus =@(1);
            NSLog(@"催促成功");
//            [strongSelf showAlert:TNOperationState_OK content:@"催促成功"];
            
             [strongSelf updateTableView];
        }
       
    }];
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
