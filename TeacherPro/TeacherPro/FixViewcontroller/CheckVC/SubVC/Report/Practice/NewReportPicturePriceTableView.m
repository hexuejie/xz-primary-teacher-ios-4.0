//
//  NewReportPicturePriceTableView.m
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/15.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "NewReportPicturePriceTableView.h"
#import "NewReportListonTableViewCell.h"
#import "NewReportSoundHomeworkDetailVC.h"
#import "NewReportPictureTableViewCell.h"

@interface NewReportPicturePriceTableView (){
    CGFloat _gradientProgress;
}

@property(nonatomic, copy) NSString * homeworkId;

@property(nonatomic, strong) NSArray *Items;

@end

@implementation NewReportPicturePriceTableView

- (instancetype)initWithHomeworkId:(NSString *)homeworkId{
    self = [super init];
    if (self) {
        self.homeworkId = homeworkId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"绘本配音"];
    
    [self setupHeaderView];
    [self registerCell];
    self.tableView.backgroundColor = HexRGB(0xFCFCFC);
    self.tableView.allowsSelection = YES;
    
    [self getNetworkData];
}

- (void)setupHeaderView{
    NewReportListonTableViewCell *headerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NewReportListonTableViewCell class]) owner:nil options:nil].firstObject;
    headerView.priceLabel1.textColor = HexRGB(0x8A8F99);
    headerView.priceLabel2.textColor = [UIColor clearColor];
    headerView.priceLabel3.textColor = [UIColor clearColor];
    headerView.priceLabel4.textColor = HexRGB(0x8A8F99);
    headerView.priceLabel1.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    headerView.priceLabel4.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    headerView.priceLabel1.text = @"句子列表";
    headerView.priceLabel4.text = @"平均分";
    
    headerView.backgroundColor =HexRGB(0xF6F6F8);
    headerView.frame = CGRectMake(0, 0, self.view.frame.size.width,47);
    [self.view addSubview:headerView];
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 47)];
}



- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NewReportPictureTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"NewReportPictureTableViewCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.Items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewReportPictureTableViewCell  *cell =  [tableView dequeueReusableCellWithIdentifier:@"NewReportPictureTableViewCell" forIndexPath:indexPath];
    NSMutableDictionary *tempDic = self.Items[indexPath.row];
    cell.contentLabel.text = tempDic[@"en"];
    cell.gradeLabel.text = [NSString stringWithFormat:@"%@",tempDic[@"score"]];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

#pragma mark --- 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NewReportPictureTableViewCell  *cell =  [tableView cellForRowAtIndexPath:indexPath];
    NewReportSoundHomeworkDetailVC *priceVC = [[NewReportSoundHomeworkDetailVC alloc]initWithHomeworkId:self.homeworkId];
//    priceVC.subTitle = cell.contentLabel.text;
    priceVC.isSound = YES;
    priceVC.Items = self.Items;
    priceVC.currentSelected = indexPath.row;   ///有读音
    [self pushViewController:priceVC];
}

#pragma mark - request请求
- (void)getNetworkData{
    
    NSDictionary * parameterDic = @{@"homeworkId":self.homeworkId,@"typeId":@"hbpy"};
    [self sendHeaderRequest:@"QueryPhonicsChildHomeworkReport" parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryHomeworkReport];
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_QueryHomeworkReport) {
            NSLog(@"%@=-==",successInfoObj);
            weakSelf.Items = successInfoObj[@"list"];
            [strongSelf updateTableView];
        }
    }];
}

@end
