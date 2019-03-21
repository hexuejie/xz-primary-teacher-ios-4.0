//
//  CreateClassView.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "CreateClassView.h"
#import "LeftGradeView.h"
#import "RightClassView.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
#define rightBottomHeight           FITSCALE(50)
#define leftWith                    FITSCALE(100)
#define leftViewTag                 10001
#define rightViewTag                10002


@interface CreateClassView()<RightClassViewDelegate>
@property(nonatomic, strong) ClassManageListModel *listModel;
@property(nonatomic, assign) ClassViewFromType  fromType;
@end
@implementation CreateClassView

- (instancetype)initWithFrame:(CGRect)frame withType:(ClassViewFromType)fromType{

    if (self == [super initWithFrame: frame]) {
        self.fromType = fromType;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    
    self.backgroundColor = project_background_gray;
    UIImageView * bgImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, leftWith, self.frame.size.height)];
    
    
    bgImgV.image = [ProUtils getResizableImage:[UIImage imageNamed:@"left_bg"] withEdgeInset:UIEdgeInsetsMake(3, 10, 10, 0)];
    [self addSubview:bgImgV];
    bgImgV = nil;
    
    LeftGradeView * leftView = [[LeftGradeView alloc]initWithFrame:CGRectMake(0,0, leftWith, self.frame.size.height) style:UITableViewStylePlain];
    leftView.tag = leftViewTag;
    leftView.backgroundColor = [UIColor clearColor];
    leftView.gradeBlock = ^(NSString * gradeName){
    
        [self reloadRightView:gradeName];
    };
    [self addSubview:leftView];
    
     leftView = nil;
//    UIView *  separatorLine = [[UIView alloc]initWithFrame:CGRectMake(leftWith-0.5, 0, 1, self.frame.size.height)];
//    separatorLine.backgroundColor = UIColorFromRGB(0xF5F5F5);
//    [self addSubview:separatorLine];
    
    CGFloat  rightViewH = 0;
    RightClassViewType rightType = RightClassViewType_normal;
    if (self.fromType == ClassViewFromType_create) {
        rightViewH = self.frame.size.height - rightBottomHeight;
        rightType = RightClassViewType_create;
        [self setupRightBottomView];
    }else if(self.fromType == ClassViewFromType_choose){
        rightViewH = self.frame.size.height;
        rightType = RightClassViewType_choose;
    }else if (self.fromType == ClassViewFromType_checkChoose){
        rightViewH = self.frame.size.height;
        rightType = RightClassViewType_checkChoose;
        
    }
        
 
    RightClassView * rightView = [[RightClassView alloc]initWithFrame:CGRectMake(leftWith,0,self.frame.size.width- leftWith, rightViewH) style:UITableViewStylePlain withType:rightType];
    rightView.tag = rightViewTag;
    rightView.rightDelegate = self;
    [self addSubview:rightView];
    rightView = nil;
     rightView.backgroundColor = [UIColor clearColor];
  
    
    
}


- (void)setupRightBottomView{

    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(leftWith, self.frame.size.height - rightBottomHeight, self.frame.size.width- leftWith -10 , rightBottomHeight)];
    [bottomView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:bottomView];
    
    
    UIButton * createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [createBtn  setFrame:CGRectMake(10, 5, bottomView.frame.size.width- 20, rightBottomHeight-10 )];
    [createBtn setTitle:@"创建班级" forState:UIControlStateNormal];
    createBtn.titleLabel.font = fontSize_15;
    [createBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [createBtn setImage:[UIImage imageNamed:@"class_manage_create"] forState:UIControlStateNormal];
    [createBtn setImage:[UIImage imageNamed:@"class_manage_create"] forState:UIControlStateHighlighted];
    [createBtn setImage:[UIImage imageNamed:@"class_manage_create"] forState:UIControlStateSelected];
    [createBtn setBackgroundColor:project_main_blue];
    createBtn.layer.borderWidth = 1;
    createBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    createBtn.layer.borderColor = project_main_blue.CGColor;
    createBtn.layer.masksToBounds = YES;
    createBtn.layer.cornerRadius = (rightBottomHeight-10)/2;
    [createBtn addTarget:self action:@selector(createAction) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:createBtn];
    
    bottomView = nil;
}
- (void)createAction{


    
    if (self.createBlock) {
        self.createBlock(self.gradeName);
    }

}
- (void)reloadData:(ClassManageListModel *)listModel{
 
    NSDictionary * selectedInfo = [[NSUserDefaults standardUserDefaults] objectForKey:SAVE_RELEASEHOMEWORKCLASS ];
    
    
    if (selectedInfo) {
        self.gradeName = [selectedInfo allKeys][0];
    }else{
        if ([listModel.clazzList count]>0) {
            //默认显示返回数据第一个的年级 班级数据
            ClassManageModel * classModel  = listModel.clazzList[0];
            self.gradeName = classModel.gradeName;
        }
        
    }
   
    self.listModel = listModel;
    [self reloadRightView:self.gradeName];
    [self reloadLeftView:listModel];
    
}

- (void)reloadRightView:(NSString *)gradeName{
    self.gradeName = gradeName;
    NSMutableArray *tempClassArray = [[NSMutableArray alloc]init];
    
    for (ClassManageModel* model in self.listModel.clazzList) {
        if ([model.gradeName isEqualToString: gradeName]) {
            [tempClassArray addObject:model];
        }
    }
    
    RightClassView * classView = [self viewWithTag:rightViewTag];
    [classView setupTableViewData:tempClassArray withGradName:gradeName];
}

- (void)reloadLeftView:(ClassManageListModel *)listModel{
    
    NSMutableDictionary *tempClassDic = [[NSMutableDictionary alloc]init];
    
  
  NSString *adminKey =  @"admin";
    NSString *noAdminKey = @"noadmin";
    for (ClassManageModel* model in self.listModel.clazzList) {
        
        
        if ( tempClassDic[model.gradeName]) {
           
            if ([model.adminTeacher integerValue] == 1 ) {
                if (tempClassDic[model.gradeName][adminKey]) {
                    NSString * number = tempClassDic[model.gradeName][adminKey];
                    NSString * numberStr = [NSString stringWithFormat:@"%zd",[number integerValue] + 1];
                     [tempClassDic[model.gradeName]   setObject:numberStr forKey: adminKey];
                }else{
                    [tempClassDic[model.gradeName] setObject:@"1" forKey:adminKey];
                   
              
                }
               
            }else{
                if (tempClassDic[model.gradeName][noAdminKey]) {
                    NSString * number = tempClassDic[model.gradeName][noAdminKey];
                    NSString * numberStr = [NSString stringWithFormat:@"%zd",[number integerValue] + 1];
                    [tempClassDic[model.gradeName] setObject:numberStr forKey: noAdminKey];
                }else{
                 
                   [tempClassDic[model.gradeName] setObject:@"1" forKey:noAdminKey];
                    
                }
                
                
               
            }
            
           
            
        }else{
         
            NSString * numberStr = [NSString stringWithFormat:@"%zd",1];
            NSDictionary * classNumberDic;
            if ([model.adminTeacher integerValue] == 1 ) {
                classNumberDic = @{adminKey: numberStr};
               
            }else{
                classNumberDic = @{noAdminKey: numberStr};
               
            }
            
            [tempClassDic setObject:[NSMutableDictionary dictionaryWithDictionary:classNumberDic] forKey:model.gradeName];
            
        }
        
        
       
       
    }
    
    LeftGradeView * leftView = [self viewWithTag:leftViewTag];
    
    [leftView setupSelectedGrade:self.gradeName dataInfo:tempClassDic];
    
}

- (void)chooseClassInfo:(NSDictionary *)info{

    if (self.chooseBlock) {
        self.chooseBlock(info);
    }
}
- (void)checkChooseClassInfo:(ClassManageModel *)model{

    if (self.checkChooseBlock) {
        self.checkChooseBlock (model);
    }
}
- (void)dealloc{

    [self setChooseBlock:nil];
    [self setGradeName:nil];
    [self setListModel:nil];
    
}
@end
