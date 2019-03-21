//
//  GFMallOrderAddAddressCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/12/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GFMallOrderAddAddressBlock)();
@interface GFMallOrderAddAddressCell : UITableViewCell
@property(nonatomic, copy) GFMallOrderAddAddressBlock  addBlock;
@end
