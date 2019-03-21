//
//  TeacherRowCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/14.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "TeacherRowCell.h"
#import "SessionHelper.h"
#import "SessionModel.h"
#import "PublicDocuments.h"

typedef NS_ENUM(NSInteger ,TeacherRowType) {
    TeacherRowType_normal  = 0,
    TeacherRowType_adminMy        ,
    TeacherRowType_adminOther      ,
    TeacherRowType_MembersMy       ,
    TeacherRowType_MembersOther    ,
};

@interface TeacherRowCell()
@property(nonatomic, strong) IBOutlet UIButton * firstBtn;
@property(nonatomic, strong) IBOutlet UIButton * secondBtn;
@property(nonatomic, strong) IBOutlet UIButton * threeBtn;
@property(nonatomic, strong) IBOutlet UIButton * fourBtn;
@property(nonatomic, assign) TeacherRowType  type;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end
@implementation TeacherRowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.firstBtn.titleLabel.font = fontSize_13;
    self.secondBtn.titleLabel.font = fontSize_13;
    self.threeBtn.titleLabel.font = fontSize_13;
    self.fourBtn.titleLabel.font = fontSize_13;
    self.lineView.backgroundColor = UIColorFromRGB(0xefefef);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupCellInfo:(ClassDetailTeacherModel *)model withIsAdmin:(BOOL)isAdmin{
    
    
    BOOL isMy;
    NSString * teacherId;
    if ([[SessionHelper sharedInstance] checkSession]) {
        teacherId =  [[SessionHelper sharedInstance] getAppSession].teacherId ;
    }
    //检查当前cell 是否是显示的自己信息
    if ([teacherId isEqualToString:model.teacherId]) {
        isMy = YES;
       
    }else{
        isMy = NO;
 
    }
    
    
    if (isAdmin) {
        if (isMy) {
            //点击了是自己 是管理员
            [self setupCellType:TeacherRowType_adminMy];
        }else{
           //点击了自己不是管理员
            [self setupCellType:TeacherRowType_adminOther];
        }
        
    }else{
    
        if (isMy) {
            //点击了是自己 是管理员
            [self setupCellType:TeacherRowType_MembersMy];
        }else{
            //点击了自己不是管理员
            [self setupCellType:TeacherRowType_MembersOther];
        }
        
    }

}
-(void)setupCellType:(TeacherRowType)type{
    self.type = type;
    BOOL firstBtnShow =NO;
    BOOL secondBtnShow  =NO;
    BOOL threeBtnShow =NO;
    BOOL fourBtnShow =NO;
    if (self.type == TeacherRowType_adminMy) {

        [self.threeBtn setTitle:@"修改科目" forState:UIControlStateNormal];
        [self.fourBtn setTitle:@"解散班级" forState:UIControlStateNormal];
        
        firstBtnShow = NO;
        secondBtnShow = NO;
        threeBtnShow = YES;
        fourBtnShow = YES;
        
     
    }else if (self.type == TeacherRowType_adminOther) {

        [self.firstBtn setTitle:@"修改科目" forState:UIControlStateNormal];
        [self.secondBtn setTitle:@"设为管理员" forState:UIControlStateNormal];
        [self.threeBtn setTitle:@"踢出班级" forState:UIControlStateNormal];
        [self.fourBtn setTitle:@"发消息" forState:UIControlStateNormal];
        
        firstBtnShow = YES;
        secondBtnShow = YES;
        threeBtnShow = YES;
        fourBtnShow = YES;
    }else if (self.type == TeacherRowType_MembersMy) {
        

        
        [self.threeBtn setTitle:@"修改科目" forState:UIControlStateNormal];
        [self.fourBtn setTitle:@"退出班级" forState:UIControlStateNormal];
        firstBtnShow = NO;
        secondBtnShow = NO;
        threeBtnShow = YES;
        fourBtnShow = YES;
    }else if (self.type == TeacherRowType_MembersOther) {

        
        [self.fourBtn setTitle:@"发消息" forState:UIControlStateNormal];
        firstBtnShow = NO;
        secondBtnShow = NO;
        threeBtnShow = NO;
        fourBtnShow = YES;
    }
    
    [self setupButton:self.firstBtn withShowState:firstBtnShow];
    [self setupButton:self.secondBtn withShowState:secondBtnShow];
    [self setupButton:self.threeBtn withShowState:threeBtnShow];
    [self setupButton:self.fourBtn withShowState:fourBtnShow];
  
}

- (IBAction)firstAction:(id)sender {
    //修改科目
    [self changeCourse];
}
- (IBAction)secondAction:(id)sender {
    //设为管理员
    [self setupAdmin];
    
}
- (IBAction)threeAction:(id)sender {
    
    if (self.type == TeacherRowType_adminMy) {
      //修改科目
        [self changeCourse];
       
    }else if (self.type == TeacherRowType_adminOther) {
     //踢出班级
        [self kickedCourse];
    }else if (self.type == TeacherRowType_MembersMy) {
     //修改科目
        [self changeCourse];
    }
    
}
- (IBAction)fourAction:(id)sender {
    
    if (self.type == TeacherRowType_adminMy) {
        //解散班级
        [self dissolutionClasss];
        
    }else if (self.type == TeacherRowType_adminOther) {
        //发消息
        
         [self adminSendMessage];
        
    }else if (self.type == TeacherRowType_MembersMy) {
        //退出班级
        [self exitClass];
        
    }else if (self.type == TeacherRowType_MembersOther) {
       //发消息
        [self membersSendMessage];
        
    }
}
//管理员发送消息
- (void)adminSendMessage{
    
    if (self.touchBlock) {
        self.touchBlock(TeacherRowCellTouchType_AdminSendMessage,self.index);
    }
}
//普老师通发消息
- (void)membersSendMessage{
    if (self.touchBlock) {
        self.touchBlock(TeacherRowCellTouchType_MembersSendMessage,self.index);
    }
}


//退出班级

- (void)exitClass{

    if (self.touchBlock) {
        self.touchBlock(TeacherRowCellTouchType_ExitClass,self.index);
    }
}

//解散班级
- (void)dissolutionClasss{
    if (self.touchBlock) {
        self.touchBlock(TeacherRowCellTouchType_DissolutionClasss,self.index);
    }
}


//修改科目

- (void)changeCourse{
    if (self.touchBlock) {
        self.touchBlock(TeacherRowCellTouchType_ChangeCourse,self.index);
    }
}

//踢出班级

- (void)kickedCourse{
    if (self.touchBlock) {
        self.touchBlock(TeacherRowCellTouchType_KickedCourse,self.index);
    }
}

//设为管理员
-(void)setupAdmin{

    if (self.touchBlock) {
        self.touchBlock(TeacherRowCellTouchType_SetupAdmin,self.index);
    }
}

- (void)setupButton:(UIButton *)btn withShowState:(BOOL)isShow{

     UIColor * tempColor = [UIColor clearColor];
    if (isShow) {
        tempColor = project_main_blue;
        btn.layer.borderColor = tempColor.CGColor;
        
        btn.enabled = YES;
    }else{
       tempColor = [UIColor clearColor];
        btn.layer.borderColor = tempColor.CGColor;
        btn.enabled = NO;
        
    }
    [btn setTitleColor:tempColor forState:UIControlStateNormal];
    [btn setTitleColor:tempColor forState:UIControlStateSelected];
}
@end
