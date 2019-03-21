//
//  TextField.m
//  AplusKidsMasterPro
//
//  Created by DCQ on 2017/3/20.
//  Copyright © 2017年 neon. All rights reserved.
//

#import "TextField.h"

@implementation TextField
- (instancetype)init{

    if (self == [super init ]) {
    
        [self addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

    if (self.textFieldBlock) {
        self.textFieldBlock(textField.text);
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
