//
//  UILabel+adaptive.m
//  lexiwed2
//
//  Created by pxj on 16/7/19.
//  Copyright © 2016年 乐喜网. All rights reserved.
//
//#import "public.h"
#import "UILabel+adaptive.h"
//#define SizeScale
@implementation UILabel (adaptive)

+ (void)load{
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(imp, myImp);
    
}

- (id)myInitWithCoder:(NSCoder*)aDecode{
    [self myInitWithCoder:aDecode];
    if (self) {
        //部分不像改变字体的 把tag值设置成333跳过
        if(self.tag > 500&&self.tag < 600){
            CGFloat fontSize = self.font.pointSize;
            self.font = [UIFont systemFontOfSize:fontSize*kScreenWidth/375];
            
            CGRect rect = self.frame;
            self.frame = CGRectMake(rect.origin.x*kScreenWidth/375, rect.origin.y*kScreenWidth/375, rect.size.width*kScreenWidth/375, rect.size.height*kScreenWidth/375);
        }
    }
    return self;
}



@end
