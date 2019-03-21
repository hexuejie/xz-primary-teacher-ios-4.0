//
//  BaseMessageListViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/3.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseMessageTypeListViewController.h"
#import "ProUtils.h"


@interface BaseMessageTypeListViewController ()

@end

@implementation BaseMessageTypeListViewController

- (void)viewDidLoad {
    self.currentPageNo = 0;
    self.pageCount = 100;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupRightItem];
    [self initBottomView];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
  [self navUIBarBackground:0];
}



- (void)setupRightItem{
    NSString * titleNormal = @"编辑";
    NSString * titleSelected = @"取消";
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:titleNormal forState:UIControlStateNormal];
    [rightBtn setTitle:titleSelected forState:UIControlStateSelected];
    [rightBtn setFrame:CGRectMake(0, 0,FITSCALE(40), 44)];
    rightBtn.titleLabel.font = fontSize_14;
    [rightBtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
}

- (void)initBottomView{
    
    CGFloat buttonW = (self.view.frame.size.width - 30)/2;
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)- bottomHeight, CGRectGetWidth(self.view.frame), bottomHeight)];
    bottomView.backgroundColor = [UIColor clearColor];
    bottomView.tag = bottomTag;
    
    bottomView.hidden = YES;
    UIImageView * topLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 1)];
    topLine.backgroundColor = project_line_gray;
    [bottomView addSubview:topLine];
    
    NSString * allChooseBtnTitle = @"全选";
    NSString * allChooseBtnTitleSelelcted = @"取消";
    UIButton * allChooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [allChooseBtn setTitle:allChooseBtnTitle forState:UIControlStateNormal];
    [allChooseBtn setTitle:allChooseBtnTitleSelelcted forState:UIControlStateSelected];
    allChooseBtn.titleLabel.font = fontSize_14;
    allChooseBtn.selected = NO;
    allChooseBtn.tag = AllButtonTag;
    [allChooseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [allChooseBtn setBackgroundImage:[ProUtils createImageWithColor:project_main_blue withFrame:CGRectMake(0, 0, 1, 1)] forState:UIControlStateNormal];
    [allChooseBtn addTarget:self action:@selector(allChooseAction:) forControlEvents:UIControlEventTouchUpInside];
    [allChooseBtn setFrame:CGRectMake(10, 10,buttonW,bottomHeight -20)];
    allChooseBtn.layer.cornerRadius = allChooseBtn.frame.size.height/2;
    allChooseBtn.layer.masksToBounds = YES;
    [bottomView addSubview:allChooseBtn];
    
    
    NSString * deleteBtnTitle = @"删除";
    UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setTitle:deleteBtnTitle forState:UIControlStateNormal];
    deleteBtn.titleLabel.font =  [UIFont systemFontOfSize:16.5];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteBtn setBackgroundImage:[ProUtils createImageWithColor:UIColorFromRGB(0xF54667) withFrame:CGRectMake(0, 0, 1, 1)] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setFrame:CGRectMake(buttonW + 20, 10, buttonW,bottomHeight -20)];
    deleteBtn.layer.cornerRadius = deleteBtn.frame.size.height/2;
    deleteBtn.layer.masksToBounds = YES;
    [bottomView addSubview:deleteBtn];
    
    [self.view addSubview:bottomView];
}

- (void)rightAction:(UIButton *)button{
    
    button.selected = !button.selected;
    CGRect  tableFrame = CGRectZero;
    
    if (button.selected) {
         tableFrame = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height - bottomHeight);
    }else{
         tableFrame = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height +   bottomHeight);
    }
    //添加这种模式 有一个bug 滑动 修改的图片不嫩正常显示
    //     self.tableView.allowsMultipleSelectionDuringEditing
    [self changeTableViewFrame:tableFrame];
    [self.view viewWithTag:bottomTag].hidden = !button.selected;
    self.tableView.editing = button.selected;
    UIButton * allBtn = [[self.view viewWithTag:bottomTag] viewWithTag:AllButtonTag];
    [self.selectedIndexArray removeAllObjects];
    allBtn.selected = NO;
    [self updateTableView];
    
}

- (void)exitEdit{

    //退出编辑状态
    self.tableView.editing = NO;
    ((UIButton *)self.navigationItem.rightBarButtonItem.customView ).selected = NO;
    [self.view viewWithTag:bottomTag].hidden = YES;
    CGRect  tableFrame = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height +   bottomHeight);
     [self changeTableViewFrame:tableFrame];
}


- (void)changeTableViewFrame:(CGRect)frame{
    
    self.tableView.frame = frame;
}
- (NSMutableArray *)selectedIndexArray{
    
    if (!_selectedIndexArray) {
        _selectedIndexArray = [NSMutableArray array];
    }
    return _selectedIndexArray;
}
- (void)allChooseAction:(UIButton *)button{
    button.selected = !button.selected;
    
    for (int i = 0;i<[[self getListArray] count] ;i++) {
        
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
        
        if (![self.selectedIndexArray containsObject:indexPath] && button.selected  ) {
            [self.selectedIndexArray addObject: indexPath];
            
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        
        if ([self.selectedIndexArray containsObject:indexPath] && !button.selected) {
            [self.selectedIndexArray removeObject: indexPath];
            
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES  ];
        }
        
    }
    
}
- (void)deleteAction:(id)sender{
    
    if ([self.selectedIndexArray count] == 0) {
        NSString * content = @"请选择需要删除的消息";
        [self showAlert:TNOperationState_Normal content:content];
    }else{
        [self deleteMessage];
    }
}

- (NSArray *)getListArray{
 
    return nil;
}

- (void) deleteMessage{

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //选中数据
    if (![self.selectedIndexArray containsObject:indexPath]) {
        [self.selectedIndexArray addObject:indexPath];
    }
    
    if ([self.selectedIndexArray count] == [[self getListArray] count]) {
        UIButton * allBtn  =[[self.view viewWithTag:bottomTag] viewWithTag:AllButtonTag];
        [allBtn setSelected:YES];
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    //从选中中取消
    if ([self.selectedIndexArray containsObject:indexPath]) {
       [self.selectedIndexArray removeObject:indexPath];
    }
    
    if ([self.selectedIndexArray count] != [[self getListArray] count]){
        
        UIButton * allBtn  =[[self.view viewWithTag:bottomTag] viewWithTag:AllButtonTag];
        [allBtn setSelected:NO];
    }
}


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
}
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
 
    //cell.contentView.backgroundColor = [UIColor greenColor];
}
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
 
    //cell.contentView.backgroundColor = [UIColor grayColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)isAddRefreshHeader{
    
    return YES;
}

- (BOOL)isAddRefreshFooter{
    
    return NO;
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
