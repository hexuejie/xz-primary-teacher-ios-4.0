//
//  ReleaseCopyEditorViewCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/13.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ReleaseCopyEditorViewCell.h"
#import "TTextView.h"
#import "PublicDocuments.h"

#define   maxlimit    @"1000"
@interface ReleaseCopyEditorViewCell()
@property (weak, nonatomic) IBOutlet TTextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@end


@implementation ReleaseCopyEditorViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self configView];
  
}

- (void)setupCopyEditor:(NSString *)inputText{
    self.textView.text = inputText;
}
- (void)configView{
//    self.textView.font = fontSize_15;
    self.textView.textColor = UIColorFromRGB(0x4D4D4D);
    self.textView.placeholderColor = UIColorFromRGB(0xb3b3b3);
    self.limitLabel.text = [NSString stringWithFormat:@"%zd/%@",0, maxlimit];
//    self.limitLabel.textColor = UIColorFromRGB(0xb3b3b3);
    self.limitLabel.backgroundColor = [UIColor clearColor];
    
    self.textView.maxLength =  [maxlimit integerValue];
    
    
    WEAKSELF
    [self.textView addTextDidChangeHandler:^(TTextView *textView) {
        STRONGSELF
        strongSelf.limitLabel.text = [NSString stringWithFormat:@"%zd/%@",textView.text.length, maxlimit];

        NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:strongSelf.limitLabel.text];
        NSRange redRange = NSMakeRange([strongSelf.limitLabel.text rangeOfString:@"/1000"].location,[strongSelf.limitLabel.text rangeOfString:@"/1000"].length);
        //修改特定字符的颜色
        [attrDescribeStr addAttribute:NSForegroundColorAttributeName value:HexRGB(0xB3B3B3) range:redRange];
        strongSelf.limitLabel.attributedText = attrDescribeStr;
        
        
        NSMutableArray * tempArray = [[NSMutableArray alloc]init];
        if ([textView.text containsString:@"\n"]) {
            NSArray * array = [textView.text  componentsSeparatedByString:@"\n"];
            for (NSString * text in array) {
                if (text.length >0) {
                    [tempArray addObject:text];
                }
                
            } ;
        }else{
            if (textView.text.length >0) {
                [tempArray addObject:textView.text];
            }
            
        }
        
        if (strongSelf.inputBlock  ) {
            strongSelf.inputBlock(tempArray);
        }
    }];
}

@end
