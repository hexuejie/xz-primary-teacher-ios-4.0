//
//  AboutController.m
//  AplusEduPro
//
//  Created by neon on 15/7/31.
//  Copyright (c) 2015年 neon. All rights reserved.
//

#import "AboutController.h"
#import "VersionUtils.h"
#import "PublicDocuments.h"
#import "SettingControllerCell.h"

NSString * const AboutCellIdentifier = @"AboutCellIdentifier";
@interface AboutController ()

@end

@implementation AboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationItemTitle:@"关于我们"];

    [self initHeaderView];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self navUIBarBackground:0];
 
}
- (UITableViewStyle)getTableViewStyle{

    return UITableViewStyleGrouped;
}
- (void)registerCell{

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SettingControllerCell class]) bundle:nil] forCellReuseIdentifier:AboutCellIdentifier];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

#pragma mark method

-(void)initHeaderView{
     NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    UIView *headerview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 160*scale_y)];
    UIImageView *iconview=[[UIImageView alloc]init];
    [headerview addSubview:iconview];
    [iconview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headerview );
        make.top.mas_equalTo(headerview).offset(30*scale_y);
        make.size.mas_equalTo(CGSizeMake (60, 60));
    }];
    iconview.image=[UIImage imageNamed:@"new_login_icon"];
    
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.font=[UIFont systemFontOfSize:16];;
    titleLabel.textColor=UIColorFromRGB(0x6b6b6b);
    titleLabel.textAlignment=NSTextAlignmentCenter;
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    
    titleLabel.text= app_Name?app_Name:@"小佳老师";
    [headerview addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headerview );
        make.top.mas_equalTo(iconview.mas_bottom).offset(7*scale_y);
    }];
    
    UILabel *editionLabel=[[UILabel alloc]init];
    editionLabel.font=[UIFont systemFontOfSize:12];
    editionLabel.textColor= UIColorFromRGB(0x9f9f9f);
    editionLabel.textAlignment=NSTextAlignmentCenter;
   


    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];

    editionLabel.text = [NSString stringWithFormat:@"iphone V%@",app_Version];
    [headerview addSubview:editionLabel];
    [editionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headerview );
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(10*scale_y);
    }];
    
    UIView * bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, headerview.frame.size.height- FITSCALE(0.5), self.view.frame.size.width, FITSCALE(0.5))];
    bottomLine.backgroundColor = project_line_gray;
    [headerview addSubview:bottomLine];
    self.tableView.tableHeaderView=headerview;
    
}


#pragma mark uitableviewdelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell;
    SettingControllerCell * tempCell = [tableView dequeueReusableCellWithIdentifier:AboutCellIdentifier];
    if(indexPath.row==0){
        [tempCell setupCellInfo:@"给我评分"];
    }else{
        [tempCell setupCellInfo: [NSString stringWithFormat:@"客服电话：%@",CustomerServicePhoneNumber]];
    }

    cell = tempCell;
 

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return FITSCALE(44);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
//        NSString *_idStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%@?mt=8",@"12"];
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:_idStr]];
        
         [VersionUtils gotoAppStoreComment];
    }else{
          
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",CustomerServicePhoneNumber]]];
        });
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
