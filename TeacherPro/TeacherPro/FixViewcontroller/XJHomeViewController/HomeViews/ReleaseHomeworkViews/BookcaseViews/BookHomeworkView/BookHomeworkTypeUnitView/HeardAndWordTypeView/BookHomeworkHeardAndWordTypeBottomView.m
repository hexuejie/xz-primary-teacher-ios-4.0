
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
//  BookHomeworkHeardAndWordTypeBottomView.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookHomeworkHeardAndWordTypeBottomView.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
@interface BookHomeworkHeardAndWordTypeBottomView ()
@property (weak, nonatomic) IBOutlet UILabel *totalNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UILabel *listenAndTalkLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIImageView *verticalLineView;
@property (weak, nonatomic) IBOutlet UIView *topLine;

@end
@implementation BookHomeworkHeardAndWordTypeBottomView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupSubview];
}

- (void)setupSubview{
    
    self.verticalLineView.backgroundColor = project_line_gray;
    self.listenAndTalkLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.wordLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.totalNumberLabel.textColor = project_main_blue;
    
    self.totalNumberLabel.font = fontSize_12;
    self.listenAndTalkLabel.font = fontSize_12;
    self.wordLabel.font = fontSize_12;
    self.topLine.backgroundColor = project_line_gray;
    
    self.sureBtn.titleLabel.backgroundColor = self.sureBtn.backgroundColor;
    self.sureBtn.imageView.backgroundColor = self.sureBtn.backgroundColor;
    
    
    
    //在使用一次titleLabel和imageView后才能正确获取titleSize
    CGSize titleSize = self.sureBtn.titleLabel.bounds.size;
    CGSize imageSize = self.sureBtn.imageView.bounds.size;
    CGFloat interval = 4.0;
    self.sureBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -interval/2, 0,  interval/2);
    self.sureBtn.titleEdgeInsets = UIEdgeInsetsMake(0,  interval/2, 0, -interval/2);
}
- (IBAction)sureButtonAction:(id)sender {
    
    if (self.sureBlock) {
        self.sureBlock();
    }
    
}
- (void)setupTotalNumber:(NSInteger )totalNumber withWordNumber:(NSInteger)wordNumber withHeardNumber:(NSInteger)heardNumber{
    
    NSString * unit = @"";
    if (totalNumber < 60 && totalNumber > 0) {
        
        unit = [NSString stringWithFormat:@"%zd",1];
    }else{
        unit = [NSString stringWithFormat:@"%zd",(int)(totalNumber/60)];
    }
    
    UIColor * numberColor = UIColorFromRGB(0xff617a);
    NSString *totalTitleStr = [NSString stringWithFormat:@"总时长：%@分钟",unit];
    
    NSRange range = [totalTitleStr rangeOfString:unit];
    
    self.totalNumberLabel.attributedText =  [ProUtils setAttributedText:totalTitleStr withColor:numberColor withRange:range withFont:fontSize_12];
    
    NSString * wordTitleStr = [NSString stringWithFormat:@"词汇：%zd 题",wordNumber];
    NSRange  wordRange = [wordTitleStr rangeOfString:[NSString stringWithFormat:@"%zd",wordNumber]];
     NSAttributedString * wordA =  [ProUtils setAttributedText:wordTitleStr withColor:numberColor withRange:wordRange withFont:fontSize_12];

    
    
    NSString * heardTitleStr = [NSString stringWithFormat:@"听说：%zd 题",heardNumber];
    NSRange  heardRange = [heardTitleStr rangeOfString:[NSString stringWithFormat:@"%zd",heardNumber]];
    
    NSAttributedString * listenA = [ProUtils setAttributedText:heardTitleStr withColor:numberColor withRange:heardRange withFont:fontSize_12];
    
    self.listenAndTalkLabel.attributedText =  wordA;
    self.wordLabel.attributedText = listenA;
}
@end

