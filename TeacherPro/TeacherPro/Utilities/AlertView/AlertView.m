//
//  AlertView.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/23.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "AlertView.h"
#import "MMPopupItem.h"
#import "MMPopupCategory.h"
#import "MMPopupDefine.h"
#import "Masonry.h"
#import "PublicDocuments.h"
#import "ProUtils.h"
#import "NSDate+YN.h"
#import "ProUtils.h"
#define manBtnTag   123232
#define wumanBtnTag   2223323

#define ChineseBtnTag   2223325
#define MathematicsBtnTag   2223326
#define EnglishBtnTag    2223327
#define OtherBtnTag      2223328

#define ChineseChooseImgVTag     240000
#define MathematicsChooseImgVTag     240001
#define OtherChooseImgVTag     240002
#define EnglishChooseImgVTag     240003

#define contentViewTag   3323423423
@interface AlertView()

@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UIImageView  *imageView;
@property (nonatomic, strong) UILabel     *detailLabel;
@property (nonatomic, strong) UITextField *inputView;
@property (nonatomic, strong) UIView      *buttonView;
@property (nonatomic, strong) UIView      *contentView;
@property (nonatomic, strong) NSArray     *actionItems;
@property (nonatomic, copy) MMPopupHandler inputHandler;
@property (nonatomic, strong) MMPopupItem     *rightItem;
@property (nonatomic, strong) DatePicker     *datePicker;
@property (nonatomic, assign)AlertViewType customAlertType;
@property (nonatomic, copy) MMPopupCompletionHandler dateHandler;
@property (nonatomic, copy) NSString * subjects;

//验证码倒计时
@property (nonatomic) NSTimer *sendTimer;
@property (nonatomic) NSDate  *fireDate;
@property ( nonatomic,strong)   UIButton *smsButton;
@property (nonatomic, strong)   UILabel *verificationLabel;
@end
@implementation AlertView
- (instancetype) initWithCreateInputTitle:(NSString *)title
                                   detail:(NSString *)detail
                                    items:(NSArray*)items
                              placeholder:(NSString *)inputPlaceholder
                                  handler:(MMPopupHandler)inputHandler

{
    AlertViewConfig *config = [AlertViewConfig globalConfig];
    if (!items) {
        items =@[
                 MMItemMake(config.defaultTextCancel, MMItemTypeHighlight, nil),
                 MMItemMake(config.defaultTextConfirm, MMItemTypeHighlight, nil)
                 ];
    }
    
    return [self initWithTitle:title detail:detail items:items inputPlaceholder:inputPlaceholder inputHandler:inputHandler dateHandler:nil imageTypeResult:TNOperationState_Normal alertViewType:AlertViewType_TextCreateClass alertBottomViewType:AlertBottomViewType_buttonWidthfull textFeildRightItem:nil logoInstructions:nil];
}


- (instancetype) initWithCompletionTimeTitle:(NSString *)title
                                  normalTime:(NSString *)time
                                       items:(NSArray*)items
                                      handler:(MMPopupCompletionHandler )dateHandler{
    AlertViewConfig *config = [AlertViewConfig globalConfig];
    if (!items) {
        items =@[
                 MMItemMake(config.defaultTextCancel, MMItemTypeHighlight, nil),
                 MMItemMake(config.defaultTextConfirm, MMItemTypeHighlight, nil)
                 ];
    }
    
    return [self initWithTitle:title detail:time items:items inputPlaceholder:nil inputHandler:nil dateHandler:dateHandler imageTypeResult:TNOperationState_Normal alertViewType:AlertViewType_CompletionTime alertBottomViewType:AlertBottomViewType_buttonWidthfull textFeildRightItem:nil logoInstructions:nil];

 
}
- (instancetype) initWithNormalInputTitle:(NSString *)title
                             detail:(NSString *)detail
                              items:(NSArray*)items
                        placeholder:(NSString *)inputPlaceholder
                            handler:(MMPopupHandler)inputHandler

{
    AlertViewConfig *config = [AlertViewConfig globalConfig];
    if (!items) {
        items =@[
                 MMItemMake(config.defaultTextCancel, MMItemTypeHighlight, nil),
                 MMItemMake(config.defaultTextConfirm, MMItemTypeHighlight, nil)
                 ];
    }
 
    return [self initWithTitle:title detail:detail items:items inputPlaceholder:inputPlaceholder inputHandler:inputHandler dateHandler:nil imageTypeResult:TNOperationState_Normal alertViewType:AlertViewType_TextFeildNormal alertBottomViewType:AlertBottomViewType_buttonWidthfull textFeildRightItem:nil logoInstructions:nil];
}


- (instancetype) initWithInputPhoneTitle:(NSString *)title
                                   detail:(NSString *)detail
                                    items:(NSArray*)items
                              placeholder:(NSString *)inputPlaceholder
                                  handler:(MMPopupHandler)inputHandler

{
    AlertViewConfig *config = [AlertViewConfig globalConfig];
    if (!items) {
        items =@[
                 MMItemMake(config.defaultTextCancel, MMItemTypeHighlight, nil),
                 MMItemMake(config.defaultTextConfirm, MMItemTypeHighlight, nil)
                 ];
    }
    
    return [self initWithTitle:title detail:detail items:items inputPlaceholder:inputPlaceholder inputHandler:inputHandler dateHandler:nil imageTypeResult:TNOperationState_Normal alertViewType:AlertViewType_InputPhoneNormal alertBottomViewType:AlertBottomViewType_buttonWidthfull textFeildRightItem:nil logoInstructions:nil];
}
- (instancetype) initWithValidationInputTitle:(NSString*)title
                                       detail:(NSString*)detail
                                        items:(NSArray *)items
                                  placeholder:(NSString*)inputPlaceholder
                                      handler:(MMPopupHandler)inputHandler

                           textFeildRightItem:(MMPopupItem *)rightItem
  {
      if (!items) {
            AlertViewConfig *config = [AlertViewConfig globalConfig];
           items =@[
                            MMItemMake(config.defaultTextCancel, MMItemTypeHighlight, nil),
                            MMItemMake(config.defaultTextConfirm, MMItemTypeHighlight, nil)
                            ];
      }

    
    
      return [self initWithTitle:title detail:detail items:items inputPlaceholder:inputPlaceholder inputHandler:inputHandler dateHandler:nil imageTypeResult:TNOperationState_Normal alertViewType:AlertViewType_VerificationCodeTextFeild alertBottomViewType:AlertBottomViewType_buttonWidthfull textFeildRightItem:rightItem logoInstructions:nil];

}

- (instancetype) initWithOperationState:(TNOperationState )operationState
                                 detail:(NSString*)detail
                                  items:(NSArray*)items{

    if (!items) {
        AlertViewConfig *config = [AlertViewConfig globalConfig];
        
        items =@[MMItemMake(config.defaultTextConfirm, MMItemTypeHighlight, nil),
                           ];

    }
    return [self initWithTitle:nil detail:detail items:items inputPlaceholder:nil inputHandler:nil dateHandler:nil imageTypeResult:operationState alertViewType:AlertViewType_Normal alertBottomViewType:AlertBottomViewType_buttonWidthCustom textFeildRightItem:nil logoInstructions:nil];

}

- (instancetype) initWithTitle:(NSString*)title
                        detail:(NSString*)detail
                         items:(NSArray*)items
{
    AlertBottomViewType  bottomType;
    if ([items count] == 1) {
        bottomType  = AlertBottomViewType_buttonWidthCustom ;
    }else{
        bottomType  = AlertBottomViewType_buttonWidthfull;
    }
    return [self initWithTitle:title detail:detail items:items inputPlaceholder:nil inputHandler:nil dateHandler:nil imageTypeResult:TNOperationState_Normal alertViewType:AlertViewType_Normal alertBottomViewType:bottomType textFeildRightItem:nil logoInstructions:nil];

}


- (instancetype) initWithTitle:(NSString*)title
              logoInstructions:(NSArray *)logos
                         items:(NSArray*)items{

    AlertBottomViewType  bottomType;
    if ([items count] == 1) {
        bottomType  = AlertBottomViewType_buttonWidthCustom ;
    }else{
        bottomType  = AlertBottomViewType_buttonWidthfull;
    }
    
    return  [self initWithTitle:title detail:nil items:items inputPlaceholder:nil inputHandler:nil dateHandler:nil imageTypeResult:TNOperationState_Normal alertViewType:AlertViewType_LogoInstructions alertBottomViewType:bottomType textFeildRightItem:nil logoInstructions:logos];
}


- (instancetype) initWithTitle:(NSString*)title
                    normarlSex:(NSString *)sex
                         items:(NSArray*)items{

    AlertBottomViewType  bottomType;
    if ([items count] == 1) {
        bottomType  = AlertBottomViewType_buttonWidthCustom ;
    }else{
        bottomType  = AlertBottomViewType_buttonWidthfull;
    }
    return  [self initWithTitle:title detail:sex items:items inputPlaceholder:nil inputHandler:nil dateHandler:nil imageTypeResult:TNOperationState_Normal alertViewType:AlertViewType_Sex alertBottomViewType:bottomType textFeildRightItem:nil logoInstructions:nil];
    
}

- (instancetype)initWithTitle:(NSString *)title  withSubjects:(NSString *)subjects  items:(NSArray *)items{

    return [self initWithTitle:title detail:subjects items:items inputPlaceholder:nil inputHandler:nil dateHandler:nil imageTypeResult:TNOperationState_Normal alertViewType:AlertViewType_Subjects alertBottomViewType:AlertBottomViewType_buttonWidthfull textFeildRightItem:nil logoInstructions:nil];
    
}
- (instancetype)initWithTitle:(NSString *)title
                       detail:(NSString *)detail
                        items:(NSArray *)items
             inputPlaceholder:(NSString *)inputPlaceholder
                 inputHandler:(MMPopupHandler)inputHandler
                 dateHandler:(MMPopupCompletionHandler)dateHandler
              imageTypeResult:(TNOperationState  )operationState
                alertViewType:(AlertViewType)alertType
               alertBottomViewType:(AlertBottomViewType)bottomType
           textFeildRightItem:(MMPopupItem *)textFeildRightItem
           logoInstructions:(NSArray *)logos
{
    self = [super init];
    
    if ( self )
    {
      
        if (self.attachedView) {
            [self.attachedView removeFromSuperview];
        }
           self.contentView = [[UIView alloc]init];
        self.contentView.tag = contentViewTag;
        NSAssert(items.count>0, @"Could not find any items.");
        
        AlertViewConfig *config = [AlertViewConfig globalConfig];
        
        self.type = MMPopupTypeAlert;
        self.withKeyboard = (inputHandler!=nil);
        
        self.inputHandler = inputHandler;
        self.dateHandler  = dateHandler;
        self.actionItems = items;
        
        self.layer.cornerRadius = config.cornerRadius;
        self.clipsToBounds = YES;
        self.backgroundColor = config.backgroundColor;
        self.layer.borderWidth = MM_SPLIT_WIDTH;
        self.layer.borderColor = config.splitColor.CGColor;
        self.customAlertType = alertType;
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(config.width);
        }];
    
       
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        
        MASViewAttribute *lastAttribute = self.mas_top;
        if ( title.length > 0 )
        {
            self.titleLabel = [UILabel new];
            [self addSubview:self.titleLabel];
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {

                make.top.equalTo(lastAttribute).offset(12);
                make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
                make.height.equalTo(@(44));
            }];
            self.titleLabel.textColor = HexRGB(0x525B66);
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
            self.titleLabel.numberOfLines = 0;
            self.titleLabel.backgroundColor = [UIColor whiteColor];
            self.titleLabel.text = title;
            
            lastAttribute = self.titleLabel.mas_bottom;
        }
        
        ///弹出框 内容
        if (AlertViewType_LogoInstructions == alertType) {
            
          
            [self addSubview:self.contentView];
            
            CGFloat contentViewHeight =  FITSCALE(200);
            [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).offset(config.innerMargin);
                make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0,0, 0, 0));
                make.height.mas_equalTo(contentViewHeight);
            }];
            
            [self configLogoContentView:logos  contentHeight:contentViewHeight ];
            
            self.contentView.backgroundColor = self.backgroundColor;
            lastAttribute = self.contentView.mas_bottom;
            
        }else if (AlertViewType_Sex == alertType) {
        
         
            [self addSubview:self.contentView];
            
            CGFloat contentViewHeight =  FITSCALE(80);
            [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).offset(config.innerMargin);
                make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0,0, 0, 0));
                make.height.mas_equalTo(contentViewHeight);
            }];
            
            [self configSexContentView:detail  contentHeight:contentViewHeight ];
            
            self.contentView.backgroundColor = self.backgroundColor;
            lastAttribute = self.contentView.mas_bottom;
            
            
        }else if (AlertViewType_Subjects == alertType){
         
            [self addSubview:self.contentView];
            
            CGFloat contentViewHeight =  110;
            [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastAttribute).offset(10);
                make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0,0, 0, 0));
                make.height.mas_equalTo(contentViewHeight);
            }];
            
            [self configSubjectsContentView:detail  contentHeight:contentViewHeight ];
            
            self.contentView.backgroundColor = self.backgroundColor;
            lastAttribute = self.contentView.mas_bottom;
            
        
        } else{
            if (operationState !=   TNOperationState_Normal) {
                
                self.imageView = [UIImageView new];
                [self addSubview:self.imageView];
                [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.mas_equalTo(lastAttribute).offset(FITSCALE(30));
                    make.centerX.mas_equalTo(self);
                    make.height.mas_equalTo(FITSCALE(68.5));
                    make.width.mas_equalTo(FITSCALE(109));
                    
                }];
                UIImage *resultIcon;
                switch (operationState) {
                    case TNOperationState_OK:
                        resultIcon =  [UIImage imageNamed:@"prompt_success_icon"];
                        break;
                    case TNOperationState_Fail:
                        resultIcon =  [UIImage imageNamed:@"prompt_fail_icon"];
                        break;
                    case TNOperationState_Unknow:
                        resultIcon =  [UIImage imageNamed:@"prompt_unknow_icon"];
                        break;
                    default:
                        break;
                }
                self.imageView.image = resultIcon;
                
                lastAttribute = self.imageView.mas_bottom;
            }
            
            
            if (  AlertViewType_TextCreateClass != alertType && AlertViewType_CompletionTime != alertType  && detail.length > 0 )
            {
                self.detailLabel = [UILabel new];
                [self addSubview:self.detailLabel];
                [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastAttribute).offset(config.innerMargin);
                    make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, config.innerMargin, 0, config.innerMargin));
                }];
                self.detailLabel.textColor = config.detailColor;
                self.detailLabel.textAlignment = NSTextAlignmentCenter;
                self.detailLabel.font =  fontSize_14;
                self.detailLabel.numberOfLines = 0;
                self.detailLabel.backgroundColor = self.backgroundColor;
                self.detailLabel.text = detail;
                
                lastAttribute = self.detailLabel.mas_bottom;
            }
            
            if (self.inputHandler )
            {
                self.inputView = [UITextField new];
                [self addSubview:self.inputView];
                [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
                    CGFloat top = 10;
                    if (AlertViewType_TextCreateClass == alertType) {
                        top = 20;
                        self.maxInputLength =  5;
                    }
                    make.top.equalTo(lastAttribute).offset(top);
                    make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, config.innerMargin, 0, config.innerMargin));
                    make.height.mas_equalTo(46);
                }];
                
                if (AlertViewType_InputPhoneNormal == alertType) {
                    self.maxInputLength = 11;
                    self.inputView.keyboardType = UIKeyboardTypePhonePad;
                }else if (AlertViewType_VerificationCodeTextFeild == alertType){
                    
                    self.inputView.keyboardType = UIKeyboardTypePhonePad;
                }else if(AlertViewType_TextFeildNormal == alertType){
                
                   self.maxInputLength = 5;
                    
                }
                
                self.inputView.font = systemFontSize(16);
                self.inputView.layer.masksToBounds = YES;
                self.inputView.layer.cornerRadius =  6;
                self.inputView.backgroundColor = UIColorFromRGB(0xF6F6F8);
//                self.inputView.layer.borderWidth = 1;
//                self.inputView.layer.borderColor = UIColorFromRGB(0xC2C2C2).CGColor;
                self.inputView.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 5)];
                CGFloat rightViewWith =  80;
                
                
                UIButton * inputRightView = [UIButton buttonWithType:UIButtonTypeCustom];
                [inputRightView setFrame:CGRectMake(self.inputView.frame.size.width - rightViewWith, 0, rightViewWith, 40)];
                
                [inputRightView setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
                inputRightView.titleLabel.font = [UIFont systemFontOfSize:12 ];
                
                [inputRightView setBackgroundColor:UIColorFromRGB(0x2E8AFF)];
                self.inputView.rightView = inputRightView ;
                
                
                self.inputView.leftViewMode = UITextFieldViewModeAlways;
                //输入框右侧按钮
                if (textFeildRightItem ) {
                    self.rightItem = textFeildRightItem;
                    [inputRightView setTitle:textFeildRightItem.title forState:UIControlStateNormal];
                    [inputRightView addTarget:self action:@selector(rightActionButton:) forControlEvents:UIControlEventTouchUpInside];
                    self.inputView.rightViewMode = UITextFieldViewModeAlways;
                    self.smsButton = inputRightView;
                    [self initTimer];
                    
                 } else {
                   
                     self.inputView.rightViewMode = UITextFieldViewModeNever;
                
                 }
                NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:inputPlaceholder attributes: @{NSForegroundColorAttributeName:HexRGB(0xA1A7B3),           NSFontAttributeName:[UIFont systemFontOfSize:16]
                                                             }];
                self.inputView.attributedPlaceholder = attrString;
           
//                self.inputView.placeholder = inputPlaceholder;
                self.inputView.textAlignment = NSTextAlignmentCenter;
                lastAttribute = self.inputView.mas_bottom;
            }
            
            if (  AlertViewType_TextCreateClass == alertType &&detail.length > 0 )
            {
                self.detailLabel = [UILabel new];
                [self addSubview:self.detailLabel];
                [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastAttribute).offset(config.innerMargin-8);
                    make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, config.innerMargin, 0, config.innerMargin));
                }];
                self.detailLabel.textColor = HexRGB(0x8A8F99);
                self.detailLabel.textAlignment = NSTextAlignmentCenter;
                self.detailLabel.font =  systemFontSize(12);
                self.detailLabel.numberOfLines = 0;
                self.detailLabel.backgroundColor = self.backgroundColor;
                self.detailLabel.text = detail;
                
                lastAttribute = self.detailLabel.mas_bottom;
            }
            if (AlertViewType_VerificationCodeTextFeild == alertType ) {
                
                self.verificationLabel =  [UILabel new];
                 [self addSubview:self.verificationLabel];
                [self.verificationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastAttribute).offset(config.innerMargin);
                    make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, config.innerMargin, 0, config.innerMargin));
                }];
//                self.verificationLabel.text = @"请点击获取验证码按钮";
                self.verificationLabel.textAlignment = NSTextAlignmentCenter;
                self.verificationLabel.font = fontSize_10;
                self.verificationLabel.numberOfLines = 0;
                self.verificationLabel.backgroundColor = self.backgroundColor;
                self.verificationLabel.textColor = UIColorFromRGB(0x9B9B9B);
                 lastAttribute = self.verificationLabel.mas_bottom;
            }
            
            if (AlertViewType_CompletionTime == alertType ) {
    
                [self addSubview:self.contentView];
                CGFloat contentViewHeight =  FITSCALE(160);
                [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastAttribute).offset(config.innerMargin);
                    make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0,0, 0, 0));
                    make.height.mas_equalTo(contentViewHeight);
                }];
                [self configTimerContentView:contentViewHeight];
                self.contentView.backgroundColor = self.backgroundColor;
                lastAttribute = self.contentView.mas_bottom;
            }

            
        }
        
        [self initButtonView:lastAttribute withConfig:config withButtonItems:items withBottomType:bottomType];
     
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    return self;
}


- (void)initButtonView:( MASViewAttribute *)lastAttribute withConfig:(AlertViewConfig *)config withButtonItems:(NSArray *)items withBottomType:(AlertBottomViewType  )bottomType{

                
    
    self.buttonView = [UIView new];
    [self addSubview:self.buttonView];
    [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastAttribute).offset(0);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(0);
        make.height.mas_equalTo(47);
    }];
    UIView *midmidLine = [[UIView alloc]init];
    midmidLine.backgroundColor = HexRGB(0xf5f5f5);
    [self addSubview:midmidLine];
    [midmidLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-46);
    }];
    
    
    
    __block UIButton *firstButton = nil;
    __block UIButton *lastButton = nil;
    for ( NSInteger i = 0 ; i < items.count; ++i )
    {
        MMPopupItem *item = items[i];
        
        UIButton *btn = [UIButton mm_buttonWithTarget:self action:@selector(actionButton:)];
        [self.buttonView addSubview:btn];
        btn.tag = i;
        [btn setContentEdgeInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if ( items.count <= 2 )
            {
                make.top.bottom.equalTo(self.buttonView);
                make.height.mas_equalTo(config.buttonHeight);

                if (!firstButton )
                {
                    firstButton = btn;
                    make.left.equalTo(self.buttonView.mas_left).offset(-MM_SPLIT_WIDTH);
                    
                    UIView *midLine = [[UIView alloc]init];
                    midLine.backgroundColor = HexRGB(0xf5f5f5);
                    [self.buttonView addSubview:midLine];
                    [midLine mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(1);
                        make.height.mas_equalTo(46);
                        make.top.equalTo(midmidLine);
                        make.right.equalTo(btn.mas_right).offset(5);
                    }];
                    if (items.count<=1) {
                        midLine.backgroundColor = [UIColor clearColor];
                    }
                }
                else
                {
                    make.left.equalTo(lastButton.mas_right).offset(-MM_SPLIT_WIDTH);
                    make.width.equalTo(firstButton);
                    
                }
            }
            else
            {
                make.left.right.equalTo(self.buttonView);
                make.height.mas_equalTo(config.buttonHeight);
                
                if ( !firstButton )
                {
                    firstButton = btn;
                    make.top.equalTo(self.buttonView.mas_top).offset(-MM_SPLIT_WIDTH);
                }
                else
                {
                    make.top.equalTo(lastButton.mas_bottom).offset(-MM_SPLIT_WIDTH);
                    make.width.equalTo(firstButton);
                }
            }
            
            lastButton = btn;
        }];
        
        [btn setTitle:item.title forState:UIControlStateNormal];
        [btn setTitleColor: HexRGB(0x999999) forState:UIControlStateNormal];
        btn.layer.masksToBounds = YES;


        btn.titleLabel.font = systemFontSize(16.0);
    }
    [lastButton setTitleColor:HexRGB(0x33AAFF) forState:UIControlStateNormal];
    
    [lastButton mas_updateConstraints:^(MASConstraintMaker *make) {
        
        if ( items.count <= 2 )
        {
            if (bottomType == AlertBottomViewType_buttonWidthCustom) {
                make.centerX.equalTo(self.buttonView.mas_centerX);
                // config
                make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0,config.width/2 - config.itemWidth/2, 0, config.width/2 - config.itemWidth/2));
                
            }else{
                make.right.equalTo(self.buttonView.mas_right).offset(MM_SPLIT_WIDTH);
            }
        }
        else
        {
            make.bottom.equalTo(self.buttonView.mas_bottom).offset(MM_SPLIT_WIDTH);
        }
        
    }];
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.buttonView.mas_bottom).offset(10);
        
    }];
}
- (void)setVerificationText:(NSString *)verificationText{
 
    self.verificationLabel.text = verificationText;
    [self setNeedsLayout];
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)rightActionButton:(UIButton *)btn{
 
    if (self.rightItem) {
        self.rightItem.handler(-99999);
    }
    if (self.sendTimer) {
        [self startTimer];
    }
}
- (void)actionButton:(UIButton*)btn
{
    
    
    MMPopupItem *item = self.actionItems[btn.tag];
    WEAKSELF
    if ( item.disabled )
    {
        return;
    }
    
    //取消
    if (btn.tag == 0) {
        if (item.handler )
        {
           [self hideWithBlock:^(MMPopupView *view, BOOL finished) {
                    item.handler(btn.tag);
             }];
            
        }else{
            [self hide];
        }
       
    }
    //确认按钮
    else if(btn.tag == 1){
        //是否 键盘输入 block
        if (self.withKeyboard) {
            //如果输入的内容
            if (self.inputView.text.length > 0) {
                
                //验证是否输入的手机号码
                if (self.customAlertType == AlertViewType_InputPhoneNormal && [ProUtils checkMobilePhone:self.inputView.text] ) {
                    [ProUtils shake:self.inputView];
                    return;
                }
                
                else{
                    if ( self.inputHandler)
                    {
                        
                        [self hideWithBlock:^(MMPopupView *view, BOOL finished) {
                            self.inputHandler(self.inputView.text);
                        }];
                        
                    }
                
            }
                
            }
            //没输入内容
            else{
                [ProUtils shake:self.inputView];
                 return;
            }
        }
        
        
        //时间 block
      else  if (self.dateHandler) {
            [self hideWithBlock:^(MMPopupView *view, BOOL finished) {
               self.dateHandler([self.datePicker getSelectedDate]);
            }];
        
        }
        //性别
       else if ( self.sexBlock) {
            
            UIButton *manBtn = [self.contentView viewWithTag:manBtnTag];
            UIButton *wumanBtn = [self.contentView viewWithTag:wumanBtnTag];
            
           [self hideWithBlock:^(MMPopupView *view, BOOL finished) {
               if (wumanBtn.selected ) {
                   self.sexBlock(@"female");
               }
               if (manBtn.selected) {
                   self.sexBlock(@"male");
               }
           }];
           
        }
        
        //科目
       else if ( self.subjectsBlock) {
           [self hideWithBlock:^(MMPopupView *view, BOOL finished) {
               self.subjectsBlock(self.subjects);
           }];
        }
       
       else{
           if (item.handler )
           {
               if (!self.isStrongUpate) {
                   [self hideWithBlock:^(MMPopupView *view, BOOL finished) {
                       item.handler(btn.tag);
                   }];
               }else{
                   item.handler(btn.tag);
               }
           }else{
             if (!self.isStrongUpate) {
                 [self hide];
             }
           }
           
       }
      
    }
    
   
    
    
    
//    if ( self.withKeyboard && (btn.tag==1) )
//    {
//        if ( self.inputView.text.length > 0 )
//        {
//            if (self.customAlertType == AlertViewType_InputPhoneNormal && [ProUtils checkMobilePhone:self.inputView.text] ) {
//                [ProUtils shake:self.inputView];
//                return;
//            }else{
//                
//                if ( self.inputHandler && (btn.tag>0) )
//                {
//                    if (self.inputView.text.length <= 0) {
//                        [ProUtils shake:self.inputView];
//                    }else{
//                        
//                        [self hideWithBlock:^(MMPopupView *view, BOOL finished) {
//                            self.inputHandler(self.inputView.text);
//                        }];
//                        
//                    }
//
//                }else{
//                     [self hide];
//                }
//              
//            }
//        }
//    }
//    else
//    {
//        [self hide];
//    }
//    if (self.dateHandler && btn.tag >0) {
//        
//        [self hide];
//        self.dateHandler([self.datePicker getSelectedDate]);
//       
//    }
//   
//    else
//    {
//        
//        if (self.customAlertType == AlertViewType_InputPhoneNormal && [ProUtils checkMobilePhone:self.inputView.text] ) {
//            [ProUtils shake:self.inputView];
//            return;
//        }else{
//            
//            [self hide];
//            if (btn.tag == 1 && self.sexBlock) {
//                
//                UIButton *manBtn = [self.contentView viewWithTag:manBtnTag];
//                UIButton *wumanBtn = [self.contentView viewWithTag:wumanBtnTag];
//                
//                
//                if (wumanBtn.selected ) {
//                    self.sexBlock(@"female");
//                }
//                if (manBtn.selected) {
//                    self.sexBlock(@"male");
//                }
//                
//            }
//            if (btn.tag == 1 && self.subjectsBlock) {
//                
//                self.subjectsBlock(self.subjects);
//                
//            }
//            if ( item.handler )
//            {
//                item.handler(btn.tag);
//            }
//        }
//    }
    
    if (self.sendTimer) {
        [self endTimer];
    }
}

- (void)notifyTextChange:(NSNotification *)n
{
    if ( self.maxInputLength == 0 )
    {
        return;
    }
    
    if ( n.object != self.inputView )
    {
        return;
    }
    
    UITextField *textField = self.inputView;
    
    NSString *toBeString = textField.text;
    
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        if (toBeString.length > self.maxInputLength) {
            textField.text = [toBeString mm_truncateByCharLength:self.maxInputLength];
        }
    }
}

- (void)showKeyboard
{
    [self.inputView becomeFirstResponder];
}

- (void)hideKeyboard
{
    [self.contentView removeFromSuperview];
    [self.inputView resignFirstResponder];
}

- (void)configLogoContentView:(NSArray *)logos contentHeight:(CGFloat)contentHeight {

    UIView * lasetView = nil;
    for (int i = 0; i <[logos count]; i++) {
        UIView * bgView = [[UIView alloc]init];
      
        bgView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lasetView ) {
               make.top.mas_equalTo(lasetView.mas_bottom).offset(5);
            }else{
               make.top.mas_equalTo(self.contentView.mas_top).offset(-10);
            }
            make.left.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView);
            make.height.mas_equalTo(contentHeight/4);
        }];
        lasetView = bgView;
        /**
         左侧 视图
         */
        CGFloat leftViewW =  130;
        UIView * leftView = [[UIView alloc]init ];
        [leftView setBackgroundColor:[UIColor clearColor]];
        [bgView addSubview:leftView];
        
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgView);
            make.width.mas_equalTo(leftViewW);
            make.centerY.mas_equalTo(bgView);
            make.height.mas_equalTo(bgView);
        }];
        
        
        UIImageView * imageView = [[UIImageView alloc] init];
        [imageView setImage:[UIImage imageNamed:logos[i][@"img"]]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [leftView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(leftView);
            make.left.mas_equalTo(leftView).offset(10);
            make.width.mas_equalTo(FITSCALE(30));
            make.height.mas_equalTo(FITSCALE(30));
        }];
        
        UILabel * titleLabel = [[UILabel alloc] init];
        [titleLabel setText: logos[i][@"title"]];
        [titleLabel setTextColor:project_main_blue];
        [titleLabel setFont:fontSize_13];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [leftView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(leftView);
            make.left.mas_equalTo(imageView.mas_right).offset(5);
            make.right.mas_equalTo(leftView);
            make.height.mas_equalTo( leftView);
        }];
  
        
        /**
         右侧 视图
         */
        
        UIView * rightView = [[UIView alloc]init ];
        rightView.backgroundColor = [UIColor clearColor];
        [bgView addSubview:rightView];
        
        UILabel * detailLabel = [[UILabel alloc] init];
        [detailLabel setText: logos[i][@"detail"]];
        [detailLabel setTextColor:UIColorFromRGB(0x9f9f9f)];
        [detailLabel setFont:fontSize_13];
        detailLabel.numberOfLines = 0;
        detailLabel.textAlignment = NSTextAlignmentLeft;
        [rightView addSubview:detailLabel];
        
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(rightView);
            make.left.mas_equalTo(leftView.mas_right);
            make.right.mas_equalTo(rightView).offset(-FITSCALE(10));
            make.height.mas_equalTo( rightView);
        }];
        
       
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftView.mas_right);
            make.right.mas_equalTo(bgView);
            make.centerY.mas_equalTo(leftView);
            make.height.mas_equalTo(bgView);
        }];
       
        
    }
    
}

- (void)configSexContentView:(NSString *)normal contentHeight:(CGFloat)contentHeight{

    UIButton * manBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [manBtn setImage:[UIImage imageNamed:@"man_normal"] forState:UIControlStateNormal];
    [manBtn setImage:[UIImage imageNamed:@"man_selected"] forState:UIControlStateSelected];
    [manBtn setTitleColor:UIColorFromRGB(0x6b6b6b) forState:UIControlStateNormal];
    [manBtn setTitleColor:project_main_blue forState:UIControlStateSelected];
    NSString * manBtntitle =  @"男士";
    [manBtn setTitle:manBtntitle forState:UIControlStateNormal];
     manBtn.titleLabel.font = fontSize_14;
    [manBtn addTarget:self action:@selector(manBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    manBtn.tag = manBtnTag;
  
    [self.contentView addSubview:manBtn];
    
    UIButton * wumanBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [wumanBtn setImage:[UIImage imageNamed:@"wan_normal"] forState:UIControlStateNormal];
    [wumanBtn setImage:[UIImage imageNamed:@"wan_selected"] forState:UIControlStateSelected];
    wumanBtn.tag = wumanBtnTag;
    [wumanBtn addTarget:self action:@selector(wumanBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [wumanBtn setTitleColor:UIColorFromRGB(0x6b6b6b) forState:UIControlStateNormal];
    [wumanBtn setTitleColor:project_main_blue forState:UIControlStateSelected];
    NSString * wumanBtntitle =  @"女士";
    [wumanBtn setTitle:wumanBtntitle forState:UIControlStateNormal];
    
    wumanBtn.titleLabel.font = fontSize_14;
    [self.contentView addSubview:wumanBtn];


    [manBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        
        make.height.mas_equalTo(contentHeight);
        make.right.mas_equalTo(self.contentView.mas_centerX).offset(0);
        make.top .mas_equalTo(self.contentView.mas_top).offset(-10);
        
    }];
//
    [wumanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.top .mas_equalTo(self.contentView.mas_top).offset(-10);
        make.height.mas_equalTo(contentHeight);
        make.left.mas_equalTo(self.contentView.mas_centerX);
    }];
    
    CGFloat space = 0;
  
    CGSize btnTitleSize = [self getTitleSize: manBtn.currentTitle ];
    CGSize btnImageSize =  manBtn.currentImage.size;
    
    if (iPhone5) {
        space= btnTitleSize.width-space;
    }else{
        
        space = btnTitleSize.width/2;
    }
    manBtn.imageEdgeInsets = UIEdgeInsetsMake( 0 ,space, 0, 0);//设置image在button
    manBtn.titleEdgeInsets = UIEdgeInsetsMake(btnImageSize.height + btnTitleSize.height, - btnImageSize.width , 0, 0);//设置title在button

    
    btnTitleSize = [self getTitleSize: wumanBtn.currentTitle ];
    btnImageSize =  wumanBtn.currentImage.size;
    if (iPhone5) {
        space= btnTitleSize.width-space;
    }else{
        
        space = btnTitleSize.width/2;
    }
    
    wumanBtn.imageEdgeInsets = UIEdgeInsetsMake(0, space, 0, 0);//设置image在button
    wumanBtn.titleEdgeInsets = UIEdgeInsetsMake(btnImageSize.height + btnTitleSize.height, - btnImageSize.width , 0, 0);//设置title在button
    
 
    if ([normal isEqualToString:@"男"]) {
        manBtn.selected = YES;
    }else{
        wumanBtn.selected = YES;
    }
    
}

- (CGSize )getTitleSize:(NSString *)attributeStr{
    NSDictionary *attr=@{NSFontAttributeName:fontSize_14};
      CGSize lableSize=[attributeStr boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
 
    return lableSize;
}



- (void)configSubjectsContentView:(NSString *)normal contentHeight:(CGFloat)contentHeight{

    self.subjects = @"004";
    for (int i = 0; i< 4; i++) {
        NSString * btntitle =  @"";
        NSInteger  tag = 0;
        
       
        
        UIButton * btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setTitleColor:UIColorFromRGB(0x4D4D4D) forState:UIControlStateNormal];
        [btn setTitleColor:HexRGB(0xffffff) forState:UIControlStateSelected];
        btn.titleLabel.font = systemFontSize(13);
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 4;

        [btn setBackgroundImage:[UIImage mm_imageWithColor:HexRGB(0xF4F4F4)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage mm_imageWithColor:HexRGB(0x2DB5FF)] forState:UIControlStateSelected];

        [btn addTarget:self action:@selector(subjectAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:btn];
        
        CGFloat sizde =  36;
        
        if (i == 0) {
            btntitle = @"语文";
            tag = ChineseBtnTag;
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
                make.height.mas_equalTo(sizde);
                make.right.mas_equalTo(self.contentView.mas_centerX).offset(-15);
                 make.left.mas_equalTo(self.contentView.mas_left).offset(30);
                make.top .mas_equalTo(self.contentView.mas_top).offset(5);
                
            }];
        }else if (i == 1){
            btntitle = @"数学";
            tag = MathematicsBtnTag;
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.height.mas_equalTo(sizde);
                make.left.mas_equalTo(self.contentView.mas_centerX).offset(15);
                make.right.mas_equalTo(self.contentView.mas_right).offset(-30);
                make.top .mas_equalTo(self.contentView.mas_top).offset(5);
            }];
        }else if (i == 2){
            btntitle = @"英语";
            tag = EnglishBtnTag;
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.height.mas_equalTo(sizde);
                make.right.mas_equalTo(self.contentView.mas_centerX).offset(-15);
                make.left.mas_equalTo(self.contentView.mas_left).offset(30);
                make.top .mas_equalTo(self.contentView.mas_top).offset(55);
            }];
        }
        else if (i == 3){
        
            btntitle = @"其它";
            tag = OtherBtnTag;
            btn.selected = YES;
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.height.mas_equalTo(sizde);
                make.left.mas_equalTo(self.contentView.mas_centerX).offset(15);
                make.right.mas_equalTo(self.contentView.mas_right).offset(-30);
                make.top .mas_equalTo(self.contentView.mas_top).offset(55);
            }];
        }
        btn.tag = tag;
        [btn setTitle:btntitle forState:UIControlStateNormal];
    }
}
- (void)subjectAction:(UIButton *)sender{

    if (!sender.selected) {
        sender.selected = YES;
    }
    
    if (sender.selected) {
        
        sender.layer.borderColor = project_main_blue.CGColor;
    
        for (UIView * view in self.contentView.subviews) {
            
            if ([view isKindOfClass:[UIButton class]]  && view.tag !=sender.tag) {
                UIButton * btn = (UIButton *)view ;
                btn.selected = NO;
                btn.layer.borderColor = UIColorFromRGB(0x898989).CGColor;
                
            }
            if ([view isKindOfClass:[UIImageView class]]   ) {
                UIImageView * imgV = (UIImageView *)view ;
                imgV.hidden = YES;
            
                
            }
        }
    }
    
    WEAKSELF
    if (sender.tag == ChineseBtnTag) {
        
        self.subjects = @"001";
        UIImageView * arrow = [self.contentView viewWithTag:ChineseChooseImgVTag];
        arrow.hidden = NO;
    }else if (sender.tag == EnglishBtnTag){
        
        self.subjects = @"003";
        UIImageView * arrow = [self.contentView viewWithTag:EnglishChooseImgVTag];
        arrow.hidden = NO;
    }else if (sender.tag == MathematicsBtnTag){
        self.subjects = @"002";
        UIImageView * arrow = [self.contentView viewWithTag:MathematicsChooseImgVTag];
        arrow.hidden = NO;
    }else if (sender.tag == OtherBtnTag){
        
        self.subjects = @"004";
        UIImageView * arrow = [self.contentView viewWithTag:OtherChooseImgVTag];
        arrow.hidden = NO;
    }
    
    
}
- (void)manBtnAction:(UIButton *)btn{

    btn.selected = YES;
    UIButton * otherBtn = [self.contentView viewWithTag:wumanBtnTag];
    otherBtn.selected = NO;
}

- (void)wumanBtnAction:(UIButton *)btn{
    
    btn.selected = YES;
    UIButton * otherBtn = [self.contentView viewWithTag:manBtnTag];
    otherBtn.selected = NO;
}
- (void)configTimerContentView:(CGFloat ) contentHeight{

    CGFloat leftW = 100 *scale_x;
    NSArray * titleArray = @[@"今天",@"明天",@"本周",@"本月"];
    CGFloat  margin  = 5;
    CGFloat  btnItemHeight = (contentHeight- margin*5)/[titleArray count];
    for (int i = 0; i < [titleArray count]; i++) {
   
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(10, (i%[titleArray count])*(btnItemHeight + margin), leftW-20 , btnItemHeight)];
        [button setTitleColor:project_main_blue forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setBackgroundImage:[ProUtils createImageWithColor:project_main_blue withFrame:CGRectMake(0, 0, IPHONE_WIDTH, 1)] forState:UIControlStateSelected];
         [button setBackgroundImage:[ProUtils createImageWithColor:project_main_blue withFrame:CGRectMake(0, 0, IPHONE_WIDTH, 1)] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[ProUtils createImageWithColor:[UIColor clearColor] withFrame:CGRectMake(1, 1, 1, 1)] forState:UIControlStateNormal];
        button.layer.borderColor = project_main_blue.CGColor;
        button.layer.borderWidth = 0.5;
        if (i ==0) {
            button.selected = YES;
        }else
            button.selected = NO;
        button.tag = i+ 1000;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = btnItemHeight/2;
        button.layer.masksToBounds =  YES;
        [self.contentView addSubview:button];
    }
    
    self.datePicker = [ [DatePicker alloc] initWithFrame:CGRectMake(0,0,0,0)];
    self.datePicker.backgroundColor = [UIColor clearColor];
   [ self.contentView addSubview:self.datePicker ];
    
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(0);
        make.left.equalTo(self.contentView).offset(leftW);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(self.contentView.mas_height);
      
    }];
}

- (void)buttonAction:(UIButton *)button{

    if (button.selected) {
        
        return;
    }
    
    for (id  view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton * btn = view;
            btn.selected =  NO;
        }
    }
    button.selected =  YES;
    switch (button.tag) {
        case 1000:
            
            //今天
            [self.datePicker today];
            break;
        case 1001:
            //明天
            [self.datePicker tomorrow];
            
            break;
        case 1002:
            //本周
            [self.datePicker thisWeek];
            break;
        case 1003:
            //本月
            [self.datePicker thisMonth];
            break;
            
        default:
            break;
    }
    
}


#pragma mark ---倒计时---
- (void)initTimer{

    if (!self.sendTimer) {
       self.sendTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(sendSms) userInfo:nil repeats:YES];
    }
    
}


- (void)sendSms{
    
    NSDate *sDate = self.fireDate;
    NSTimeInterval t = [[NSDate date] timeIntervalSinceDate:sDate];
    NSInteger timeT = 60 - t;
    if (timeT <= 0)
    {
        [self.smsButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.smsButton setUserInteractionEnabled:YES];
        [self.sendTimer setFireDate:[NSDate distantFuture]];
        [self.smsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.smsButton.backgroundColor = project_main_blue;
        return ;
    }
    self.smsButton.userInteractionEnabled = NO;
    [self.smsButton setTitle:[NSString stringWithFormat:@"%zd秒", timeT] forState:UIControlStateNormal];
    [self.smsButton setBackgroundColor:UIColorFromRGB(0xcdd2da)];
    [self.smsButton setTitleColor: UIColorFromRGB(0x9ca1ab) forState:UIControlStateNormal];
  
    
}

- (void)startTimer{

     self.fireDate = [NSDate date];
    [self.sendTimer setFireDate:[NSDate date]];
}

- (void)endTimer{

    [self.sendTimer invalidate];
    self.sendTimer = nil;
}
#pragma mark ----
@end

@interface AlertViewConfig()

@end

@implementation AlertViewConfig

+ (AlertViewConfig *)globalConfig
{
    static AlertViewConfig *config;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        config = [AlertViewConfig new];
        
    });
    
    return config;
}

- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.width          = 275.0f;
        self.buttonHeight   = FITSCALE(36.0f);
        self.innerMargin    = 25.0f;
        self.cornerRadius   = 5.0f;
        
        self.titleFontSize  = 18.0f;
        self.detailFontSize = 14.0f;
        self.buttonFontSize = 17.0f;
        self.titleBackgroundColor = project_main_blue;
        self.backgroundColor    = MMHexColor(0xFFFFFFFF);
        self.titleTextColor      = [UIColor whiteColor] ;

        self.detailColor        = UIColorFromRGB(0x9B9B9B);
        self.splitColor         = MMHexColor(0xCCCCCCFF);
        
 
        self.itemWidth          = (self.width - (-MM_SPLIT_WIDTH*3))/2;
        self.itemNormalColor    = [UIColor whiteColor];
        self.itemPressedColor   = project_main_blue;
        self.itemPressedLayerColor =  [UIColor whiteColor];
        self.itemNormalLayerColor    = project_main_blue;
        self.itemNormalTitleColor = project_main_blue;
        self.itemPressedTitleColor = [UIColor whiteColor];
        self.itemCornerRadius     =  5;
        self.defaultTextOK      = @"好";
        self.defaultTextCancel  = @"取消";
        self.defaultTextConfirm = @"确定";
    }
    
    return self;
}

@end



@interface DatePicker()<UIPickerViewDelegate, UIPickerViewDataSource>
@property(nonatomic, strong)UIPickerView *pickerView;

@property (strong, nonatomic) NSMutableArray *arrayMonths;
@property (strong, nonatomic) NSMutableArray *arrayDays;

@property (copy, nonatomic) NSString *strYear;      //  年
@property (copy, nonatomic) NSString *strMonth;     //  月
@property (copy, nonatomic) NSString *strDay;       //  日

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation DatePicker

- (instancetype)initWithFrame:(CGRect)frame{

    if (self == [super initWithFrame: frame]) {
        [self initData];
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
      
        [self initView];
        [self initData];
    }
    return self;
}

- (void)updatePickerDate:(NSDate *)date{
    [self.arrayDays removeAllObjects];
    //  更新月份
    NSInteger currentMonth = [date getMonth];
    NSString *strMonth = [NSString stringWithFormat:@"%02li", currentMonth];
    NSInteger indexMonth = [self.arrayMonths indexOfObject:strMonth];
    if (indexMonth == NSNotFound) {
        indexMonth = 0;
    }
    [self.pickerView selectRow:indexMonth inComponent:0 animated:YES];
    self.strMonth = self.arrayMonths[indexMonth];
    
    NSInteger allDays = [self totaldaysInMonth:date];
    for (int i = 1; i <= allDays; i++) {
        NSString *strDay = [NSString stringWithFormat:@"%02i", i];
        [self.arrayDays addObject:strDay];
    }
    
      [self.pickerView reloadComponent:1];
    //  更新日
    NSInteger currentDay = [date getDay];
    NSString *strDay = [NSString stringWithFormat:@"%02li", currentDay];
    NSInteger indexDay = [self.arrayDays indexOfObject:strDay];
    if (indexDay == NSNotFound) {
        indexDay = 0;
    }
    self.strDay = strDay;
    [self.pickerView selectRow:indexDay inComponent:1 animated:YES];

}
- (void)today{

    [self updatePickerDate:[NSDate date]];
  
}

- (void)tomorrow{
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:  0];
    
    [adcomps setMonth:0];
    
    [adcomps setDay:1];
    NSDate *newDate  = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
     [self updatePickerDate:newDate ];
}

- (void)thisWeek{
 
    
    NSDate * now = [NSDate date];
    NSCalendar *calendar ;
#ifdef __IPHONE_8_0
    calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
    calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
#endif
    calendar.timeZone = [NSTimeZone localTimeZone];
    calendar.locale = [NSLocale currentLocale];
    [calendar setFirstWeekday:2];//设定周一为周首日
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit
                                         fromDate:now];
   
    // 得到星期几
    // 1(星期天) 2(星期一) 3(星期二) 4(星期三) 5(星期四) 6(星期五) 7(星期六)
    NSInteger weekDay = [comp weekday];
    // 得到几号
    NSInteger day = [comp day];
    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff,lastDiff;
    if (weekDay == 1) {
        firstDiff = -6;
        lastDiff = 0;
    }else{
        firstDiff = [calendar firstWeekday] - weekDay+1;
        lastDiff = 9 - weekDay -1;
    }
    // 在当前日期(去掉了时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek= [calendar dateFromComponents:firstDayComp];
    
    NSDateComponents *lastDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [lastDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek= [calendar dateFromComponents:lastDayComp];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLog(@"星期一开始 %@",[formater stringFromDate:firstDayOfWeek]);
   
    NSLog(@"星期天结束 %@",[formater stringFromDate:lastDayOfWeek]);
    
  
    [self updatePickerDate:lastDayOfWeek ];


}

- (void)thisMonth{
    
 
 
     NSDate * newDate = [NSDate date];
 
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar ;
#ifdef __IPHONE_8_0
    calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
    calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
#endif
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"YYYY.MM.dd"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    NSLog(@"本月开始-%@-%@-结束",beginString,endString);
    
    [self updatePickerDate:endDate ];
}

- (void)initData{
 
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyyMM";
    
    NSInteger allDays = [self totaldaysInMonth:[NSDate date]];
    for (int i = 1; i <= allDays; i++) {
        NSString *strDay = [NSString stringWithFormat:@"%02i", i];
        [self.arrayDays addObject:strDay];
    }
    
    
    //  更新年
   NSInteger currentYear = [[NSDate date] getYear];
   self.strYear = [NSString stringWithFormat:@"%04li", currentYear];
    
    [self updatePickerDate:[NSDate date]];
    

    
}
- (void)initView{
 
    [self addSubview:self.pickerView];
    
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self) ;
        make.left.equalTo(self) ;
        make.right.equalTo(self);
        make.height.mas_equalTo(self.mas_height);
        
    }];

   

    
   
}

- (UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView =  [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
         _pickerView.backgroundColor = [UIColor clearColor];
         self.pickerView.showsSelectionIndicator = YES;
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;

    }
    return _pickerView;
    
}

- (NSMutableArray *)arrayMonths
{
    if (!_arrayMonths) {
        _arrayMonths = [NSMutableArray array];
        
        for (int i = 1; i <= 12; i++) {
            NSString *str = [NSString stringWithFormat:@"%02i", i];
            [_arrayMonths addObject:str];
        }
    }
    
    return _arrayMonths;
}
- (NSMutableArray *)arrayDays
{
    if (!_arrayDays) {
        _arrayDays = [NSMutableArray array];
    }
    
    return _arrayDays;
}

#pragma mark - 计算出当月有多少天
- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

#pragma mark - UIPickerView DataSource and Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger count =0;
    if (component == 0) {
      count = self.arrayMonths.count;
    } else if (component == 1 ){
       count = self.arrayDays.count;
    }
    return count;
               
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{

    return 80;
}
- ( NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString * title =@"";
    if (component == 0) {
         title = [NSString stringWithFormat:@"%@月",self.arrayMonths[row]];
    
    } else if (component == 1) {
        title =  [NSString stringWithFormat:@"%@日", self.arrayDays[row]];
  
    }

    return  title;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
     if (component == 0) {
        self.strMonth = self.arrayMonths[row];
    } else {
       
         self.strDay = self.arrayDays[row];
        if ([self.strMonth integerValue] ==[[NSDate date] getMonth] && [self.strDay integerValue] <[[NSDate date] getDay]) {
            NSInteger currentDay = [[NSDate date] getDay];
            NSString *strDay = [NSString stringWithFormat:@"%02li", currentDay];
            NSInteger indexDay = [self.arrayDays indexOfObject:strDay];
            if (indexDay ==NSNotFound) {
                indexDay = 0;
            }
            [self.pickerView selectRow:indexDay inComponent:1 animated:YES];
        }
    }
    
    [self updateLabelText];
    
    if (component != 1) {
        NSString *strDate = [NSString stringWithFormat:@"%@%@", self.strYear, self.strMonth];
        [self upDateCurrentAllDaysWithDate:[self.dateFormatter dateFromString:strDate]];
    }
}

#pragma mark - 更新当前label的日期
- (void)updateLabelText
{
//    self.dateLabel.text = [NSString stringWithFormat:@"%@年%@月%@日", self.strYear, self.strMonth, self.strDay];
}

#pragma mark - 更新选中的年、月份时的日期
- (void)upDateCurrentAllDaysWithDate:(NSDate *)currentDate
{
    [self.arrayDays removeAllObjects];
    
    NSInteger allDays = [self totaldaysInMonth:currentDate];
    for (int i = 1; i <= allDays; i++) {
        NSString *strDay = [NSString stringWithFormat:@"%02i", i];
        [self.arrayDays addObject:strDay];
    }
    
    [self.pickerView reloadComponent:1];
    
    //  更新日
    NSInteger indexDay = [self.arrayDays indexOfObject:self.strDay];
    if (indexDay == NSNotFound) {
        indexDay = (self.arrayDays.count - 1) > 0 ? (self.arrayDays.count - 1) : 0;
    }
    [self.pickerView selectRow:indexDay inComponent:1 animated:YES];
    self.strDay = self.arrayDays[indexDay];
    
    [self updateLabelText];
}

- (NSString *)getSelectedDate{
    
    if ([self.strMonth integerValue] < [[NSDate date] getMonth]) {
        self.strYear  =[NSString stringWithFormat:@"%04li",[self.strYear integerValue]+1];
        
    }
     NSString * dateStr = [NSString stringWithFormat:@"%@-%@-%@ 23:59", self.strYear, self.strMonth, self.strDay];
    return dateStr;
}

@end
