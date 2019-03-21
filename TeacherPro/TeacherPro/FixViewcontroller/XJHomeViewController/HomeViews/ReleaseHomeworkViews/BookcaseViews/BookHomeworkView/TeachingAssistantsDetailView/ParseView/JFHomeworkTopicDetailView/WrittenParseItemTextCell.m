//
//  WrittenParseItemTextCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/11/8.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "WrittenParseItemTextCell.h"
#import "PublicDocuments.h"
#import "TTextView.h"
#define   kmaxlimit    @"1000"
@interface WrittenParseItemTextCell()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet TTextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *inputNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *tvBgView;

@end
@implementation WrittenParseItemTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{
     
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self configView];
}
- (void)setupText:(NSString *)text{
    if (text) {
        self.textView.text = text;
    }
}
- (void)configView{
    self.textView.font = fontSize_14;
    self.textView.placeholder =  @"请您输入试题解析文字内容";
    self.textView.textColor = UIColorFromRGB(0x6b6b6b);
    self.textView.placeholderColor = UIColorFromRGB(0xc3c3c3);
    self.inputNumberLabel.text = [NSString stringWithFormat:@"%zd/%@",0, kmaxlimit];
    self.inputNumberLabel.textColor = UIColorFromRGB(0xc3c3c3);
    self.inputNumberLabel.backgroundColor = [UIColor clearColor];
    self.textView.maxLength =  [kmaxlimit integerValue];
 
    
    WEAKSELF
    [self.textView addTextDidChangeHandler:^(TTextView *textView) {
        STRONGSELF
        strongSelf.inputNumberLabel.text = [NSString stringWithFormat:@"%zd/%@",textView.text.length, kmaxlimit];
        if (self.inputTextBlock) {
            self.inputTextBlock(textView.text);
        }
      
    }];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
