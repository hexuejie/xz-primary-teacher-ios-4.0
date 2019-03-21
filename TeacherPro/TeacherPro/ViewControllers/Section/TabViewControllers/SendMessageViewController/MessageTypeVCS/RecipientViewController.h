//
//  RecipientViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"

typedef void(^RecipientViewControllerBlock)(NSDictionary * recipientInfo,NSDictionary * indexDic);
@interface RecipientViewController : BaseTableViewController

- (instancetype)initWithSelectedIndexDic:(NSDictionary *)indexDic;
@property(nonatomic, copy) RecipientViewControllerBlock recipientBlock;
@end
