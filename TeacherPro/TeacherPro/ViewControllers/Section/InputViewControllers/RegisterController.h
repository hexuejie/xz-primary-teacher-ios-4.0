//
//  RegisterController.h
//  AplusKidsMasterPro
//
//  Created by neon on 16/4/18.
//  Copyright © 2016年 neon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNetworkViewController.h"


@interface RegisterController : BaseNetworkViewController
@property (weak, nonatomic) IBOutlet UITextField *mobileInput;
@property (weak, nonatomic) IBOutlet UITextField *smscodeInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UIButton *smsButton;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIView *mobileBgView;
@property (weak, nonatomic) IBOutlet UIView *smsBgView;
@property (weak, nonatomic) IBOutlet UIView *pwdbgView;


@end
