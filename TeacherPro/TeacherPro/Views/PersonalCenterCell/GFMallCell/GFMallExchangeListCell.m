//
//  GFMallExchangeListCell.m
//  TeacherPro
//
//  Created by DCQ on 2018/1/8.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "GFMallExchangeListCell.h"
#import "GFMallExchangeListModel.h"
#import "UIImageView+WebCache.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
@interface GFMallExchangeListCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *mallImgV;
@property (weak, nonatomic) IBOutlet UILabel *mallNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mallNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UILabel *mallDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *bottomLineV;
@property (weak, nonatomic) IBOutlet UILabel *mallTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *exchangeNumbelLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderTimerLabel;

@end
@implementation GFMallExchangeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubView];
}
- (void)setupSubView{
    
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 6;
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.borderColor = project_line_gray.CGColor;
    
    self.mallTimeLabel.textColor = UIColorFromRGB(0x999999);
    self.addressLabel.textColor = UIColorFromRGB(0x999999);
    self.mallNameLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.mallNumberLabel.textColor = UIColorFromRGB(0x999999);
    self.mallDetailLabel.textColor =  UIColorFromRGB(0x999999);
    
    self.topLineView.backgroundColor = project_line_gray;
    self.bottomLineV.backgroundColor = project_line_gray;
    self.exchangeNumbelLabel.textColor = UIColorFromRGB(0x999999);
    self.orderTimerLabel.textColor =  UIColorFromRGB(0x2f8aff);
    self.mallTimeLabel.textColor = UIColorFromRGB(0xbe6a6a);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupInfoModel:(GFMallExchangeModel *)model{
    
    [self.mallImgV sd_setImageWithURL:[NSURL URLWithString:model.giftLogo]];
    self.mallNameLabel.text = model.giftName;
   NSString *numberText  = [NSString stringWithFormat:@"数量：%@",model.giftCount];
  NSAttributedString * numberAttributed  =  [ProUtils setAttributedText:numberText withColor:UIColorFromRGB(0x6b6b6b) withRange:[numberText rangeOfString:model.giftCount] withFont:[UIFont systemFontOfSize:13]];
    self.mallNumberLabel.attributedText = numberAttributed;
   
    
    [self setupExchangeLabel:model];
    self.addressLabel.text = model.completeAddress;
    self.mallDetailLabel.text = model.giftDesc;

    self.orderTimerLabel.text = [NSString stringWithFormat:@"订单时间：%@",[self getShorthandDate:model.ctime]] ;
       NSString * timerDecStr = @"";
    if (model.status && [model.status integerValue] == 1) {
        timerDecStr = @"已发货";
    }else{

        NSString * sendTimer = model.deliveryTime;
        
        int comparisonResult = [ProUtils compareOneDay: [NSDate date] withAnotherDay: [self dateFromString:sendTimer]];
        
        if(comparisonResult >=0){
            //endDate 大
            
            //当前时间 大于发货时间  取当前时间+1
            NSString * tomorrowDateStr = [self GetTomorrowDay:[NSDate date]];
            timerDecStr = [NSString stringWithFormat:@"预计发货时间:%@",tomorrowDateStr];
        }else{
            //当前时间小于发货时间  取发货时间
            timerDecStr = [NSString stringWithFormat:@"预计发货时间：%@",[self getShorthandDate:sendTimer]];
        }
    }
  
    self.mallTimeLabel.text = timerDecStr;
    self.mallTimeLabel.textColor = UIColorFromRGB(0xbe6a6a);
}
//将字符串转成NSDate类型
- (NSDate *)dateFromString:(NSString *)dateString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd  hh:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}





//传入今天的时间，返回明天的时间
- (NSString *)GetTomorrowDay:(NSDate *)aDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    [components setDay:([components day]+1)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"yyyy-MM-dd "];
    return [dateday stringFromDate:beginningOfWeek];
}


- (NSString *)getShorthandDate:(NSString *)dateStr{
    NSString * str = @"";
    if ([dateStr componentsSeparatedByString:@" "] && [[dateStr componentsSeparatedByString:@" "] count] > 0) {
        str = [dateStr componentsSeparatedByString:@" "][0];
    }else{
        str = dateStr;
    }
    return str;
    
}
-(void)setupExchangeLabel:(GFMallExchangeModel *)model{
    
    NSString *exchangeNumbelText = [NSString stringWithFormat:@"感恩币 %@个",model.costCount];
    
//    NSRange  oneRange = NSMakeRange(0, 4);
//    UIColor * oneColor = UIColorFromRGB(0x367FFD);
//
    NSRange  secondRange = [exchangeNumbelText rangeOfString:model.costCount];
    UIColor * secondColor = UIColorFromRGB(0xFB6D87);
 
    NSMutableAttributedString *attributedText  = [[NSMutableAttributedString alloc]initWithString:exchangeNumbelText];

//    [attributedText addAttribute:NSFontAttributeName
//
//                           value: [UIFont systemFontOfSize:16]
//
//                           range:oneRange];
//    [attributedText addAttribute:NSForegroundColorAttributeName
//
//                           value:oneColor
//
//                           range:oneRange];
//
    
    attributedText = [self getAttributedText:attributedText withFont: [UIFont systemFontOfSize:14] withRange:secondRange withColor:secondColor];
    
    
    self.exchangeNumbelLabel.attributedText = attributedText;
    
}
- (NSMutableAttributedString *)getAttributedText:(NSMutableAttributedString *)attributedText withFont:(UIFont *)font  withRange:(NSRange)range withColor:(UIColor *)color{
    
    [attributedText addAttribute:NSFontAttributeName
     
                           value: [UIFont systemFontOfSize:14]
     
                           range:range];
    [attributedText addAttribute:NSForegroundColorAttributeName
     
                           value:color
     
                           range:range];
    
    return attributedText;
}
@end
