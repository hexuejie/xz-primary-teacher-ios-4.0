//
//  HWGuidePageManager.m
//  TransparentGuidePage
//
//  Created by wangqibin on 2018/4/20.
//  Copyright © 2018年 sensmind. All rights reserved.
//

#import "HWGuidePageManager.h"
#import "OBShapedButton.h"

typedef NS_ENUM(NSInteger,GuideTransparentButtonType) {
    GuideTransparentButtonType_rectangular = 0,//矩形
    GuideTransparentButtonType_round ,//圆
    GuideTransparentButtonType_roundedRectangle,   //圆角矩形
};
NSString * const HWGuidePageHomeKey = @"HWGuidePageHomeKey";
NSString * const HWGuidePageMajorKey = @"HWGuidePageMajorKey";
@interface HWGuidePageManager ()

@property (nonatomic, copy) FinishBlock finish;
@property (nonatomic, copy) NSString *guidePageKey;
@property (nonatomic, assign) HWGuidePageType guidePageType;

@end

@implementation HWGuidePageManager

+ (instancetype)shareManager
{
    static HWGuidePageManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (void)showGuidePageWithType:(HWGuidePageType)type withGuideFrame:(CGRect)guideAreaFrame
{
    [self creatControlWithType:type withGuideFrame:guideAreaFrame completion:NULL ];
}

- (void)showGuidePageWithType:(HWGuidePageType)type withGuideFrame:(CGRect)guideAreaFrame completion:(FinishBlock)completion
{
    [self creatControlWithType:type withGuideFrame:guideAreaFrame completion:completion ];
}

- (void)creatControlWithType:(HWGuidePageType)type withGuideFrame:(CGRect)guideAreaFrame completion:(FinishBlock)completion
{
    _finish = completion;

    // 遮盖视图
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
//    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    
    // 信息提示视图
    UIImageView *imgView = [[UIImageView alloc] init];
    [bgView addSubview:imgView];
    
    UILabel *desInfo= [[UILabel alloc] init];
    [bgView addSubview:desInfo];
    
    //透明点击按钮   按钮点击事件区域取决于 图片大小
    OBShapedButton * transparentBtn = [OBShapedButton buttonWithType:UIButtonTypeCustom];
    [bgView addSubview:transparentBtn];
    CGSize btnImageSize = CGSizeZero;
    GuideTransparentButtonType  buttonType  = GuideTransparentButtonType_rectangular;
    CGFloat radius = 0;
    NSString * desText = @"";
    // 第一个路径
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];
    switch (type) {
        case HWGuidePageType_Share:
        {
            // 下一个路径，圆形
            btnImageSize = CGSizeMake(guideAreaFrame.size.width, guideAreaFrame.size.height);
            CGPoint arcCenter = CGPointMake(CGRectGetMidX(guideAreaFrame), CGRectGetMidY(guideAreaFrame));
            CGRect imgVFrame = CGRectMake(220, 40, 100, 100);
            radius = guideAreaFrame.size.width/2;
            [path appendPath:[UIBezierPath bezierPathWithArcCenter:arcCenter radius:radius startAngle:0 endAngle:2 * M_PI clockwise:NO]];
            imgView.frame = imgVFrame;
//            imgView.image = [UIImage imageNamed:@"arrow_bing"];
            _guidePageKey = HWGuidePageHomeKey;
            [transparentBtn setFrame:CGRectMake(0, 0, btnImageSize.width, btnImageSize.height)];
            transparentBtn.center = arcCenter;
            buttonType  = GuideTransparentButtonType_round;
            
        }
            break;
            
        case HWGuidePageType_Review:
        {
            btnImageSize = CGSizeMake(guideAreaFrame.size.width, guideAreaFrame.size.height);
            CGRect roundedRect = guideAreaFrame;
            CGRect imgVFrame = CGRectMake(100, 320, 120, 120);
            radius = 5;
            // 下一个路径，矩形
            [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:roundedRect cornerRadius:radius] bezierPathByReversingPath]];
            imgView.frame = imgVFrame;
//            imgView.image = [UIImage imageNamed:@"arrow_bing"];
            _guidePageKey = HWGuidePageMajorKey;
            buttonType  = GuideTransparentButtonType_roundedRectangle;
            transparentBtn.frame = guideAreaFrame;
        }
            break;
        case HWGuidePageType_Class:
        {
            
            // 下一个路径，圆形
            btnImageSize = CGSizeMake(guideAreaFrame.size.width, guideAreaFrame.size.height);
//            CGPoint arcCenter = CGPointMake(CGRectGetMidX(guideAreaFrame), CGRectGetMidY(guideAreaFrame));
            CGRect imgVFrame = CGRectMake(220, 40, 100, 100);
            CGRect desInfoFrame = CGRectMake(0, 0, 80, 80);
            desText = @"";
            desInfo.frame = desInfoFrame;
            desInfo.text = desText;
//            radius = guideAreaFrame.size.width/2;
//            [path appendPath:[UIBezierPath bezierPathWithArcCenter:arcCenter radius:radius startAngle:0 endAngle:2 * M_PI clockwise:NO]];
            CGRect roundedRect = guideAreaFrame;
            radius = 0;
            // 下一个路径，矩形
            [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:roundedRect cornerRadius:radius] bezierPathByReversingPath]];
            imgView.frame = imgVFrame;
//            imgView.image = [UIImage imageNamed:@"arrow_bing"];
            _guidePageKey = HWGuidePageHomeKey;
            [transparentBtn setFrame:CGRectMake(0, 0, btnImageSize.width, btnImageSize.height)];
//            transparentBtn.center = arcCenter;
//            buttonType  = GuideTransparentButtonType_round;
            buttonType  = GuideTransparentButtonType_roundedRectangle;
            transparentBtn.frame = guideAreaFrame;
            }
            break;
        default:
            break;
    }
    
    // 绘制透明区域
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    [bgView.layer setMask:shapeLayer];
    
    //用颜色 绘制图片
    UIColor * imageColor = [UIColor colorWithRed:59 green:59 blue:59 alpha:0.1];
//    imageColor = [UIColor redColor];
    UIImage * image = [self createImageWithColor:imageColor withFrame:CGRectMake(0, 0, btnImageSize.width, btnImageSize.height) withType:buttonType withFilletRadius:radius];
    [transparentBtn setImage:image forState:UIControlStateNormal];
    //添加事件
    [transparentBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
   
    
}

- (UIImage*)createImageWithColor:(UIColor*) color withFrame:(CGRect)rect withType:(GuideTransparentButtonType) type withFilletRadius:(CGFloat )filletRadius
{
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    if (type == GuideTransparentButtonType_rectangular) {
        CGContextFillRect(context, rect);
    }else if(type == GuideTransparentButtonType_round){
        CGFloat bigRadius = rect.size.width * 0.5;
        CGFloat centerX = bigRadius;
        CGFloat centerY = bigRadius;
        CGContextAddArc(context, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
        CGContextFillPath(context);
    }else if (type == GuideTransparentButtonType_roundedRectangle){
        
        /*画圆角矩形*/
        CGFloat minx = CGRectGetMinX(rect);
        CGFloat midx = CGRectGetMidX(rect);
        CGFloat maxx = CGRectGetMaxX(rect);
        
        CGFloat miny = CGRectGetMinY(rect);
        CGFloat midy = CGRectGetMidY(rect);
        CGFloat maxy = CGRectGetMaxY(rect);
        
//        CGFloat filletRadius = CGRectGetHeight(rect)/2;
        
        CGContextMoveToPoint(context, minx, midy);// 开始坐标右边开始
        
        CGContextAddArcToPoint(context, minx, miny, midx, miny, filletRadius);// 右下角度
        CGContextAddArcToPoint(context, maxx, miny, maxx, midy, filletRadius);// 左下角度
        CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, filletRadius);// 左上角
        CGContextAddArcToPoint(context, minx, maxy, minx, midy, filletRadius);// 右上角
        
        //CGContextFillPath(context);
        //CGContextDrawPath(context, kCGPathFillStroke);
        CGContextClosePath(context);
        CGContextSaveGState(context);
        CGContextFillPath(context);
    }
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
- (void)closeAction:(UIButton *)sender{
    
    UIView *bgView = sender.superview;
    [bgView removeFromSuperview];
 
    bgView = nil;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:_guidePageKey];
    
    if (_finish) _finish();
    NSLog(@"psss----");
}
- (void)tap:(UITapGestureRecognizer *)recognizer
{
    UIView *bgView = recognizer.view;
    [bgView removeFromSuperview];
    [bgView removeGestureRecognizer:recognizer];
    [[bgView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    bgView = nil;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:_guidePageKey];
    
    if (_finish) _finish();
}

@end
