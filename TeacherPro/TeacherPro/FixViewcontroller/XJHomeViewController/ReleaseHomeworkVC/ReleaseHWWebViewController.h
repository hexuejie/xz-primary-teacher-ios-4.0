//
//  WebViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/9.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseNetworkViewController.h"

typedef void(^WebViewControllerChooseBookBlock)( NSString * content);
@interface ReleaseHWWebViewController : BaseNetworkViewController
@property(nonatomic, copy)WebViewControllerChooseBookBlock chooseBookBlock;
@end
