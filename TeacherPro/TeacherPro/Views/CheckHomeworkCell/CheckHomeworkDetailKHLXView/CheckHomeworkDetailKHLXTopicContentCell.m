//
//  CheckHomeworkDetailKHLXTopicContentCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/2/1.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "CheckHomeworkDetailKHLXTopicContentCell.h"
#import "HomeworkDetailKHLXListModel.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
@interface CheckHomeworkDetailKHLXTopicContentCell ()
@property (weak, nonatomic) IBOutlet UILabel *topicTitle;
@property (weak, nonatomic) IBOutlet UILabel *topicOptionLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *bottomTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomLineV;
@property (weak, nonatomic) IBOutlet UIView *spacingView;

@end
@implementation CheckHomeworkDetailKHLXTopicContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}
- (void)setupSubview{
    
    self.bottomLineV.backgroundColor = project_line_gray;
    self.spacingView.backgroundColor = project_background_gray;
    self.bottomTitleLabel.textColor = UIColorFromRGB(0xC1C1C1);
    self.bottomTitleLabel.font = fontSize_14;
    [self.bottomBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)buttonAction:(UIButton *)btn{
    
    if (self.buttonBlock) {
        self.buttonBlock(self.indexPath);
    }
}
- (void)setupTopicModel:(HomeworkDetailKHLXQuestionsModel *) model{
    
    if (model.options) {
        NSArray * allkeys = model.options.allKeys;
        NSArray *sortedArray = [allkeys sortedArrayUsingFunction:khlxSort context:NULL];
        __block NSString * options =@"";
        NSMutableAttributedString *attributedText=  [[NSMutableAttributedString alloc]init];
        [sortedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString * tempStr = [NSString stringWithFormat:@"<br><br>%@.%@ ",obj,model.options[obj]];
            options = [options stringByAppendingString:tempStr];
            
        }];
 
        
        [attributedText appendAttributedString:[ProUtils strToAttriWithStr: options]];
        
        [attributedText addAttribute:NSFontAttributeName value:fontSize_14 range:NSMakeRange(0, attributedText.length)];
        self.topicOptionLabel.attributedText = attributedText;
        
    }else{
        
         self.topicOptionLabel.text = @"";
    }
    if (model.questionStem) {
        NSMutableAttributedString *attributedText=  [[NSMutableAttributedString alloc]initWithAttributedString:[ProUtils strToAttriWithStr: model.questionStem]];
        [attributedText addAttribute:NSFontAttributeName value:fontSize_14 range:NSMakeRange(0, attributedText.length)];
        
        self.topicTitle.attributedText = attributedText ;
        
        
    }else{
        
       self.topicTitle.text = @"";
    }
    NSString * questionTypeName = @"";
    if (model.questionTypeName) {
        questionTypeName = model.questionTypeName;
    }
    NSString * difficultyName = @"";
    if (model.difficultyName) {
        difficultyName =   model.difficultyName;
    }
    NSNumber * userNumber = @(0);
    if (model.useCount) {
        userNumber = model.useCount;
    }
    NSString * bottomText = [questionTypeName stringByAppendingString:[NSString stringWithFormat:@"  %@ 被使用%@次",difficultyName,userNumber]];
    self.bottomTitleLabel.text = bottomText;
    
    NSString * btnImgIcon = @"";
    NSString * btnTitle = @"";
    UIColor * btnColor = nil;
    if (model.errorStudentCount ) {
        if ([model.errorStudentCount integerValue] >0) {
            //做错
            btnTitle = [NSString stringWithFormat:@"答错%@人",model.errorStudentCount];
            btnColor = UIColorFromRGB(0xF2BE20);
              self.bottomBtn.hidden = NO;
        }else{
            if (model.totalStudent && [model.totalStudent integerValue] > 0 && [model.totalStudent integerValue] == [model.finishStudentCount integerValue]) {
                btnTitle = @"全对";
                btnImgIcon = @"homework_all_right_icon";
                btnColor = UIColorFromRGB(0x3BA42C);
                  self.bottomBtn.hidden = NO;
            }else{
                 self.bottomBtn.hidden = YES;
            }
        }
      
    }else{
        self.bottomBtn.hidden = YES;
    }
    
    [self.bottomBtn setTitle:btnTitle forState:UIControlStateNormal];
    [self.bottomBtn setImage:[UIImage imageNamed: btnImgIcon] forState:UIControlStateNormal];
    [self.bottomBtn setBackgroundColor:btnColor];
}
NSInteger khlxSort(id user1, id user2, void *context)
{
    
    return  [user1 localizedCompare:user2];
}

- (void)setupTopicDic:(NSDictionary *) itemDic{
    
    if (itemDic[@"options"]) {
        
        self.topicOptionLabel.attributedText = itemDic[@"options"];
        
    }else{
        self.topicOptionLabel.text = @"";
    }
    if (itemDic[@"questionStem"] ) {
        
        
        self.topicTitle.attributedText = itemDic[@"questionStem"] ;
    }else{
        self.topicTitle.text =@"";
    }
    NSString * questionTypeName = @"";
    if (itemDic[@"questionTypeName"] ) {
        questionTypeName = itemDic[@"questionTypeName"];
    }
    NSString * difficultyName = @"";
    if (itemDic[@"difficultyName"] ) {
        difficultyName =  itemDic[@"difficultyName"] ;
    }
    NSNumber * userNumber = @(0);
    if (itemDic[@"useCount"] ) {
        userNumber =  itemDic[@"useCount"] ;
    }
    NSString * bottomText = [questionTypeName stringByAppendingString:[NSString stringWithFormat:@"  %@ 被使用%@次",difficultyName,userNumber]];
    
    self.bottomTitleLabel.text = bottomText;
    
    
    
    NSString * btnImgIcon = @"";
    NSString * btnTitle = @"";
    UIColor * btnColor = nil;
    if (itemDic[@"errorStudentCount"] ) {
        if ([itemDic[@"errorStudentCount"] integerValue] >0) {
            //做错
            btnTitle = [NSString stringWithFormat:@"    答错%@人   ",itemDic[@"errorStudentCount"]];
            btnColor = UIColorFromRGB(0xF2BE20);
            self.bottomBtn.hidden = NO;
        }else{
            if (itemDic[@"totalStudent"] && [itemDic[@"totalStudent"] integerValue] > 0 && [itemDic[@"totalStudent"] integerValue] == [itemDic[@"finishStudentCount"] integerValue]) {
                btnTitle = @"全对";
                btnImgIcon = @"homework_all_right_icon";
                btnColor = UIColorFromRGB(0x3BA42C);
                self.bottomBtn.hidden = NO;
            }else{
                self.bottomBtn.hidden = YES;
            }
        }
        
    }else{
        self.bottomBtn.hidden = YES;
    }
    
    [self.bottomBtn setTitle:btnTitle forState:UIControlStateNormal];
    [self.bottomBtn setImage:[UIImage imageNamed: btnImgIcon] forState:UIControlStateNormal];
    [self.bottomBtn setBackgroundColor:btnColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
