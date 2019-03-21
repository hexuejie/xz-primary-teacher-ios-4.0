//
//      ┏┛ ┻━━━━━┛ ┻┓
//      ┃　　　　　　 ┃
//      ┃　　　━　　　┃
//      ┃　┳┛　  ┗┳　┃
//      ┃　　　　　　 ┃
//      ┃　　　┻　　　┃
//      ┃　　　　　　 ┃
//      ┗━┓　　　┏━━━┛
//        ┃　　　┃   神兽保佑
//        ┃　　　┃   代码无BUG！
//        ┃　　　┗━━━━━━━━━┓
//        ┃　　　　　　　    ┣┓
//        ┃　　　　         ┏┛
//        ┗━┓ ┓ ┏━━━┳ ┓ ┏━┛
//          ┃ ┫ ┫   ┃ ┫ ┫
//          ┗━┻━┛   ┗━┻━┛
//
//  JoinClassSearchView.m
//  TeacherPro
//
//  Created by DCQ on 2017/8/3.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "JoinClassSearchView.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
#import "IQKeyboardManager.h"
#import "IQUIView+IQKeyboardToolbar.h"

@interface JoinClassSearchView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *textFieldBg;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@end
@implementation JoinClassSearchView

- (void)awakeFromNib{
  [super awakeFromNib];
    [self setupSubView];
}

- (void)setupSubView{

    self.textField.textColor = UIColorFromRGB(0x898989);
   
    self.textField.font = fontSize_14;
    [self.textField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    self.textField.delegate = self;
    self.textField.backgroundColor = [UIColor clearColor];
    self.textFieldBg.backgroundColor = UIColorFromRGB(0xe8e8e8);
    self.searchBtn.titleLabel.font = fontSize_14;
    
   //自定义 完成按钮事件
    [self.textField addDoneOnKeyboardWithTarget:self action:@selector(doneAction:) ];
    
}

- (void)doneAction:(id)sender{

    [self searchAction:nil];
}

#pragma mark - Notification Method
-(void)textFieldEditChanged:(UITextField *)textField
{
    
    [ProUtils phoneTextFieldEditChanged:textField];
    
//    if (self.inputPhoneBlock) {
//        self.inputPhoneBlock(textField.text);
//    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   
       return YES;
}

- (IBAction)searchAction:(id)sender {
    
    if ([self.textField.text length] <= 0) {
    
        [ProUtils shake:self.textField];
        
    }else{
    
        if(self.searchBlock){
            
            self.searchBlock(self.textField.text);
        }
    }

}

//- (void)becomeFirstResponder{
//    
//    [self.textField becomeFirstResponder];
//}

@end
