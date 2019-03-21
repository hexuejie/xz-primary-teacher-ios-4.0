//
//  ModifyUserCell.m
//  AplusKidsMasterPro
//
//  Created by neon on 16/5/6.
//  Copyright © 2016年 neon. All rights reserved.
//

#import "ModifyUserCell.h"
#import "PublicDocuments.h"
#import "Masonry.h"
#import "AlertView.h"
#import "PublicDocuments.h"
#import "ProUtils.h"

@interface ModifyUserCell()
@property (weak, nonatomic) IBOutlet UIView *bottomLineV;

@end
@implementation ModifyUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.font = fontSize_14;
    self.contentInput.font = fontSize_14;
    self.modifyBtn.titleLabel.font = fontSize_14;
    [self.contentInput setEnabled:NO];
//    [self.modifyBtn setHidden:YES];

    [self.modifyBtn setTitle:@"修改" forState:UIControlStateNormal];
    [self.modifyBtn addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(FITSCALE(2));
        make.right.mas_equalTo(self.modifyBtn.mas_left).offset(FITSCALE(-10));
    }];
    [self.contentInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.bottomLineV.backgroundColor = project_line_gray;
   
    
 
}


- (void) textFieldDidChange:(UITextField *)textField
{
    NSInteger kMaxLength = 5;
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; //ios7之前使用[UITextInputMode currentInputMode].primaryLanguage
    if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
                 [ProUtils shake:textField];
            }
//             NSLog(@"没有高亮选择的字，则对已输入的文字进行字数统计和限制");
        }
        else{//有高亮选择的字符串，则暂不对文字进行统计和限制
//            NSLog(@"有高亮选择的字符串，则暂不对文字进行统计和限制");
        }
        
        
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
}





//- (void)changeTextField:(UITextField *)textField{
//     NSString *toBeString = textField.text;
//    //获取高亮部分
//    UITextRange *selectedRange = [textField markedTextRange];
//    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
//   NSInteger MAX_STARWORDS_LENGTH = 5;
//    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
//    if (!position)
//    {
//        if (toBeString.length > MAX_STARWORDS_LENGTH)
//        {
//            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
//            if (rangeIndex.length == 1)
//            {
//                textField.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
//            }
//            else
//            {
//                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_STARWORDS_LENGTH)];
//                textField.text = [toBeString substringWithRange:rangeRange];
//            }
//        }
//    }
// 
////    if (textField.text.length > 5) {
////        NSString * content = @"老师的姓名最多为五个字";
////     
////        NSArray* items =@[MMItemMake(@"确定", MMItemTypeHighlight, nil)];
////        [[[AlertView  alloc]initWithOperationState:TNOperationState_Unknow detail:content items:items
////          ] show];
////        textField.text = [textField.text substringToIndex:5];
////        
////    }
//    
//}


- (void)changeAction:(UIButton *)sender{

    if (self.changeBlock) {
        self.changeBlock(self.indexPath, self.contentInput,self.modifyBtn);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
