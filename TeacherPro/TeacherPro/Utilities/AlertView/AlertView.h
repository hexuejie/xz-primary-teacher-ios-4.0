//
//  AlertView.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/23.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "MMPopupView.h"
#import "MMPopupDefine.h"
 
typedef void(^MMPopupHandler)(NSString *text);
typedef void(^MMPopupCompletionHandler)(NSString *dateString);
typedef NS_ENUM(NSInteger,AlertViewType) {
     AlertViewType_Normal                   = 0  ,//默认弹出框
     AlertViewType_Image                         ,//弹出框有图片
     AlertViewType_TextFeildNormal               ,//弹出框默认有输入框的样式
     AlertViewType_InputPhoneNormal              , //输入手机号码
     AlertViewType_VerificationCodeTextFeild     ,//弹出框验证码输入框样式
     AlertViewType_TextCreateClass               ,//创建班级
     AlertViewType_CompletionTime                ,//选择时间
     AlertViewType_LogoInstructions              ,//标识说明
     AlertViewType_Sex                           ,//修改性别
     AlertViewType_Subjects                      ,//修改科目
};

typedef NS_ENUM(NSInteger,AlertBottomViewType) {
    
    AlertBottomViewType_normal                   = 0,
    AlertBottomViewType_buttonWidthfull             ,//均等自动均 等分
    AlertBottomViewType_buttonWidthCustom           ,//自定义按钮宽
    
    
};
typedef NS_ENUM(NSInteger,TextFieldViewRightMode) {
    
    TextFieldViewRightMode_Normal                   = 0,
    TextFieldViewRightMode_Always                      ,//显示
    TextFieldViewRightMode_Never                       ,//不显示
    
    
};

typedef NS_ENUM(NSInteger,TNOperationState) {
 

    TNOperationState_Normal                   = 0,//无
    TNOperationState_OK                       ,//成功
    TNOperationState_Fail                      ,//失败
    TNOperationState_Unknow                    ,//疑问
    
};
typedef void(^selectedSexBlock)(NSString * sex);
//科目
typedef void(^selectedSubjectsBlock)(NSString * subjects);
@interface AlertView : MMPopupView
@property(nonatomic, copy) NSString * verificationText;
@property(nonatomic, copy) selectedSexBlock sexBlock;
@property(nonatomic, copy) selectedSubjectsBlock subjectsBlock;
@property (nonatomic, assign) NSUInteger maxInputLength;    // default is 0. Means no length limit.
@property (nonatomic, assign) BOOL isStrongUpate;     //是否强更   是强更 点击按钮不隐藏视图
/*
 创建班级
 */
- (instancetype) initWithCreateInputTitle:(NSString *)title
                                   detail:(NSString *)detail
                                    items:(NSArray*)items
                              placeholder:(NSString *)inputPlaceholder
                                  handler:(MMPopupHandler)inputHandler;

/*
  完成时间
 */
- (instancetype) initWithCompletionTimeTitle:(NSString *)title
                                   normalTime:(NSString *)time
                                    items:(NSArray*)items
                                  handler:(MMPopupCompletionHandler )dateHandler;

/*
 普通的输入框提醒弹框
 */

- (instancetype) initWithNormalInputTitle:(NSString *)title
                                   detail:(NSString *)detail
                                    items:(NSArray*)items
                              placeholder:(NSString *)inputPlaceholder
                                  handler:(MMPopupHandler)inputHandler
                             ;
/*
  电话号码
 */
- (instancetype) initWithInputPhoneTitle:(NSString *)title
                                 detail:(NSString *)detail
                                  items:(NSArray*)items
                            placeholder:(NSString *)inputPlaceholder
                                handler:(MMPopupHandler)inputHandler;
/*
 验证码提示框
 */
- (instancetype) initWithValidationInputTitle:(NSString*)title
                                       detail:(NSString*)detail
                                        items:(NSArray *)items
                                  placeholder:(NSString*)inputPlaceholder
                                      handler:(MMPopupHandler)inputHandler
                                 
                           textFeildRightItem:(MMPopupItem *)rightItem;

/*
 图片样式 的提示弹框
 */
- (instancetype) initWithOperationState:(TNOperationState )operationState
                               detail:(NSString*)detail
                                  items:(NSArray*)items;
/*
 普通的提示标题 文本提醒弹框
 */
- (instancetype) initWithTitle:(NSString*)title
                        detail:(NSString*)detail
                         items:(NSArray*)items;


/**
 标识说明
 */
- (instancetype) initWithTitle:(NSString*)title
              logoInstructions:(NSArray *)logos
                         items:(NSArray*)items;

/**
 修改性别
 */
- (instancetype) initWithTitle:(NSString*)title
                 normarlSex:(NSString *)sex
                         items:(NSArray*)items;

/**
 选择科目
 */
- (instancetype)initWithTitle:(NSString *)title  withSubjects:(NSString *)subjects  items:(NSArray *)items;

@end
/**
 *  Global Configuration of MMAlertView.
 */
@interface AlertViewConfig : NSObject

+ (AlertViewConfig*) globalConfig;

@property (nonatomic, assign) CGFloat width;                // Default is 275.
@property (nonatomic, assign) CGFloat buttonHeight;         // Default is 50.
@property (nonatomic, assign) CGFloat innerMargin;          // Default is 25.
@property (nonatomic, assign) CGFloat cornerRadius;         // Default is 5.

@property (nonatomic, assign) CGFloat titleFontSize;        // Default is 18.
@property (nonatomic, assign) CGFloat detailFontSize;       // Default is 14.
@property (nonatomic, assign) CGFloat buttonFontSize;       // Default is 17.

@property (nonatomic, strong) UIColor *titleBackgroundColor;// Default is #2E8AFF
@property (nonatomic, strong) UIColor *backgroundColor;     // Default is #FFFFFF.
@property (nonatomic, strong) UIColor *titleTextColor;          // Default is #333333.
@property (nonatomic, strong) UIColor *detailColor;         // Default is #333333.
@property (nonatomic, strong) UIColor *splitColor;          // Default is #CCCCCC.

@property (nonatomic, strong) UIColor *itemNormalColor;     // Default is #333333. effect with MMItemTypeNormal
@property (nonatomic, strong) UIColor *itemHighlightColor;  // Default is #E76153. effect with MMItemTypeHighlight
@property (nonatomic, strong) UIColor *itemPressedColor;    // Default is #EFEDE7.

@property (nonatomic, strong) NSString *defaultTextOK;      // Default is "好".
@property (nonatomic, strong) NSString *defaultTextCancel;  // Default is "取消".
@property (nonatomic, strong) NSString *defaultTextConfirm; // Default is "确定".
@property (nonatomic, assign) CGFloat itemWidth;//Default is
@property (nonatomic, strong) UIColor *itemNormalLayerColor;
@property (nonatomic, strong) UIColor *itemPressedLayerColor;
@property (nonatomic, strong) UIColor *itemPressedTitleColor;
@property (nonatomic, strong) UIColor *itemNormalTitleColor;
@property (nonatomic, assign) CGFloat itemCornerRadius;
@end


@interface DatePicker : UIView
- (void)today;
- (void)tomorrow;
- (void)thisWeek;
- (void)thisMonth;
- (NSString *)getSelectedDate;
@end
