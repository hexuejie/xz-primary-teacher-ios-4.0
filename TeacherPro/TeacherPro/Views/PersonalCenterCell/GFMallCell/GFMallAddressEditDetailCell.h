//
//  GFMallAddressEditDetailCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/12/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GFMallAddressEditDetailCellBlock)(NSString * inputText);
@interface GFMallAddressEditDetailCell : UITableViewCell
@property(nonatomic, strong)GFMallAddressEditDetailCellBlock inputBlock;
- (void)setupContent:(NSString *)contentStr;
@end
