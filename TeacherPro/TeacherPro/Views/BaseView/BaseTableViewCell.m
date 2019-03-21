//
//  BaseTableViewCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/3.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
#pragma mark ---修改编辑状态时的选中图片
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    if (self.editing) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.textLabel.backgroundColor = [UIColor whiteColor];
        self.detailTextLabel.backgroundColor = [UIColor whiteColor];
    }
    [self resetEditImage];
    // Configure the view for the selected state
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self resetEditImage];
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{

     //修改cell高亮时显示的cell 子视图 默认背景颜色
    [self clearSysView];
//    [super setHighlighted:highlighted animated:animated];
    
}
- (void)layoutSubviews{
    
    [self resetEditImage];
    [super layoutSubviews];
}

- (void)resetEditImage{
    
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews){
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    
                    //                    img.frame = CGRectMake(img.frame.origin.x, CountHeight(20), img.frame.size.width, img.frame.size.height);
                    if (self.selected) {
                        img.image=[UIImage imageNamed:@"message_selected"];
                    }else{
                        img.image=[UIImage imageNamed:@"message_selected_normal"];
                    }
                }
            }
        }
    }
    [self clearSysView];
    
}

- (void)clearSysView{
    
   
    
}

@end
