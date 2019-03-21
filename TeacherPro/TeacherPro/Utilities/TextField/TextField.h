//
//  TextField.h
//  AplusKidsMasterPro
//
//  Created by DCQ on 2017/3/20.
//  Copyright © 2017年 neon. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TextFieldBlock)(NSString * inputText);
@interface TextField : UITextField
@property (nonatomic, copy) TextFieldBlock textFieldBlock;

@end
