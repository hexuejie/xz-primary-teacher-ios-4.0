//
//  MyManageClassTableViewCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "MyManageClassTableViewCell.h"
#import "PublicDocuments.h"
#import "Masonry.h"

@interface MyManageClassTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *className;
@property (weak, nonatomic) IBOutlet UILabel *classStu;
@property (weak, nonatomic) IBOutlet UILabel *classTeacher;

@property (weak, nonatomic) IBOutlet UIImageView *cellSelectedStateImgv;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgV;

@end
@implementation MyManageClassTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.className.font = fontSize_15;
    self.classStu.font = fontSize_13;
    self.classTeacher.font = fontSize_13;
    self.className.textColor = UIColorFromRGB(0x818181);
    self.classStu.textColor = UIColorFromRGB(0x818181);
    self.classTeacher.textColor = UIColorFromRGB(0x818181);

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


- (void)setupCellInfo:(ClassManageModel *) info  {

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
   
    
    self.classTeacher.attributedText = [self setAttributedText:classTea withColor:colorTea  withRange:range];
    
   
    
}


- (NSAttributedString *)setAttributedText:(NSString *)text withColor:(UIColor *)color withRange:(NSRange )range{
    
    NSMutableAttributedString *Attributed  = [[NSMutableAttributedString alloc]initWithString:text];
    
    
    
    
    [Attributed addAttribute:NSForegroundColorAttributeName
     
                       value:color
     
                       range:range];
    return Attributed;
}


- (void)setupCellSelected:(MyManageClassType )type{

    NSString * imageName = @"" ;
    if (type == MyManageClassType_normal) {
        imageName = @"class_btn_no_selected";
        
    }else if (type == MyManageClassType_Selected) {
        imageName = @"class_btn_selected";
        
    }
    else if (type == MyManageClassType_ban) {
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
