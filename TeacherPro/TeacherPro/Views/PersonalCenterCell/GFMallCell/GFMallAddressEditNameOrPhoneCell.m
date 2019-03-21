//
//  GFMallAddressEditNameOrPhoneCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "GFMallAddressEditNameOrPhoneCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"

@interface GFMallAddressEditNameOrPhoneCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITextField *textFeild;

@end
@implementation GFMallAddressEditNameOrPhoneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}

- (void)setupSubView{
   
    self.title.font = fontSize_14;
    self.textFeild.font = fontSize_14;
    self.title.textColor = UIColorFromRGB(0x000000);
    self.textFeild.textColor = UIColorFromRGB(0x6b6b6b);
    self.textFeild.delegate = self;
    [self.textFeild addTarget:self action:@selector(changeTextField:) forControlEvents:UIControlEventEditingChanged];
}
- (void)changeTextField:(UITextField *)textField{
    if (self.indexPath.row == 0) {
         [ProUtils confineTextFieldEditChanged:textField withlength:7];
   
    }else if (self.indexPath.row == 1){
          [ProUtils phoneTextFieldEditChanged:textField];
    }
    if (self.inputBlock) {
        self.inputBlock(textField.text);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupTitle:(NSString *)title withPlaceholder:(NSString *)placeholder{
    self.title.text = title;
    self.textFeild.placeholder = placeholder;
    if (self.indexPath.row == 1) {
        self.textFeild.keyboardType = UIKeyboardTypePhonePad;
    }
}
- (void)setupContent:(NSString *)contentStr{
    if (contentStr) {
         self.textFeild.text =  contentStr;
    }
}
@end
