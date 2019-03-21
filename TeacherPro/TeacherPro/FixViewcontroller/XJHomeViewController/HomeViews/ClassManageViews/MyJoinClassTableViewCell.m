//
//  MyJoinClassTableViewCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "MyJoinClassTableViewCell.h"
#import "PublicDocuments.h"
#import "Masonry.h"
@interface MyJoinClassTableViewCell()
//班级名字
@property (weak, nonatomic) IBOutlet UILabel *className;
//管理员名字
@property (weak, nonatomic) IBOutlet UILabel *administratorName;
//管理员号码
@property (weak, nonatomic) IBOutlet UILabel *administratorPone;
//学生数
@property (weak, nonatomic) IBOutlet UILabel *classStu;
//教师数
@property (weak, nonatomic) IBOutlet UILabel *classTea;

@property (weak, nonatomic) IBOutlet UIImageView *cellSelectedStateImgv;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgV;
@end
@implementation MyJoinClassTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.className.font = fontSize_15;
    self.classStu.font = fontSize_13;
    self.classTea.font = fontSize_13;
    self.administratorName.font = fontSize_13;
    self.administratorPone.font = fontSize_13;
    self.lineView.backgroundColor = UIColorFromRGB(0xEBEBEB);
    self.className.textColor = UIColorFromRGB(0x818181);
    self.classStu.textColor = UIColorFromRGB(0x818181);
    self.classTea.textColor = UIColorFromRGB(0x818181);
    self.administratorName.textColor = UIColorFromRGB(0x818181);
    self.administratorPone.textColor = UIColorFromRGB(0xB0B0B0);
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor clearColor];
        UIView *backGroundView = [[UIView alloc]init];
        backGroundView.backgroundColor = [UIColor clearColor];
        self.selectedBackgroundView = backGroundView;
        //以下自定义控件
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

 


- (void)setupCellInfo:(ClassManageModel *) info{
    
    self.className.text = [NSString stringWithFormat:@"%@ %@", info.gradeName,info.clazzName ];
    
    NSString * classStu = [NSString stringWithFormat:@"学生%@名",info.studentCount ];
 
    
    UIColor * color ;
    if ([info.studentCount integerValue] >0) {
        color =  project_main_blue;
    }else{
        
        color = [UIColor redColor];
    }
    
  
 
    
    NSRange rangeStu= [classStu  rangeOfString:[NSString stringWithFormat:@"%@",info.studentCount]];
    self.classStu.attributedText = [self setAttributedText:classStu withColor:color withRange:rangeStu];
    
    
    NSString * classTea = [NSString stringWithFormat:@"教师%@名",info.teacherCount ];
     UIColor * colorTea ;
    if ([info.teacherCount integerValue] >0) {
        colorTea =  project_main_blue;
    }else{
        
        colorTea = [UIColor redColor];
    }
    
    NSRange range= [classTea  rangeOfString:[NSString stringWithFormat:@"%@",info.teacherCount]];
    
    // NSMakeRange(2,  text.length - 3)
    
    
    self.classTea.attributedText = [self setAttributedText:classTea withColor:colorTea  withRange:range];

    NSString * administaratorName = @"无管理员";
    if (info.adminName.length >0) {
        administaratorName =[NSString stringWithFormat:@"管理员:%@",info.adminName] ;
    }
     self.administratorName.text = administaratorName ;
    
    NSString *tel =@"";
    if ([info.adminPhone length]>=11) {
           tel = [NSString stringWithFormat:@"(%@)",[info.adminPhone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]];
    }else{
        tel = @"";
    }
    
    self.administratorPone.text = tel;
}

- (NSAttributedString *)setAttributedText:(NSString *)text withColor:(UIColor *)color withRange:(NSRange )range{
    
    NSMutableAttributedString *Attributed  = [[NSMutableAttributedString alloc]initWithString:text];
    
    
    
    
    [Attributed addAttribute:NSForegroundColorAttributeName
     
                       value:color
     
                       range:range];
    return Attributed;
}


- (void)setupCellSelected:(MyJoinClassCellType )type{
    
    NSString * imageName = @"" ;
    if (type == MyJoinClassCellType_normal) {
        imageName = @"class_btn_no_selected";
        
    }else if (type ==  MyJoinClassCellType_Selected) {
        imageName = @"class_btn_selected";
        
    }
    else if (type ==  MyJoinClassCellType_ban) {
        imageName = @"class_stop_selected";
        
    }
    self.cellSelectedStateImgv.image = [UIImage imageNamed:imageName];
}

- (void)setupTableviewCellEdit:(BOOL)edit{
    
    if (edit) {
        
        CGFloat offset= 10 *scale_x;
        [self.arrowImgV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo([self.contentView superview].mas_trailing).offset(offset );
        }];
        
    }else{
        CGFloat offset= -20 *scale_x;
        [self.arrowImgV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo([self.contentView superview].mas_trailing).offset(offset);
        }];
    }
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
//自定义 tableviewcell  重写 willTransitionToState 这个方法 能修改编辑 左侧按钮 图片
- (void)willTransitionToState:(UITableViewCellStateMask)state{

    [super willTransitionToState:state];
   
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
      [self clearSysImage];
    
}

-(void)layoutSubviews
{
    [self clearSysImage];
    [super layoutSubviews];
}

- (void)clearSysImage{
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    if (self.selected) {
                        img.image= [self createImageWithColor:[UIColor clearColor] withFrame:CGRectZero];
                    }else
                    {
                        img.image= [self createImageWithColor:[UIColor clearColor] withFrame:CGRectZero];
                    }
                }
            }
        }
    }
    
}
@end
