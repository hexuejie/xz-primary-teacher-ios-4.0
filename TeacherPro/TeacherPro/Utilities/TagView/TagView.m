//
//  TagView.m
//  CustomTag
//
//  Created by za4tech on 2017/12/15.
//  Copyright © 2017年 Junior. All rights reserved.
//

#import "TagView.h"
#define kScreenWidth      [UIScreen mainScreen].bounds.size.width
#define kItemMarginX       15
#define kItemMarginY       10
#define kItemHeight        28
@implementation TagView

+ (CGFloat) getViewHeightData:(NSArray *)array{
    CGFloat viewHeight = 0;
    
    CGFloat itemMarginX = kItemMarginX;
    CGFloat itemMarginY = kItemMarginY;
    CGFloat itemHeight  = kItemHeight;
    UIButton * markBtn;
    for (int i = 0; i < array.count; i++) {
        CGFloat width =  [TagView calculateString:array[i] Width:12] +20;
        UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (!markBtn) {
            tagBtn.frame = CGRectMake(itemMarginX, itemMarginY, width, itemHeight);
        }else{
            if (markBtn.frame.origin.x + markBtn.frame.size.width + itemMarginX + width + itemMarginX > kScreenWidth) {
                tagBtn.frame = CGRectMake(itemMarginX, markBtn.frame.origin.y + markBtn.frame.size.height + itemMarginY, width, itemHeight);
            }else{
                tagBtn.frame = CGRectMake(markBtn.frame.origin.x + markBtn.frame.size.width + itemMarginX, markBtn.frame.origin.y, width, itemHeight);
            }
        }
        
        markBtn =  tagBtn;
    }
 
     viewHeight = markBtn.frame.origin.y + markBtn.frame.size.height + itemMarginY;
//    NSLog(@"%f==viewHeight",viewHeight);
    return viewHeight;
}
-(void)setArr:(NSArray *)arr{
    _arr = arr;
    CGFloat marginX = 15;
    CGFloat marginY = 10;
    CGFloat height = 28;
    UIButton * markBtn;
    for (int i = 0; i < _arr.count; i++) {
        CGFloat width =  [TagView calculateString:_arr[i] Width:14] +24;
        UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (!markBtn) {
            tagBtn.frame = CGRectMake(marginX, marginY, width, height);
        }else{
            if (markBtn.frame.origin.x + markBtn.frame.size.width + marginX + width + marginX > kScreenWidth) {
                tagBtn.frame = CGRectMake(marginX, markBtn.frame.origin.y + markBtn.frame.size.height + marginY, width, height);
            }else{
                tagBtn.frame = CGRectMake(markBtn.frame.origin.x + markBtn.frame.size.width + marginX, markBtn.frame.origin.y, width, height);
            }
        }
        [tagBtn setTitle:_arr[i] forState:UIControlStateNormal];
        tagBtn.titleLabel.font = self.btnFont?self.btnFont: [UIFont systemFontOfSize:14];
        UIColor  * tagBtnTitleColor = self.textColor?self.textColor:[UIColor blackColor];
        UIColor  * edgeLineColor = self.edgeLineColor?self.edgeLineColor:[UIColor blackColor];
        CGFloat radius = self.radius ?self.radius: 14;
        CGFloat borderWidth = self.borderWidth?self.borderWidth:0.5;
        tagBtn.backgroundColor = self.itemBgColor;
        [tagBtn setTitleColor:tagBtnTitleColor forState:UIControlStateNormal];
        [self makeCornerRadius:radius borderColor:edgeLineColor layer:tagBtn.layer borderWidth:borderWidth];
        markBtn = tagBtn;
        
        [tagBtn addTarget:self action:@selector(clickTo:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:markBtn];
    }
    CGRect rect = self.frame;
    rect.size.height = markBtn.frame.origin.y + markBtn.frame.size.height + marginY;
    self.frame = rect;
}


-(void)clickTo:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(handleSelectTag:)]) {
        [self.delegate handleSelectTag:sender.titleLabel.text];
    }
}



-(void)makeCornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor layer:(CALayer *)layer borderWidth:(CGFloat)borderWidth
{
    layer.cornerRadius = radius;
    layer.masksToBounds = YES;
    layer.borderColor = borderColor.CGColor;
    layer.borderWidth = borderWidth;
}

+ (CGFloat)calculateString:(NSString *)str Width:(NSInteger)font
{
    CGSize size = [str boundingRectWithSize:CGSizeMake(kScreenWidth, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size;
    return size.width;
}

@end
