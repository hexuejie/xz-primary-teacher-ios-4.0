
//
//  StudentRowCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/14.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//


#import "StudentRowCell.h"
#import "ClassDetailStudentModel.h"
#import "PublicDocuments.h"
typedef NS_ENUM(NSInteger ,StudentRowCellRowType) {
    StudentRowCellRowType_normal        = 0,
    StudentRowCellRowType_AdminMy          ,
    StudentRowCellRowType_MembersMy        ,
    
};
@interface StudentRowCell()
@property(nonatomic, strong) IBOutlet UIButton * firstBtn;
@property(nonatomic, strong) IBOutlet UIButton * secondBtn;
@property(nonatomic, strong) IBOutlet UIButton * threeBtn;
@property(nonatomic, assign)  BOOL  isAdmin;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@end
@implementation StudentRowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.firstBtn.titleLabel.font = fontSize_13;
    self.secondBtn.titleLabel.font = fontSize_13;
    self.threeBtn.titleLabel.font = fontSize_13;
    self.lineView.backgroundColor = UIColorFromRGB(0xefefef);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupCellIsAdmin:(BOOL)isAdmin{
    self.isAdmin = isAdmin;
    if (isAdmin) {
        self.firstBtn.hidden =NO;
        self.secondBtn.hidden = NO;
        self.threeBtn.hidden = NO;
        [self.firstBtn setTitle:@"发送消息" forState:UIControlStateNormal];
        [self.secondBtn setTitle:@"学生详情" forState:UIControlStateNormal];
        [self.threeBtn setTitle:@"踢出班级" forState:UIControlStateNormal];
     
    } else {
        self.firstBtn.hidden =YES;
        self.secondBtn.hidden = NO;
        self.threeBtn.hidden = NO;
 
    
        [self.secondBtn setTitle:@"发送消息" forState:UIControlStateNormal];
        [self.threeBtn setTitle:@"学生详情" forState:UIControlStateNormal];
 
    }
}
- (IBAction)firstAction:(id)sender {
  
    //管理员 发送消息
    if (self.touchBlock) {
        self.touchBlock(StudentRowCellTouchType_AdminSendMessage,self.index);
    }
}
- (IBAction)secondAction:(id)sender {
  
    if (self.isAdmin) {
      //学生详情
        if (self.touchBlock) {
            self.touchBlock(StudentRowCellTouchType_Info,self.index);
        }
    }else{
    
        //普通老师 发送消息
        if (self.touchBlock) {
            self.touchBlock(StudentRowCellTouchType_MembersSendMessage,self.index);
        }
    }
    
}
- (IBAction)threeAction:(id)sender {
    if (self.isAdmin) {
        //踢出班级
        if (self.touchBlock) {
            self.touchBlock(StudentRowCellTouchType_KickedClass,self.index);
        }
    }else{
       //学生详情
        if (self.touchBlock) {
            self.touchBlock(StudentRowCellTouchType_Info,self.index);
        }
    }
   
}

-(void)layoutSubviews
{
    
    [self clearSysImage];
    [super layoutSubviews];
}

- (UIImage*) createImageWithColor: (UIColor*) color withFrame:(CGRect)rect
{
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)clearSysImage{
    
    
    for (UIControl *control in self.subviews){
        if (![control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            control.backgroundColor = [UIColor clearColor];
        }
        
    }
}

@end
