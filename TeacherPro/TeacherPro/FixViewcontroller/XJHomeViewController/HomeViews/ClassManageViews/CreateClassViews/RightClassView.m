//
//  RightClassView.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "RightClassView.h"
#import "ClassManagementCell.h"
#import "PublicDocuments.h"
#import "ClassManageModel.h"
NSString * const  ClassManagementCellIdentifier = @"ClassManagementCellIdentifier";

@interface RightClassView()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView * tableView;
@property(nonatomic, strong) NSArray * tableViewArray;
@property(nonatomic, strong) NSMutableArray * selectedArray;
@property(nonatomic, assign) UITableViewStyle  style;
@property(nonatomic, assign) RightClassViewType  type;
@property(nonatomic, copy)   NSString *  gradeName;
@end
@implementation RightClassView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style withType:(RightClassViewType)type{
    
    if (self = [self initWithFrame:frame]) {
         self.style = style;
         self.type = type;
      
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, self.frame.size.width, self.frame.size.height) style:self.style];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ClassManagementCell class]) bundle:nil] forCellReuseIdentifier:ClassManagementCellIdentifier];
    [self addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
}
- (void)initData{

    self.selectedArray = [NSMutableArray array];
//    NSArray * selectedArray = [[NSUserDefaults standardUserDefaults] objectForKey:SAVE_RELEASEHOMEWORKCLASS   ];
    NSDictionary * selectedInfo = [[NSUserDefaults standardUserDefaults] objectForKey:SAVE_RELEASEHOMEWORKCLASS   ];
    
    for (NSString * classId in [selectedInfo  allValues][0] ) {
        [self.selectedArray addObject:classId];
    }
  
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.tableViewArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return FITSCALE(44);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ClassManagementCell *cell = [ tableView dequeueReusableCellWithIdentifier:ClassManagementCellIdentifier];
    
    [cell setupClassInfo:self.tableViewArray[indexPath.row]];
 
    if (self.type == RightClassViewType_create) {
        [cell setupCellType:CellType_create];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if (self.type == RightClassViewType_choose){
        
        [cell setupCellType:CellType_choose];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ClassManageModel * tempModel = self.tableViewArray[indexPath.row];
        
        if ([self.selectedArray containsObject:tempModel.clazzId]) {
            [cell setupChooseCellSelected:YES];
        }else{
           [cell setupChooseCellSelected:NO];
        }
    }else if(self.type == RightClassViewType_checkChoose){
       [cell setupCellType:CellType_checkChoose];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (void)setupTableViewData:(NSArray *)array  withGradName:(NSString *)gradeName{
    if (self.selectedArray) {
        [self.selectedArray removeAllObjects];
    }else{
    
        [self  initData];
    }
    self.gradeName = gradeName;
    self.tableViewArray = array;
    [self.tableView reloadData];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.type == RightClassViewType_choose) {

        ClassManageModel *model = self.tableViewArray[indexPath.row];
        
        
        if ([self.selectedArray containsObject:model.clazzId]) {
            [self.selectedArray removeObject:model.clazzId];
        }else{
            [self.selectedArray addObject:model.clazzId];
        }
        
        
        if ([self.rightDelegate respondsToSelector:@selector(chooseClassInfo:)]) {
        
            NSMutableArray * tempArray = [NSMutableArray array];
            for (int i = 0; i< [self.tableViewArray count]; i++) {
                
                ClassManageModel *tempModel = self.tableViewArray[i];
                if ([self.selectedArray containsObject:tempModel.clazzId ]) {
                     [tempArray addObject:tempModel ];
                }
                
            }
            
            [self.rightDelegate chooseClassInfo:@{self.gradeName:tempArray}];
        }
        
        [tableView reloadData];
    }else if(self.type == RightClassViewType_checkChoose){
    
         ClassManageModel *model = self.tableViewArray[indexPath.row];
        if ([self.rightDelegate respondsToSelector:@selector(checkChooseClassInfo:)]) {
            [self.rightDelegate checkChooseClassInfo:model];
        }
        
    }

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
