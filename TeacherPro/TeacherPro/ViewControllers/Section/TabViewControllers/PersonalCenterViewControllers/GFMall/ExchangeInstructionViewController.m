
//
//  ExchangeInstructionViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/8.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ExchangeInstructionViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ExchangeInstructionFirstSectionCell.h"
#import "ExchangeInstructionFirstContentCell.h"
#import "ExchangeInstructionOtherContentCell.h"
#import "ExchangeInstructionOtherSectionCell.h"

NSString * const ExchangeInstructionFirstSectionCellIdentifier = @"ExchangeInstructionFirstSectionCellIdentifier";
NSString * const ExchangeInstructionFirstContentCellIdentifier = @"ExchangeInstructionFirstContentCellIdentifier";
NSString * const ExchangeInstructionOtherContentCellIdentifier = @"ExchangeInstructionOtherContentCellIdentifier";
NSString * const ExchangeInstructionOtherSectionCellIdentifier = @"ExchangeInstructionOtherSectionCellIdentifier";

@interface ExchangeInstructionViewController ()
@property(nonatomic, copy) NSString * detail;
@property(nonatomic, strong) NSArray * exchangeArray;
@end

@implementation ExchangeInstructionViewController
- (instancetype)initWithDetail:(NSString *) detail{
    if (self == [super init]) {
        self.detail = detail;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"兑换须知";
    // Do any additional setup after loading the view.
//    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, self.view.frame.size.width -40, 0) ];
//    label.text = self.detail;
//    label.textColor = UIColorFromRGB(0x6b6b6b);
//    label.numberOfLines = 0;
//    label.lineBreakMode = NSLineBreakByWordWrapping;
//    [label sizeToFit];
//    [self.view addSubview:label];
    NSDictionary * oneDic = @{@"title":@"尊敬的老师：",
                              
                             @"detail":@[@"     感谢您对“小佳老师”APP的信任与厚爱，为了让您更方便快捷的兑换和收到礼品，现将兑换的相关事项作如下说明："]
                           };
    NSDictionary * twoDic = @{@"title":@"礼品简介",
                              @"imgName":@"gift_info.png",
                              @"detail":@[@"充值卡/购书卡类：充值卡为移动和电信两大运营商的百元充值卡，为湖南省内的号码充值有效；购书卡为湖南省新华书店提供，在湖南省内各新华书店使用，您可到就近的新华书店购置书籍或文化用品。",@"其他实物类：您收到的礼品实物与图片及其描述相符，但颜色和款式将随机发送。"]
                              };
    NSDictionary * threeDic = @{@"title":@"礼品寄送",
                                @"imgName":@"gift_send.png",
                                @"detail":@[@"信息填写：填写收货地址和相关信息时，请确保填写无误，若地址不详或号码有误，则无法为您寄送。",@"寄送时间：除寒暑假外，当月兑换的礼品通过审核，会在次月完成邮寄。"]
                              };
    self.exchangeArray = @[oneDic,twoDic,threeDic];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ExchangeInstructionFirstContentCell class]) bundle:nil] forCellReuseIdentifier:ExchangeInstructionFirstContentCellIdentifier];
      [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ExchangeInstructionFirstSectionCell class]) bundle:nil] forCellReuseIdentifier:ExchangeInstructionFirstSectionCellIdentifier];
      [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ExchangeInstructionOtherContentCell class]) bundle:nil] forCellReuseIdentifier:ExchangeInstructionOtherContentCellIdentifier];
      [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ExchangeInstructionOtherSectionCell class]) bundle:nil] forCellReuseIdentifier:ExchangeInstructionOtherSectionCellIdentifier];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self.exchangeArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    NSDictionary * dic = self.exchangeArray[section];
    row = [dic[@"detail"] count]+1;
    return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            height = 44;
        }else{
            height = [tableView fd_heightForCellWithIdentifier:ExchangeInstructionFirstContentCellIdentifier configuration:^(id cell) {
                [self confightFirstCell:cell withIndexPath:indexPath];
            } ];
        }
    }else{
        if (indexPath.row == 0) {
            height = 40;
        }else{
            
            height = [tableView fd_heightForCellWithIdentifier:ExchangeInstructionFirstContentCellIdentifier configuration:^(id cell) {
               [self confightOtherCell:cell withIndexPath:indexPath];
            } ] ;
            if (indexPath.section == 1) {
                height = height -18;
            }
        }
        
    }
  
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell =  nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSString  * titleStr = self.exchangeArray[indexPath.section][@"title"];
            ExchangeInstructionFirstSectionCell * tempCell = [tableView dequeueReusableCellWithIdentifier:ExchangeInstructionFirstSectionCellIdentifier];
            [tempCell setupSectionTitle:titleStr];
            cell = tempCell;
        }else{
         
            ExchangeInstructionFirstContentCell * tempCell = [tableView dequeueReusableCellWithIdentifier:ExchangeInstructionFirstContentCellIdentifier];
            [self confightFirstCell:tempCell withIndexPath:indexPath];
            cell = tempCell;
        }
    }else{
        if (indexPath.row == 0) {
            NSString * titleStr = self.exchangeArray[indexPath.section][@"title"];
             NSString * imgName = self.exchangeArray[indexPath.section][@"imgName"];
            ExchangeInstructionOtherSectionCell * tempCell = [tableView dequeueReusableCellWithIdentifier:ExchangeInstructionOtherSectionCellIdentifier];
            [tempCell setupSectionTitle:titleStr withImageName:imgName];
            cell = tempCell;
        }else{
        
            ExchangeInstructionOtherContentCell * tempCell = [tableView dequeueReusableCellWithIdentifier:ExchangeInstructionOtherContentCellIdentifier];
            [self confightOtherCell:tempCell withIndexPath:indexPath];
            cell = tempCell;
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)confightFirstCell:(ExchangeInstructionFirstContentCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    NSArray * detailArray = self.exchangeArray[indexPath.section][@"detail"];
    NSString * contentStr = detailArray[indexPath.row-1];
     [cell setupContentStr:contentStr];
}

- (void)confightOtherCell:(ExchangeInstructionOtherContentCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    NSArray * detailArray = self.exchangeArray[indexPath.section][@"detail"];
    NSString * contentStr = detailArray[indexPath.row-1];
   [cell setupContentStr:contentStr];
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
