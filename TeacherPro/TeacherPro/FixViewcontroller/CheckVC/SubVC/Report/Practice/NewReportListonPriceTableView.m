//
//  NewReportListonPriceTableView.m
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/11.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "NewReportListonPriceTableView.h"
#import "NewReportListonTableViewCell.h"
#import "NewReportSoundHomeworkDetailVC.h"

@interface NewReportListonPriceTableView (){
    CGFloat _gradientProgress;
}

@property(nonatomic, copy) NSString * homeworkId;

@property(nonatomic, strong) NSArray *Items;
@end

@implementation NewReportListonPriceTableView

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
    [self setNavigationItemTitle:@"听力练习"];
    
    [self setupHeaderView];
    [self registerCell];
    self.tableView.backgroundColor = HexRGB(0xFCFCFC);
    self.tableView.allowsSelection = YES;
    
    [self getNetworkData];
}

#pragma mark - request请求
- (void)getNetworkData{
    
    NSDictionary * parameterDic = @{@"homeworkId":self.homeworkId,@"typeId":@"tllx"};
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
- (void)setupHeaderView{
    NewReportListonTableViewCell *headerView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NewReportListonTableViewCell class]) owner:nil options:nil].firstObject;
    headerView.priceLabel1.textColor = HexRGB(0x8A8F99);
    headerView.priceLabel2.textColor = HexRGB(0x8A8F99);
    headerView.priceLabel3.textColor = HexRGB(0x8A8F99);
    headerView.priceLabel4.textColor = HexRGB(0x8A8F99);
    headerView.priceLabel1.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    headerView.priceLabel2.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    headerView.priceLabel3.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    headerView.priceLabel4.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    
    headerView.backgroundColor =HexRGB(0xF6F6F8);
    headerView.frame = CGRectMake(0, 0, self.view.frame.size.width,47);
    [self.view addSubview:headerView];
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 47)];
}



- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NewReportListonTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"NewReportListonTableViewCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.Items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 47;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewReportListonTableViewCell  *cell =  [tableView dequeueReusableCellWithIdentifier:@"NewReportListonTableViewCell" forIndexPath:indexPath];
    
    NSDictionary *tempDic = self.Items[indexPath.row];
    cell.priceLabel1.text = tempDic[@"en"];
    if ([tempDic[@"masteLevels"] count]>=3) {
        cell.priceLabel2.text =  [tempDic[@"masteLevels"][0][@"studentRate"] stringByReplacingOccurrencesOfString:@"%" withString:@""] ;
        cell.priceLabel3.text = [tempDic[@"masteLevels"][1][@"studentRate"] stringByReplacingOccurrencesOfString:@"%" withString:@""];
        cell.priceLabel4.text = [tempDic[@"masteLevels"][2][@"studentRate"] stringByReplacingOccurrencesOfString:@"%" withString:@""];
        
        NSArray* array = @[cell.priceLabel2.text,
                           cell.priceLabel3.text,
                           cell.priceLabel4.text];
        NSInteger maxValue = [[array valueForKeyPath:@"@max.integerValue"] integerValue];
        NSInteger index =  [array indexOfObject:[NSString stringWithFormat:@"%ld",maxValue]];
        NSString *strFront;
        NSString *strEqual;
        for (NSString *strtemp in array) {
            if ([strtemp isEqualToString:strFront]) {
                strEqual = strtemp;
            }
            strFront = strtemp;
        }
        
        cell.priceLabel2.textColor = HexRGB(0x8A8F99);
        cell.priceLabel3.textColor = HexRGB(0x8A8F99);
        cell.priceLabel4.textColor = HexRGB(0x8A8F99);
        if ([strEqual integerValue] != maxValue) {
            if (index == 0) {
                cell.priceLabel2.textColor = HexRGB(0xFF5D46);
            }else if (index == 1) {
                cell.priceLabel3.textColor = HexRGB(0xFF5D46);
            }else if (index == 2) {
                cell.priceLabel4.textColor = HexRGB(0xFF5D46);
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

#pragma mark --- 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewReportSoundHomeworkDetailVC *priceVC = [[NewReportSoundHomeworkDetailVC alloc]initWithHomeworkId:self.homeworkId];
    priceVC.isSound = NO;
    priceVC.Items = self.Items;
    priceVC.currentSelected = indexPath.row;
    [self pushViewController:priceVC];
}
@end
