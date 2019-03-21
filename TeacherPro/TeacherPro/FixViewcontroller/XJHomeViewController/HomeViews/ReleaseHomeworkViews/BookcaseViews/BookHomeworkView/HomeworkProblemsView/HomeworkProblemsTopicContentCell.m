//
//  HomeworkProblemsTopicContentCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/1/22.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "HomeworkProblemsTopicContentCell.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
#import "HomeworkProblemsDetailListModel.h"
@interface HomeworkProblemsTopicContentCell ()
@property (weak, nonatomic) IBOutlet UILabel *topicTitle;
@property (weak, nonatomic) IBOutlet UILabel *topicOptionLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *bottomTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomLineV;
@property (weak, nonatomic) IBOutlet UIView *spacingView;

@end
@implementation HomeworkProblemsTopicContentCell

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
   [self setupBtnSelectedState:!btn.selected];
    if (self.buttonBlock) {
        self.buttonBlock(btn.selected,self.indexPath);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupBtnSelectedState:(BOOL)state{
 
   self.bottomBtn.selected = state;
    if (state) {
        self.bottomBtn.backgroundColor = UIColorFromRGB(0xF99F1C); 
    }else{
         self.bottomBtn.backgroundColor = project_main_blue;
    } 
}
- (void)setupTopicModel:(HomeworkProblemsQuestionsModel *) model{
     
        if (model.options) {
            NSArray * allkeys = model.options.allKeys;
            NSArray *sortedArray = [allkeys sortedArrayUsingFunction:nickNameSort context:NULL];
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
}
NSInteger nickNameSort(id user1, id user2, void *context)
{
 
    return  [user1 localizedCompare:user2];
}


@end
