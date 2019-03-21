//
//  AdjustRewardView.m
//  AplusKidsMasterPro
//
//  Created by DCQ on 2017/3/9.
//  Copyright © 2017年 neon. All rights reserved.
//

#import "AdjustRewardView.h"
#import "PublicDocuments.h"
#import "Masonry.h"
#import "ProUtils.h"

#define ADDBTNTAG   23000
#define REDUCTIONBTNTAG   23001
#define SENDBTNTAG  32323
@interface AdjustRewardView ()
@property(nonatomic, strong)UILabel * beanNumberLabel;
@property(nonatomic, assign)NSInteger beanNumber;
@property(nonatomic, strong) UILabel * limit;
@property(nonatomic, strong) UILabel * titleLabel;
@property(nonatomic, strong) UILabel * detailLabel;
@property(nonatomic, strong)  UIImageView * iconV;
@property(nonatomic, assign)NSInteger max;
@property(nonatomic, assign)NSInteger min;
@end
@implementation AdjustRewardView
- (instancetype)initWithFrame:(CGRect)frame{

    if (self ==[super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{

   self.iconV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"adjust_icon"]];
    
    self.iconV .backgroundColor = [UIColor clearColor];
    [self addSubview:self.iconV ];
    
    [self.iconV  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(FITSCALE(20));
        make.bottom.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake( 25,25));
    }];
    

    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = fontSize_14;
    self.titleLabel.textColor = UIColorFromRGB(0x6b6b6b);
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconV.mas_right).mas_offset(4);
        make.bottom.mas_equalTo(self.iconV.mas_bottom).mas_offset(0);
        make.size.mas_equalTo(CGSizeMake( IPHONE_WIDTH-80,25));
    }];
    self.detailLabel = [[UILabel alloc]init];
    self.detailLabel.font = fontSize_11;
    self.detailLabel.textColor = UIColorFromRGB(0x6b6b6b);
    
    [self addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconV.mas_left) ;
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(0);
        make.size.mas_equalTo(CGSizeMake(IPHONE_WIDTH-80,25));
    }];
    
    
    UIButton * sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [sendBtn setBackgroundColor:[UIColor clearColor]];
    [sendBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.backgroundColor = project_main_blue;
    [sendBtn setTitle:@"发放奖励" forState:UIControlStateNormal];
    sendBtn.tag = SENDBTNTAG;
    [self addSubview:sendBtn];
    
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.mas_trailing).mas_offset(FITSCALE(0));
        make.top.mas_equalTo(self.mas_top);
        make.size.mas_equalTo(CGSizeMake(110,self.frame.size.height));
    }];
    
    
    UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setBackgroundColor:[UIColor clearColor]];
    [addBtn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setImage:[UIImage imageNamed:@"adjust_add_icon"] forState:UIControlStateNormal];
    addBtn.tag = ADDBTNTAG;
    [self addSubview:addBtn];
    
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.mas_trailing).mas_offset(-116);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30,30));
    }];
    UIView * bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = project_line_gray;
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(FITSCALE(0.5));
    }];
    
    
    self.beanNumber = 0;
    self.beanNumberLabel = [[UILabel alloc]init];
     self.beanNumberLabel.text = [NSString stringWithFormat:@"%zd",self.beanNumber];
     self.beanNumberLabel.font = fontSize_14;
     self.beanNumberLabel.textColor = [UIColor blackColor];
     self.beanNumberLabel.backgroundColor = [UIColor clearColor];
     self.beanNumberLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview: self.beanNumberLabel];
    [ self.beanNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.mas_trailing).mas_offset(-32-116);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30,30));
    }];
    
    
    UIButton * reductionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [reductionBtn setBackgroundColor:[UIColor clearColor]];
    [reductionBtn addTarget:self action:@selector(reductionBtnAction) forControlEvents:UIControlEventTouchUpInside];
    reductionBtn.tag = REDUCTIONBTNTAG;
    [self addSubview:reductionBtn];

    [reductionBtn setImage:[UIImage imageNamed:@"adjust_after_icon"] forState:UIControlStateNormal];
    [reductionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.mas_trailing).mas_offset(-32-32-116);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30,30));
    }];
    
 
   
}

- (void)addBtnAction{
    
    if (self.beanNumber < self.max) {
        self.beanNumber ++;
        if (self.coinBlock) {
            self.coinBlock(@"1",[NSString stringWithFormat:@"%zd",self.beanNumber]);
//            self.coinBlock(@"1");
        }
    }else{
        
        self.beanNumber =  self.max;
    }
   
    self.beanNumberLabel.text = [NSString stringWithFormat:@"%zd",self.beanNumber];
    
    
}

- (void)reductionBtnAction{

    if (self.beanNumber > self.min) {
        self.beanNumber --;
        if (self.coinBlock) {
             self.coinBlock(@"-1",[NSString stringWithFormat:@"%zd",self.beanNumber]);
//            self.coinBlock([NSString stringWithFormat:@"%zd",self.beanNumber]);
//            self.coinBlock(@"-1");
        }
    }else{
    
        self.beanNumber =  self.min;
    }
    
    self.beanNumberLabel.text = [NSString stringWithFormat:@"%zd",self.beanNumber];
}

- (void)setupCoinNumber:(NSString *)coinNumber{
    self.beanNumber = [coinNumber integerValue];
    self.beanNumberLabel.text = coinNumber;
}

- (void)setupLimitText:(NSString *)text withImage:(NSString *)imageName withType:(NSInteger)type{

//    NSString * titleStr = [NSString stringWithFormat:@"%@(限额5学豆)",text];
//    NSRange range = [titleStr rangeOfString:@"(限额5学豆)"];
//    self.titleLabel.attributedText = [ProUtils setAttributedText:titleStr withColor:UIColorFromRGB(0xff5555) withRange:range withFont:fontSize_10];
    self.iconV.image = [UIImage imageNamed:imageName];
    self.titleLabel.text = text;
   
    self.detailLabel.textColor = UIColorFromRGB(0x9b9b9b);
    UIButton * reductionBtn = [self viewWithTag: REDUCTIONBTNTAG];
    UIButton * addBtn =  [self viewWithTag: ADDBTNTAG];
    if (type == 0) {
         self.detailLabel.text = @"扣除不超过5个学豆哦~";
        //未完成
        [addBtn  removeTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [reductionBtn removeTarget:self action:@selector(reductionBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        [addBtn addTarget:self action:@selector(reductionBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [reductionBtn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        [addBtn setImage:[UIImage imageNamed:@"adjust_after_icon"] forState:UIControlStateNormal];
        [reductionBtn setImage:[UIImage imageNamed:@"adjust_add_icon"] forState:UIControlStateNormal];
        
    }else if (type == 1){
      [addBtn  removeTarget:self action:@selector(reductionBtnAction) forControlEvents:UIControlEventTouchUpInside];
       [reductionBtn removeTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
       [addBtn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
       [reductionBtn addTarget:self action:@selector(reductionBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        [addBtn setImage:[UIImage imageNamed:@"adjust_add_icon"] forState:UIControlStateNormal];
        [reductionBtn setImage:[UIImage imageNamed:@"adjust_after_icon"] forState:UIControlStateNormal];
             self.detailLabel.text = @"奖励不超过5个学豆哦~";
    }

}
- (void)setupMax:(NSInteger )max min:(NSInteger )min{
    self.max = max;
    self.min = min;

}

- (void)sendAction:(id)sender{
    
    if (self.sendCoinBlock) {
        self.sendCoinBlock();
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
