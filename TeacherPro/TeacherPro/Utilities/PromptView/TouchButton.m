//
//  TouchButton.m
//  AplusEduPro
//
//  Created by neon on 15/7/28.
//  Copyright (c) 2015年 neon. All rights reserved.
//

#import "TouchButton.h"


@interface TouchButton (){
    TouchBlock touch_block;
}

@end


@implementation TouchButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(touchAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

//-(void)setTouchBlock:(TouchBlock)touchBlock{
//    touch_block=touchBlock;
//    [self addTarget:self action:@selector(touchAction) forControlEvents:UIControlEventTouchUpInside];
//    
//}
-(void)touchAction{
   
//    if(touch_block){
//        touch_block();
//    }
    if(self.touchBlock){
        self.touchBlock();
    }
    if (self.newClassBlock) {
        NSString * inputText = @"";
        if (self.inputText) {
            inputText = self.inputText;
        }
//        if (inputText.length > 0) {
//            self.newClassBlock(inputText);
//        }else{
//            NSLog(@"请输入班级名字");
//        }
        self.newClassBlock(inputText);
    }
    return;
}
 


@end
