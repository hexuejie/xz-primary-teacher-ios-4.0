//
//  ProUtils.m
//  AplusEduPro
//
//  Created by neon on 15/7/15.
//  Copyright (c) 2015年 neon. All rights reserved.
//

#import "ProUtils.h"
#define MAX_STARWORDS_LENGTH  11

@implementation ProUtils

+(BOOL)isNilOrEmpty:(NSString *)str{

    if (str == nil || [str isEqual:[NSNull null]]) {
        return YES;
    }
    else {
        if (str.length > 0) {
            return NO;
        }
        else {
            return YES;
        }
    }
}





 +(BOOL)isChinese:(NSString *)str{
    
    for(int i=0;i<str.length;i++){
        unichar ch=[str characterAtIndex:i];
        if (0x4e00 < ch  && ch < 0x9fff) {
            return YES;
        }
    }
    return NO;
    
}

+(BOOL)IsPwd:(NSString *)str{

    NSString *regex = @"^[a-zA-Z0-9]\\w{5,14}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:str];
    return isValid;
}

+(NSString *)checkPwd:(NSString *)str{
    if([ProUtils isNilOrEmpty:str]){
        return @"密码不能为空(长度为6-16位的字母、数字的组合)";
    }
    
    if(str.length<6||str.length>16){
        return @"密码长度不符合规范(长度为6-16位的字母、数字的组合)";
    }
    
    NSString *regex = @"^[a-zA-Z0-9]{5,15}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:str];
    if(!isValid){
        return @"密码不能包含特殊字符(长度为6-15位的字母、数字的组合)";
    }
    return nil;
}

+(NSString *)checkAccount:(NSString *)str{
    if([ProUtils isNilOrEmpty:str]){
        return @"手机号码或学号不得为空";
    }
    
    if(str.length<9||str.length>11){
        return @"手机号码长度或学号长度不符合规范";
    }
    
    NSString *regex = @"^\\d{11}|\\d{9}|\\d{10}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:str];
    if(!isValid){
        return @"手机号码或学号不能包含特殊字符";
    }
    return nil;
}
+ (NSString *)replacingCenterPhone:(NSString *)phone withReplacingSymbol:(NSString *)replacingSymbol{
    NSString * tempReplacingSymbol = @"";
    NSInteger length = 4;
    for (int i = 0; i< 4; i++) {
        tempReplacingSymbol =  [tempReplacingSymbol stringByAppendingString: replacingSymbol];
        
    }
  return [ProUtils replacingPhone:phone withCharactersRange:NSMakeRange(3, length) withString: tempReplacingSymbol];
 
}
+ (NSString *)replacingPhone:(NSString *)phone withCharactersRange:(NSRange )range withString:(NSString *)replacing{
    
   return   [ phone  stringByReplacingCharactersInRange:range  withString:replacing];
}

+(NSString *)checkMobilePhone:(NSString *)str{
    if([ProUtils isNilOrEmpty:str]){
        return @"手机号不得为空";
    }
    
 
    if(str.length != 11){
        return @"手机号码不符合规范";
    }

    NSString *regex = @"^\\d{11}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:str];
    if(!isValid){
        return @"手机号码不能包含特殊字符";
    }
    
    return nil;
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

+(NSString *)decodeURL:(NSString *)string{
    NSMutableString *outputStr = [NSMutableString stringWithString:string];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    

}
+ (void) shake:(UIView *)view {
    CAKeyframeAnimation *keyAn = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [keyAn setDuration:0.5f];
    NSArray *array = [[NSArray alloc] initWithObjects:
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x-5, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x+5, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x-5, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x+5, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x-5, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x+5, view.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(view.center.x, view.center.y)],
                      nil];
    [keyAn setValues:array];
    
    NSArray *times = [[NSArray alloc] initWithObjects:
                      [NSNumber numberWithFloat:0.1f],
                      [NSNumber numberWithFloat:0.2f],
                      [NSNumber numberWithFloat:0.3f],
                      [NSNumber numberWithFloat:0.4f],
                      [NSNumber numberWithFloat:0.5f],
                      [NSNumber numberWithFloat:0.6f],
                      [NSNumber numberWithFloat:0.7f],
                      [NSNumber numberWithFloat:0.8f],
                      [NSNumber numberWithFloat:0.9f],
                      [NSNumber numberWithFloat:1.0f],
                      nil];
    [keyAn setKeyTimes:times];
    
    [view.layer addAnimation:keyAn forKey:@"TextAnim"];
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



//+ (float) heightForString:(NSString *)value andWidth:(float)width andSpase:(float)Spase{
//    //获取当前文本的属性
//    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:value];
//    
//    NSRange range = NSMakeRange(0, attrStr.length);
//    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
//    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
//                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
//                                        attributes:dic        // 文字的属性
//                                           context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
//    return sizeToFit.height;
//}


-(void)setButtonContentCenter:(UIButton *) btn

{
    
    CGSize imgViewSize,titleSize,btnSize;
    
    UIEdgeInsets imageViewEdge,titleEdge;
    
    CGFloat heightSpace = 10.0f;
   
    //设置按钮内边距
    
    imgViewSize = btn.imageView.bounds.size;
    
    titleSize = btn.titleLabel.bounds.size;
    
    btnSize = btn.bounds.size;
    
    
    imageViewEdge = UIEdgeInsetsMake(heightSpace,0.0, btnSize.height -imgViewSize.height - heightSpace, - titleSize.width);
    
    [btn setImageEdgeInsets:imageViewEdge];
    
    titleEdge = UIEdgeInsetsMake(imgViewSize.height +heightSpace, - imgViewSize.width, 0.0, 0.0);
    
    [btn setTitleEdgeInsets:titleEdge];
     
    
}

+ (void)setupButtonContent:(UIButton  *)button  withType:(ButtonContentType) type{

    [ProUtils setupButtonContent:button withType:type withSpacing:-9999];
}
+ (void)setupButtonContent:(UIButton  *)button  withType:(ButtonContentType) type withSpacing:(CGFloat)spac  {
    button.titleLabel.backgroundColor = button.backgroundColor;
    button.imageView.backgroundColor = button.backgroundColor;
    
    if (type == ButtonContentType_imageRight) {
     
        //在使用一次titleLabel和imageView后才能正确获取titleSize
        CGSize titleSize = button.titleLabel.bounds.size;
        CGSize imageSize = button.imageView.bounds.size;
       CGFloat interval = 4.0;
        if (spac != -9999) {
            interval = spac;
        }
   
        
        button.imageEdgeInsets = UIEdgeInsetsMake(0,titleSize.width + interval, 0, -(titleSize.width + interval));
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageSize.width + interval), 0, imageSize.width + interval);
    }else if (type == ButtonContentType_imageCenter){
    
        // the space between the image and text
        CGFloat spacing = 4.0;
        if (spac != -9999) {
            spacing = spac;
        }
        // lower the text and push it left so it appears centered
        //  below the image
        CGSize imageSize = button.imageView.image.size;
        button.titleEdgeInsets = UIEdgeInsetsMake(
                                                  0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
        
        // raise the image and push it right so it appears centered
        //  above the text
        CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
        button.imageEdgeInsets = UIEdgeInsetsMake(
                                                  - (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
        
        // increase the content height to avoid clipping
        CGFloat edgeOffset = fabsf(titleSize.height - imageSize.height) / 2.0;
        button.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0.0, edgeOffset, 0.0);

    }
  
}

+(void)phoneTextFieldEditChanged:(UITextField *)textField{

    NSString *toBeString = textField.text;
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if(toBeString.length > MAX_STARWORDS_LENGTH)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_STARWORDS_LENGTH)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
            
        }
    }
   
}

+ (void)confineTextFieldEditChanged:(UITextField *)textField withlength:(NSInteger )length{
    
    NSString *toBeString = textField.text;
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if(toBeString.length > length)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:length];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:length];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, length)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
            
        }
    }
    
}

+(UIImage *)getResizableImage:(UIImage *)image withEdgeInset:(UIEdgeInsets ) insets{

    
    UIImage * tempImage =  image  ;
    // 指定为拉伸模式，伸缩后重新赋值
    tempImage = [tempImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    return tempImage;
}


//yyyy-MM-dd HH:mm:ss
+  (NSString *) compareCurrentTime:(NSString *)str

{
    
    //把字符串转为NSdate
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *timeDate = [dateFormatter dateFromString:str];
    
    NSDate *currentDate = [NSDate date];
    
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:timeDate];
    
    long temp = 0;
    
    NSString *result;
    
    if (timeInterval/60 < 1) {
        
        result = [NSString stringWithFormat:@"刚刚"];
        
    }
    
    else if((temp = timeInterval/60) <60){
        
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
        
    }
    
    else if((temp = temp/60) <24){
        
        result = [NSString stringWithFormat:@"%ld小时前",temp];
        
    }
    
    else if((temp = temp/24) <30){
        
        result = [NSString stringWithFormat:@"%ld天前",temp];
        
    }
    
    else if((temp = temp/30) <12){
        
        result = [NSString stringWithFormat:@"%ld月前",temp];
        
    }
    
    else{
        
        temp = temp/12;
        
        result = [NSString stringWithFormat:@"%ld年前",temp];
        
    }
    
    return  result;
    
}

+ (NSString *)updateTime:(NSString *)timeStr {
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime =  [timeStr floatValue]/1000;
    // 时间差
    NSTimeInterval timeInterval = currentTime - createTime;
    
    
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%d分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%d小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%d天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%d月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%d年前",temp];
    }
    
    return  result;
 
    // 秒转小时
//    NSInteger hours = time/3600;
    
    
//    if (hours<24) {
//        return [NSString stringWithFormat:@"%ld小时前",hours];
//    }
//    //秒转天数
//    NSInteger days = time/3600/24;
//    if (days < 30) {
//        return [NSString stringWithFormat:@"%ld天前",days];
//    }
//    //秒转月
//    NSInteger months = time/3600/24/30;
//    if (months < 12) {
//        return [NSString stringWithFormat:@"%ld月前",months];
//    }
//    //秒转年
//    NSInteger years = time/3600/24/30/12;
//    return [NSString stringWithFormat:@"%ld年前",years];
}


+ (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    
    NSComparisonResult result = [dateA compare:dateB];
    
    if (result == NSOrderedDescending) {
        //NSLog(@"oneDay比 anotherDay时间晚");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"oneDay比 anotherDay时间早");
        return -1;
    }
    //NSLog(@"两者时间是同一个时间");
    return 0;
    
}
 


+ (NSAttributedString *)setAttributedText:(NSString *)text withColor:(UIColor *)color withRange:(NSRange )range withFont:(UIFont *)font{
    
    NSMutableAttributedString *Attributed  = [[NSMutableAttributedString alloc]initWithString:text];
    
    [Attributed addAttribute:NSFontAttributeName
     
                       value: font
     
                       range:range];
    [Attributed addAttribute:NSForegroundColorAttributeName
     
                       value:color
     
                       range:range];
    
    return Attributed;
}

+ (NSAttributedString *)confightAttributedText:(NSString *)text withColors:(NSArray  *)colors withRanges:(NSArray* )ranges withFonts:(NSArray *)fonts{
    
    NSMutableAttributedString *Attributed  = [[NSMutableAttributedString alloc]initWithString:text];
    if ([colors count] == [ranges count] && [ranges count] == [fonts count]) {
        for (int i = 0; i< [colors count]; i++) {
            UIColor * color = colors[i];
            UIFont  * font = fonts[i];
            NSRange range = NSRangeFromString(ranges[i]);
            [Attributed addAttribute:NSFontAttributeName
             
                               value: font
             
                               range:range];
            [Attributed addAttribute:NSForegroundColorAttributeName
             
                               value:color
             
                               range:range];
        }
    }
   
    
    return Attributed;
}


+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

 //字典转json格式字符串：
+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
//    NSJSONWritingPrettyPrinted  是有换位符的。
//    
//    如果NSJSONWritingPrettyPrinted 是0 的话 返回的数据是没有 换位符的
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

+(NSDictionary *)getZXLXUnitIconDic{
    
    NSDictionary * unitIconDic =
                        @{@"dcbs":@"homework_icon_dcbs",
                          @"dcgc":@"homework_icon_dcgc",
                          @"dcgd":@"homework_icon_dcgd",
                          @"dcpaixu":@"homework_icon_dcpaixu",
                          @"dcpinxie":@"homework_icon_dcpingxie",
                          @"ktsc":@"homework_icon_ktsc",
                          @"tyxc":@"homework_icon_tyxc",
                          @"gdxl":@"homework_icon_gdxl",
                          @"qwgd":@"homework_icon_tyxc",
                          @"qwld":@"homework_icon_qwld",
                          @"zztl":@"homework_icon_jztl",
                          @"hbpy":@"homework_icon_hbpy",
                          @"yyyd":@"homework_icon_yyyd",
                          @"hbxt":@"homework_icon_hbxt",
                          @"chxx":@"homework_icon_chxx",
                          
                          @"zxlx":@"homework_zxlx_icon",
                          @"tkwly":@"homework_tkwly_icon",
                          @"ldkw":@"homework_ldkw_icon",
                          @"dctx":@"homework_dctx_icon",
                          
                          };
    
    return unitIconDic;
    
}

+ (NSDictionary *)getHomworkDetailPracticeTypes{
    NSDictionary * practiceTypes  = @{
                                 @"zxlx":@"游戏练习",
                                 @"ldkw":@"朗读课文",
                                 @"tkwly":@"听课文录音",
                                 @"dctx":@"单词听写",
                                 @"ywdd":@"语文点读",
                                 @"khlx":@"课后练习"
                                 };
    return  practiceTypes;
    
}

+ (NSDictionary *)getHomworkDetailCartoonTypes{
    NSDictionary * cartoonTypes = @{
                                    @"hbpy":@"绘本配音",
                                    @"yyyd":@"原音阅读",
                                    @"hbxt":@"绘本习题",
                                    @"chxx":@"词汇学习"
                                    };
    return cartoonTypes;
}
+ (NSDictionary *)getHomworkDetailUnitIconDic{
    
    NSDictionary * unitIconDic = @{
                                    
                                    @"hbpy":@"homework_icon_hbpy_new",
                                    @"yyyd":@"homework_icon_yyyd_new",
                                    @"hbxt":@"homework_icon_hbxt_new",
                                    @"chxx":@"homework_icon_chxx_new",
                                    
                                    @"zxlx":@"homework_zxlx_icon_new",
                                    @"tkwly":@"homework_tkwly_icon_new",
                                    @"ldkw":@"homework_ldkw_icon_new",
                                    @"dctx":@"homework_dctx_icon_new",
                                    @"ywdd":@"homework_ywdd_icon_new",
                                    @"khlx":@"homework_khlx_icon_new"
                                    };
    return  unitIconDic;
}


/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
+(UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    
    //将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [image CGImage];
    
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    
    //将CGImageRef转换成UIImage
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    //返回剪裁后的图片
    return newImage;
}

//指定宽度按比例缩放
+ (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) ==NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) *0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) *0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}
/**
 *  富文本转html字符串
 */
+ (NSString *)attriToStrWithAttri:(NSAttributedString *)attri{
    
    NSDictionary *tempDic = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                              NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]};
    NSData *htmlData = [attri dataFromRange:NSMakeRange(0, attri.length)
                         documentAttributes:tempDic
                                      error:nil];
      NSString *htmlString  = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    return htmlString;
}

/**
 *  字符串转富文本
 */
+ (NSAttributedString *)strToAttriWithStr:(NSString *)htmlStr{
    
 
    NSData *htmlData = [htmlStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *importParams = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                   NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]
                                   };
    NSError *error = nil;
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithData:htmlData options:importParams documentAttributes:NULL error:&error];
    return attributeString;
    
  
}

/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
//    [label sizeToFit];
    
}

+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
//    [label sizeToFit];
    
}

+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}
//根据高度度求宽度  text 计算的内容  Height 计算的高度 font字体大小
+ (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(UIFont *)font{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:font}
                                     context:nil];
    return rect.size.width;
}

//根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
+ (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (UIFont *)font
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    
    return rect.size.height;
}
@end
