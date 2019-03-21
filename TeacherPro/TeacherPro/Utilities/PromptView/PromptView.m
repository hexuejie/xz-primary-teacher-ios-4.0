//
//  PromptView.m
//  TeacherPro
//
//  Created by DCQ on 2017/5/2.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "PromptView.h"
#import "CommonConfig.h"
#import "TextField.h"
#import "ProUtils.h"

#define TEXTFIELD_TAG   898989
#define TOUCHBUTTON_TAG   898990
@interface PromptView ()
@property (nonatomic,strong) UIView *shadowView;
@end
@implementation PromptView

+(PromptView *)shareAlertInstance{
    
    static dispatch_once_t once;
    static PromptView *shareAlertView;
    dispatch_once(&once, ^{
        shareAlertView= [[PromptView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
    });
    return shareAlertView;
}

+(void)dismissAlertView{
    [UIView animateWithDuration:.2f delay:.15f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [PromptView shareAlertInstance].alpha = 0.0f;
    } completion:^(BOOL finished) {
        [[PromptView shareAlertInstance] removeFromSuperview];
    }];
}

+ (void)removeAlertView{
    
    [[PromptView shareAlertInstance] removeFromSuperview];
    
}

#pragma mark----
+ (void  )initAlertBackground{
    
    if ([PromptView shareAlertInstance].superview)
    {
        return ;
    }
    else
    {
        for (UIView *view in [PromptView shareAlertInstance].subviews)
        {
            [view removeFromSuperview];
        }
    }
    [PromptView shareAlertInstance].shadowView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [[PromptView shareAlertInstance] addSubview:[PromptView shareAlertInstance].shadowView];
    [PromptView shareAlertInstance].shadowView.alpha=1;
    [PromptView shareAlertInstance].shadowView.backgroundColor=[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:0.45f];
    
    
    
    [PromptView shareAlertInstance].alpha=0.0f;
    [[UIApplication sharedApplication].keyWindow addSubview:[PromptView shareAlertInstance]];
    
    [UIView animateWithDuration:.20f animations:^{
        [PromptView shareAlertInstance].alpha = 1.0f;
    }];
    
}

+ (UIView *)initAlertViewTitle:(NSString *)title withAlertSize:(CGSize )size wichAlertTitleViewHeight:(CGFloat) titleViewHeight{
    
    [PromptView initAlertBackground];
    
    UIView *alertview=[[UIView alloc]init];
    alertview.backgroundColor=[UIColor whiteColor];
    alertview.layer.cornerRadius= btn_cornerRadius *2;
    [[PromptView shareAlertInstance].shadowView addSubview:alertview];
    [alertview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake( size.width*scale_x, FITSCALE(size.height)));
        make.center.mas_equalTo([PromptView shareAlertInstance].shadowView);
    }];
    
    UIView * titleBackView  = [[UIView alloc]init];
    titleBackView.backgroundColor =   UIColorFromRGB(0x2970FE);
    [alertview addSubview:titleBackView];
    if (title.length>0) {
        [titleBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(alertview);
            make.centerX.mas_equalTo(alertview);
            make.height.mas_equalTo( FITSCALE(titleViewHeight));
            make.top.mas_equalTo(alertview);
        }];
    }
    
    UILabel *titleLabel= [PromptView initLabelText:title withTextColor:[UIColor whiteColor] withFont:fontSize_16 withTextAlignment:NSTextAlignmentCenter];
    
    
    [titleBackView addSubview:titleLabel];
    
    if(title.length > 0){
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(alertview).offset(10*scale_y);
            make.centerX.mas_equalTo(alertview);
            make.height.mas_equalTo(20*scale_y );
        }];
    }
    
    
    UIView *borderView = [[UIView alloc]init];
    borderView.backgroundColor = tn_border_color;
    [alertview addSubview:borderView];
    if(title.length > 0){
        [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(FITSCALE(titleViewHeight));
            make.width.mas_equalTo(alertview);
            make.centerX.mas_equalTo(alertview);
            make.height.mas_equalTo(FITSCALE(0.5));
        }];
    }
    
    
    return alertview ;
}

+ (TouchButton *)initTouchButtonTitle:(NSString *)title withNormalTitleColor:(UIColor *) normalColor withbackgroundColor:(UIColor *)backgroundColor withTouchBlock:(TouchBlock)touchBlock witchBorderColor:(UIColor *)borderColor  {
    
    TouchButton *tochButton=[[TouchButton alloc]init];
    [tochButton setTitle:title forState:UIControlStateNormal];
    tochButton.titleLabel.font= fontSize_14;
    
    [tochButton setTitleColor:normalColor  forState:UIControlStateNormal];
    [tochButton setBackgroundColor:backgroundColor];
    tochButton.touchBlock = touchBlock;
    tochButton.layer.cornerRadius = 4;
    tochButton.layer.borderWidth = 1;
    tochButton.layer.borderColor =  borderColor.CGColor;
    return tochButton;
    
    
}

+ (UILabel *)initLabelText:(NSString *)text withTextColor:(UIColor *)textColor withFont:(UIFont *)font withTextAlignment:( NSTextAlignment)textAlignamet  {
    
    UILabel *label =    [[UILabel alloc] init];
    label.text = text;
    label.textColor = textColor;
    label.font = font;
    label.textAlignment = textAlignamet;
    [label setNumberOfLines:0];
    return label;
}
+ (void)initBottomViewSureTitle:(NSString *)sureT withDoneBlock:(TouchBlock)doneblock withCancelTitle:(NSString *)cancelT withCancelBlock:(TouchBlock )cancelBlock withView:(UIView *)alertView{
    
    CGFloat  btnW =  100;
    CGFloat  btnH =  34;
    CGFloat  btnSpace = 10;
    if(doneblock){
        
        //        NSString * sureT = @"同意";
        
        TouchBlock sureBtnBlock = doneblock? (^{
            [PromptView dismissAlertView];
            doneblock();
        }) :(^{[PromptView dismissAlertView];});
        TouchButton *sureBtn = [PromptView initTouchButtonTitle:sureT withNormalTitleColor:[UIColor whiteColor] withbackgroundColor:project_main_blue withTouchBlock:sureBtnBlock  witchBorderColor:[UIColor clearColor]];
        
        
        [alertView addSubview:sureBtn];
        
        
        
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(alertView.mas_bottom).offset(FITSCALE(-btnSpace));
            make.height.mas_equalTo(FITSCALE(btnH));
            
            if(doneblock&&cancelBlock){
                make.width.mas_equalTo(FITSCALE(btnW));
                
                make.centerX.mas_equalTo(alertView.mas_centerX).offset(FITSCALE(btnW/2 + btnSpace));
            }else{
                make.centerX.mas_equalTo(alertView);
                make.width.mas_equalTo(FITSCALE(btnW));
            }
        }];
        
    }
    
    if(cancelBlock){
        
        //        NSString * cancelT = @"拒绝";
        
        
        TouchButton *cancelButton = [PromptView initTouchButtonTitle:cancelT withNormalTitleColor:project_main_blue withbackgroundColor:[UIColor whiteColor] withTouchBlock:cancelBlock  witchBorderColor:project_main_blue];
        
        
        [alertView addSubview:cancelButton];
        
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(alertView.mas_bottom).offset(FITSCALE(-btnSpace));
            make.height.mas_equalTo(FITSCALE(btnH));
            
            if(doneblock&&cancelBlock){
                make.width.mas_equalTo(FITSCALE(btnW));
                
                make.centerX.mas_equalTo(alertView.mas_centerX).offset(FITSCALE(-btnW/2-btnSpace));
            }else{
                make.centerX.mas_equalTo(alertView);
                make.width.mas_equalTo(FITSCALE(btnW));
            }
        }];
    }
}

#pragma mark----



+ (void)showrResultViewWithTitle:(NSString *)title content:(NSString *)content cancelButtonTitle:(NSString *)cancelT sureButtonTitle:(NSString *)sureT withDoneBlock:(TouchBlock)doneblock withCancelBlock:(TouchBlock)cancelBlock{
    
    
    
    CGFloat alertHeight =  40 + 60 +[PromptView heightForString:content andWidth: 270*scale_x -40*scale_x];
    CGSize alertSize = CGSizeMake(270, alertHeight);
    
    CGFloat titleViewHeight =  40;
    UIView * alertView = [PromptView  initAlertViewTitle:title withAlertSize:alertSize wichAlertTitleViewHeight:titleViewHeight];
    
    UILabel *contentLabel =   [PromptView initLabelText:content withTextColor:tn_dark_gray withFont:fontSize_12 withTextAlignment:NSTextAlignmentCenter];
    
    [alertView addSubview:contentLabel];
    
    
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(alertView).offset(20*scale_x);
        make.right.mas_equalTo(alertView).offset(-20*scale_x);
        make.bottom.mas_equalTo(alertView.mas_bottom).offset(-44*scale_y);
        make.top.mas_equalTo(alertView.mas_top).offset(titleViewHeight*scale_y);
    }];
    
    [PromptView initBottomViewSureTitle:sureT withDoneBlock:doneblock withCancelTitle:cancelT withCancelBlock:cancelBlock withView:alertView];
    
    
}





+ (void)showInvitationResultViewWithContent:(NSString *)content withDoneBlock:(TouchBlock)doneblock withCancelBlock:(TouchBlock)cancelblock  {
    
    UIView *alertView = [PromptView initAlertViewTitle:nil withAlertSize:CGSizeMake(IPHONE_WIDTH, IPHONE_WIDTH) wichAlertTitleViewHeight:0];
    
    alertView.backgroundColor = [UIColor clearColor];
    UIImageView *resultbackground;
    resultbackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Invitation"]];
    resultbackground.contentMode =  UIViewContentModeScaleAspectFit;
    
    [alertView addSubview:resultbackground];
    
    [resultbackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(alertView);
        make.centerX.mas_equalTo(alertView);
        make.left.mas_equalTo(alertView).mas_offset(20.f);
        make.trailing.mas_equalTo(alertView.mas_trailing).mas_offset(-20.f);
        make.bottom.mas_equalTo(alertView);
        
    }];
    
    
    
    
    
    UILabel *contentLabel =  [PromptView initLabelText:content withTextColor:tn_dark_gray withFont:fontSize_12 withTextAlignment:NSTextAlignmentCenter];
    [alertView addSubview:contentLabel];

    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(alertView).offset(20*scale_x);
        make.right.mas_equalTo(alertView).offset(-20*scale_x);
        make.bottom.mas_equalTo(alertView.mas_bottom).offset(-44*scale_y);
        make.top.mas_equalTo(alertView).offset(20);
    }];
    
    
    [PromptView initBottomViewSureTitle:@"同意" withDoneBlock:doneblock withCancelTitle:@"拒绝" withCancelBlock:cancelblock withView:alertView];
    
}




+ (UIImage*) createImageWithColor: (UIColor*) color withFrame:(CGRect)rect
{
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

/**
 @method 获取指定宽度width,字体大小fontSize,字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param Width 限制字符串显示区域的宽度
 @result float 返回的高度
 */
+ (float) heightForString:(NSString *)value andWidth:(float)width{
    //获取当前文本的属性
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:value];
    
    NSRange range = NSMakeRange(0, attrStr.length);
    // 获取该段attributedString的属性字典
    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
    // 计算文本的大小
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width - 16.0, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                        attributes:dic        // 文字的属性
                                           context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    return sizeToFit.height + 16.0;
}

//创建班级
+ (void)showTextFeildViewWithTitle:(NSString *)title content:(NSString *)content withPlaceholder:(NSString *)placeholder  withDoneBlock:(NewClassSureTouchBlock)doneblock withCancelBlock:(TouchBlock)cancelBlock{
    
    
    CGFloat alertHeight =  40 + 60 +40+[PromptView heightForString:content andWidth: 270*scale_x -40*scale_x];
    
    UIView *alertView = [PromptView initAlertViewTitle:title withAlertSize:CGSizeMake(270, alertHeight) wichAlertTitleViewHeight:40];
    
    
    
    UILabel *contentLabel = [PromptView initLabelText:content withTextColor:tn_lighter_gray withFont:fontSize_10 withTextAlignment:NSTextAlignmentCenter];
    
    [alertView addSubview:contentLabel];
    
    if (content &&[content length] > 0) {
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(alertView).offset(20*scale_x);
            make.right.mas_equalTo(alertView).offset(-20*scale_x);
            make.top.mas_equalTo(alertView.mas_top).offset(50);
        }];
        
    }
    
    TextField * textField = [[TextField alloc]init];
    [textField setPlaceholder:placeholder];
    textField.font =  fontSize_12;
    textField.textColor = tn_dark_gray;
    textField.tag =  TEXTFIELD_TAG;
    textField.layer.masksToBounds = YES;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.layer.borderColor =  [UIColor grayColor].CGColor;
    textField.layer.borderWidth = FITSCALE(0.5);
    textField.layer.cornerRadius =  FITSCALE(30)/2;
    textField.backgroundColor = UIColorFromRGB(0xEAEAEA);
    textField.textFieldBlock = ^(NSString * input){
        if (input > 0) {
            ((TouchButton *)[alertView viewWithTag:TOUCHBUTTON_TAG]).inputText = input;
        }else{
            
            
        }
        
    };
    [alertView addSubview:textField];
    
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(alertView).offset(20*scale_x);
        make.right.mas_equalTo(alertView).offset(-20*scale_x);
        make.height.mas_equalTo(FITSCALE(30));
        make.top.mas_equalTo(contentLabel.mas_bottom).offset(10);
    }];
    
    CGFloat  btnW =  100;
    CGFloat  btnH =  34;
    CGFloat  btnSpace = 10;
    
    if(doneblock){
        TouchButton * doneButton = [PromptView initTouchButtonTitle:@"下一步" withNormalTitleColor:[UIColor whiteColor] withbackgroundColor:project_main_blue withTouchBlock:nil  witchBorderColor:[UIColor clearColor]];
        doneButton.inputText = ((TextField *)[alertView viewWithTag:TEXTFIELD_TAG]).text;
        doneButton.newClassBlock = ^(NSString *inputText){
            if (inputText.length >0) {
                doneblock(inputText);
            }else{
                TextField *tf = [alertView viewWithTag:TEXTFIELD_TAG];
                [ProUtils shake:tf];
            }
        };
        doneButton.tag = TOUCHBUTTON_TAG;
        
        [alertView addSubview:doneButton];
        
        [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(alertView.mas_bottom).offset(FITSCALE(-btnSpace));
            make.height.mas_equalTo(FITSCALE(btnH));
            
            if(doneblock&&cancelBlock){
                make.width.mas_equalTo(FITSCALE(btnW));
                
                make.centerX.mas_equalTo(alertView.mas_centerX).offset(FITSCALE(btnW/2+btnSpace));
            }else{
                make.centerX.mas_equalTo(alertView);
                make.width.mas_equalTo(FITSCALE(btnW));
            }
        }];
        
        
    }
    
    if(cancelBlock){
        
        TouchButton *cancelButton = [PromptView initTouchButtonTitle:@"取消" withNormalTitleColor:project_main_blue withbackgroundColor:[UIColor whiteColor] withTouchBlock:cancelBlock  witchBorderColor:project_main_blue];
        
        
        [alertView addSubview:cancelButton];
        
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(alertView.mas_bottom).offset(FITSCALE(-btnSpace));
            make.height.mas_equalTo(FITSCALE(btnH));
            
            if(doneblock&&cancelBlock){
                make.width.mas_equalTo(FITSCALE(btnW));
                make.centerX.mas_equalTo(alertView.mas_centerX).offset(FITSCALE(-btnW/2-btnSpace));
            }else{
                make.centerX.mas_equalTo(alertView);
                make.width.mas_equalTo(FITSCALE(btnW));
            }
        }];
        
    }
    
    
    
    
}



//转让班级
+ (void)showTransferTextFeildViewWithTitle:(NSString *)title content:(NSString *)content withPlaceholder:(NSString *)placeholder  withDoneBlock:(NewClassSureTouchBlock)doneblock withCancelBlock:(TouchBlock)cancelBlock{
    
    
    CGFloat alertHeight =  40 + 60 +40+[PromptView heightForString:content andWidth: 270*scale_x -40*scale_x];
    
    UIView *alertView = [PromptView initAlertViewTitle:title withAlertSize:CGSizeMake(270, alertHeight) wichAlertTitleViewHeight:40];
    
    
    
    UILabel *contentLabel = [PromptView initLabelText:content withTextColor:tn_dark_gray withFont:fontSize_12 withTextAlignment:NSTextAlignmentCenter];
    
    [alertView addSubview:contentLabel];
    
    if (content &&[content length] > 0) {
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(alertView).offset(20*scale_x);
            make.right.mas_equalTo(alertView).offset(-20*scale_x);
            make.top.mas_equalTo(alertView.mas_top).offset(60);
        }];
        
    }
    
    TextField * textField = [[TextField alloc]init];
    [textField setPlaceholder:placeholder];
    textField.font =  fontSize_12;
    textField.textColor = tn_dark_gray;
    textField.tag =  TEXTFIELD_TAG;
    textField.layer.masksToBounds = YES;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.layer.borderColor =  [UIColor grayColor].CGColor;
    textField.layer.borderWidth = FITSCALE(0.5);
    textField.layer.cornerRadius =  FITSCALE(30)/2;
    textField.backgroundColor = [UIColor whiteColor];
    textField.textFieldBlock = ^(NSString * input){
        if (input > 0) {
            ((TouchButton *)[alertView viewWithTag:TOUCHBUTTON_TAG]).inputText = input;
        }else{
            
            
        }
        
    };
    [alertView addSubview:textField];
    
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(alertView).offset(20*scale_x);
        make.right.mas_equalTo(alertView).offset(-20*scale_x);
        make.height.mas_equalTo(FITSCALE(30));
        make.top.mas_equalTo(contentLabel.mas_bottom).offset(10);
    }];
    
    CGFloat  btnW =  100;
    CGFloat  btnH =  34;
    CGFloat  btnSpace = 10;
    
    if(doneblock){
        TouchButton * doneButton = [PromptView initTouchButtonTitle:@"确定" withNormalTitleColor:[UIColor whiteColor] withbackgroundColor:project_main_blue withTouchBlock:nil  witchBorderColor:[UIColor clearColor]];
        doneButton.inputText = ((TextField *)[alertView viewWithTag:TEXTFIELD_TAG]).text;
        doneButton.newClassBlock = ^(NSString *inputText){
            if (inputText.length >0) {
                doneblock(inputText);
            }else{
                TextField *tf = [alertView viewWithTag:TEXTFIELD_TAG];
                [ProUtils shake:tf];
            }
        };
        doneButton.tag = TOUCHBUTTON_TAG;
        
        [alertView addSubview:doneButton];
        
        [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(alertView.mas_bottom).offset(FITSCALE(-btnSpace));
            make.height.mas_equalTo(FITSCALE(btnH));
            
            if(doneblock&&cancelBlock){
                make.width.mas_equalTo(FITSCALE(btnW));
                make.centerX.mas_equalTo(alertView.mas_centerX).offset(FITSCALE(btnW/2+btnSpace));
            }else{
                make.centerX.mas_equalTo(alertView);
                make.width.mas_equalTo(FITSCALE(btnW));
            }
        }];
        
        
    }
    
    if(cancelBlock){
        
        TouchButton *cancelButton = [PromptView initTouchButtonTitle:@"取消" withNormalTitleColor:project_main_blue withbackgroundColor:[UIColor whiteColor] withTouchBlock:cancelBlock  witchBorderColor:project_main_blue];
        
        
        [alertView addSubview:cancelButton];
        
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(alertView.mas_bottom).offset(FITSCALE(-btnSpace));
            make.height.mas_equalTo(FITSCALE(btnH));
            
            if(doneblock&&cancelBlock){
                make.width.mas_equalTo(FITSCALE(btnW));
                make.centerX.mas_equalTo(alertView.mas_centerX).offset(FITSCALE(-btnW/2-btnSpace));
            }else{
                make.centerX.mas_equalTo(alertView);
                make.width.mas_equalTo(FITSCALE(btnW));
            }
        }];
        
    }
    
    
    
    
}


//解散班级
+ (void)showDissolutionTextFeildViewWithTitle:(NSString *)title content:(NSString *)content withPlaceholder:(NSString *)placeholder  withDoneBlock:(NewClassSureTouchBlock)doneblock withCancelBlock:(TouchBlock)cancelBlock withCodeBtnTouchBlock:(TouchBlock)codeTouchBlock{
    
    
    CGFloat alertHeight =  40 + 60 +40+[PromptView heightForString:content andWidth: 270*scale_x -40*scale_x];
    
    UIView *alertView = [PromptView initAlertViewTitle:title withAlertSize:CGSizeMake(270, alertHeight) wichAlertTitleViewHeight:40];
    
    
    
    UILabel *contentLabel = [PromptView initLabelText:content withTextColor:tn_dark_gray withFont:fontSize_12 withTextAlignment:NSTextAlignmentCenter];
    
    [alertView addSubview:contentLabel];
    
    if (content &&[content length] > 0) {
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(alertView).offset(20*scale_x);
            make.right.mas_equalTo(alertView).offset(-20*scale_x);
            make.top.mas_equalTo(alertView.mas_top).offset(60);
        }];
        
    }
    UIView *  textFieldBackgroudView = [[UIView alloc]init];
    
    [alertView addSubview:textFieldBackgroudView];
    textFieldBackgroudView.layer.masksToBounds = YES;
    textFieldBackgroudView.layer.borderColor =  [UIColor grayColor].CGColor;
    textFieldBackgroudView.layer.borderWidth = FITSCALE(0.5);
    textFieldBackgroudView.layer.cornerRadius =  FITSCALE(30)/2;
    
    [textFieldBackgroudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(alertView).offset(20*scale_x);
        make.right.mas_equalTo(alertView).offset(-20*scale_x);
        make.height.mas_equalTo(FITSCALE(30));
        make.top.mas_equalTo(contentLabel.mas_bottom).offset(10);
    }];
    
    TouchButton * codeBtn = [TouchButton buttonWithType:UIButtonTypeCustom];
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeBtn setBackgroundColor:project_main_blue];
    [codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    codeBtn.titleLabel.font = fontSize_10;
    
    codeBtn.touchBlock = codeTouchBlock;
    [textFieldBackgroudView addSubview:codeBtn];
    [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(FITSCALE(60));
        make.right.mas_equalTo(alertView).offset(-20*scale_x);
        make.height.mas_equalTo(FITSCALE(30));
        make.top.mas_equalTo(contentLabel.mas_bottom).offset(10);
    }];
    
    
    
    TextField * textField = [[TextField alloc]init];
    [textField setPlaceholder:placeholder];
    textField.font =  fontSize_12;
    textField.textColor = tn_dark_gray;
    textField.tag =  TEXTFIELD_TAG;
    textField.layer.masksToBounds = YES;
    textField.textAlignment = NSTextAlignmentCenter;
    
    textField.backgroundColor = [UIColor whiteColor];
    textField.textFieldBlock = ^(NSString * input){
        if (input > 0) {
            ((TouchButton *)[alertView viewWithTag:TOUCHBUTTON_TAG]).inputText = input;
        }else{
            
            
        }
        
    };
    [alertView addSubview:textField];
    
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(alertView).offset(20*scale_x+FITSCALE(60));
        make.right.mas_equalTo(codeBtn.mas_left);
        make.height.mas_equalTo(FITSCALE(28));
        make.top.mas_equalTo(contentLabel.mas_bottom).offset(11);
    }];
    
    
    
    CGFloat  btnW =  100;
    CGFloat  btnH =  34;
    CGFloat  btnSpace = 10;
    
    if(doneblock){
        TouchButton * doneButton = [PromptView initTouchButtonTitle:@"确定" withNormalTitleColor:[UIColor whiteColor] withbackgroundColor:project_main_blue withTouchBlock:nil  witchBorderColor:[UIColor clearColor]];
        doneButton.inputText = ((TextField *)[alertView viewWithTag:TEXTFIELD_TAG]).text;
        doneButton.newClassBlock = ^(NSString *inputText){
            if (inputText.length >0) {
                doneblock(inputText);
            }else{
                TextField *tf = [alertView viewWithTag:TEXTFIELD_TAG];
                [ProUtils shake:tf];
            }
        };
        doneButton.tag = TOUCHBUTTON_TAG;
        
        [alertView addSubview:doneButton];
        
        [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(alertView.mas_bottom).offset(FITSCALE(-btnSpace));
            make.height.mas_equalTo(FITSCALE(btnH));
            
            if(doneblock&&cancelBlock){
                make.width.mas_equalTo(FITSCALE(btnW));
                make.centerX.mas_equalTo(alertView.mas_centerX).offset(FITSCALE(btnW/2+btnSpace));
            }else{
                make.centerX.mas_equalTo(alertView);
                make.width.mas_equalTo(FITSCALE(btnW));
            }
        }];
        
        
    }
    
    if(cancelBlock){
        
        TouchButton *cancelButton = [PromptView initTouchButtonTitle:@"取消" withNormalTitleColor:project_main_blue withbackgroundColor:[UIColor whiteColor] withTouchBlock:cancelBlock  witchBorderColor:project_main_blue];
        
        
        [alertView addSubview:cancelButton];
        
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(alertView.mas_bottom).offset(FITSCALE(-btnSpace));
            make.height.mas_equalTo(FITSCALE(btnH));
            
            if(doneblock&&cancelBlock){
                make.width.mas_equalTo(FITSCALE(btnW));
                make.centerX.mas_equalTo(alertView.mas_centerX).offset(FITSCALE(-btnW/2-btnSpace));
            }else{
                make.centerX.mas_equalTo(alertView);
                make.width.mas_equalTo(FITSCALE(btnW));
            }
        }];
        
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
