//
//  LeftGradeView.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "LeftGradeView.h"
#import "LeftGradeCell.h"
#import "PublicDocuments.h"

NSString * const  LeftGradeCellIdentifier = @"LeftGradeCellIdentifier";
@interface LeftGradeView()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView * tableView;
@property(nonatomic, strong) NSArray * tableViewData;
@property(nonatomic, assign) UITableViewStyle  style;
@property(nonatomic, assign) NSInteger      selelctedIndex;
@property(nonatomic, strong) NSDictionary *gradeInfo;
@end
@implementation LeftGradeView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{

    if (self = [self initWithFrame:frame]) {
        self.style = style;
        [self setupSubViews];
    
    }
    return self;
}

- (void)setupSubViews{
    
   self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:self.style];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LeftGradeCell class]) bundle:nil] forCellReuseIdentifier:LeftGradeCellIdentifier];
      [self addSubview:self.tableView];
    self.tableViewData = [[NSArray alloc]initWithObjects: @"一年级",@"二年级",@"三年级",@"四年级",@"五年级",@"六年级", nil];
    self.tableView.backgroundColor = [UIColor clearColor];
  
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tableViewData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.frame.size.height/6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LeftGradeCell *cell = [tableView dequeueReusableCellWithIdentifier:LeftGradeCellIdentifier];
    

    NSString * gradeName = self.tableViewData [indexPath.row];
    if (self.selelctedIndex == indexPath.row) {
        [cell setupBackgroundView:UIColorFromRGB(0xD1E5FF) textColor:UIColorFromRGB(0x6296F3) layerColor:  UIColorFromRGB(0x2e8aff)];
    }else{
        [cell setupBackgroundView:[UIColor clearColor] textColor:UIColorFromRGB(0x979797) layerColor:[UIColor clearColor]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *managerNumber = nil;
    NSString *joinNumber = nil;
     managerNumber = self.gradeInfo[gradeName][@"admin"];
    joinNumber = self.gradeInfo[gradeName][@"noadmin"];
    [cell setupCellInfo:gradeName withManagerClass:managerNumber withJoinClass:joinNumber];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != self.selelctedIndex) {
        self.selelctedIndex = indexPath.row;
        [self.tableView reloadData];
        if (self.gradeBlock) {
            self.gradeBlock(self.tableViewData[self.selelctedIndex]);
        }
    }
  
}
-(void)setupSelectedGrade:(NSString *)gradeName dataInfo:(NSDictionary *)info{

    for (int i =0; i<self.tableViewData.count; i++) {
        if([self.tableViewData[i] isEqualToString: gradeName]){
            self.selelctedIndex = i;
        }
    }
    self.gradeInfo = info;
    
    [self.tableView reloadData];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
