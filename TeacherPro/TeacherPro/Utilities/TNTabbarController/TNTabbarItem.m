//
//  TNTabbarItem.m
//  AplusEduPro
//
//  Created by neon on 15/7/15.
//  Copyright (c) 2015年 neon. All rights reserved.
//

#import "TNTabbarItem.h"
#import "CommonConfig.h"
#import "ProUtils.h"
#define tab_badge_size 6.0f
#define tab_badge_original 5.0f
@interface TNTabbarItem ()

@end
@implementation TNTabbarItem

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    self.titleSelectedAttrs=@{NSFontAttributeName:tn_tabbar_font,NSForegroundColorAttributeName:tn_tabbar_select_color};
    self.titleUnselectedAttrs=@{NSFontAttributeName:tn_tabbar_font,
                                NSForegroundColorAttributeName:tn_tabbar_unselect_color};
}

- (void)drawRect:(CGRect)rect {
    CGSize frameSize = rect.size;
    CGSize imageSize = CGSizeZero;
    CGSize titleSize = CGSizeZero;
    NSDictionary *titleAttr = nil;
    UIImage *itemImage      = nil;
    UIImage *itemBackgroundImage =  nil;
    CGFloat imageOriginalY;
    CGFloat titleOriginalY;
    CGFloat imageOriginalX;
    CGFloat titleOriginalX;
    
    
    if([self isSelected]){
        itemImage = self.selectedItemImage;
        titleAttr = self.titleSelectedAttrs;
        itemBackgroundImage = self.selectedItemBackgroundImage;
    }else{
        itemImage = self.unselectedItemImage;
        titleAttr = self.titleUnselectedAttrs;
        itemBackgroundImage = self.unselectedItemBackgroundImage;
        
    }
//    imageSize=CGSizeMake(22,22);
    imageSize = itemImage.size;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [itemBackgroundImage drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    CGRect itemImageFrame = CGRectZero;
    CGRect titleFrame = CGRectZero;
    
    if(![ProUtils isNilOrEmpty:self.title]){
        titleSize=[self.title boundingRectWithSize:CGSizeMake(frameSize.width/2, 5) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttr context:Nil].size;
        imageOriginalY = 6;
        imageOriginalX=round(frameSize.width/2-imageSize.width/2);
        
        itemImageFrame = CGRectMake(imageOriginalX, imageOriginalY, imageSize.width, imageSize.height);
        [itemImage drawInRect:itemImageFrame];
        
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        titleOriginalY=imageSize.height+imageOriginalY +1;
        titleOriginalX=round(frameSize.width/2-titleSize.width/2);
        titleFrame = CGRectMake(titleOriginalX, titleOriginalY, titleSize.width, titleSize.height);
        [self.title drawInRect:titleFrame withAttributes:titleAttr];
        
    }else{
        imageOriginalY=frameSize.height/2-imageSize.height/2;
        imageOriginalX=round(frameSize.width/2-imageSize.width/2);
        
        itemImageFrame = CGRectMake(imageOriginalX, imageOriginalY, imageSize.width, imageSize.height);
        [itemImage drawInRect:itemImageFrame];
    }
    
    CGRect badgeFrame=CGRectZero;
    
    if(![ProUtils isNilOrEmpty:self.badgeValue]){
        //        badgeFrame=CGRectMake(frameSize.width-tab_badge_size*2-5, tab_badge_original, tab_badge_size, tab_badge_size);
        badgeFrame = CGRectMake(CGRectGetMaxX(itemImageFrame) + 2,tab_badge_original, tab_badge_size, tab_badge_size);
        //        CGContextSetFillColorWithColor(context, tn_tabbar_select_color.CGColor);
        CGContextSetFillColorWithColor(context,UIColorFromRGB(0xF40008).CGColor);
        CGContextFillEllipseInRect(context, badgeFrame);
        CGContextRestoreGState(context);
    }
    
}

-(void)setSelectedItemImage:(UIImage *)selectedImage withUnselectedItemImage:(UIImage *)unselectedImage{
    if(selectedImage && selectedImage!=self.selectedItemImage){
        [self setSelectedItemImage:selectedImage];
    }
    if(unselectedImage && unselectedImage!=self.unselectedItemImage){
        [self setUnselectedItemImage:unselectedImage];
    }
//    [self setSelectedItemBackgroundImage:[ProUtils createImageWithColor:UIColorFromRGB(0xE5EFFF) withFrame:CGRectMake(0, 0, 1, 1)]];
//    [self setUnselectedItemBackgroundImage:[ProUtils createImageWithColor:[UIColor clearColor] withFrame:CGRectMake(0, 0, 1, 1)]];
}


@end


