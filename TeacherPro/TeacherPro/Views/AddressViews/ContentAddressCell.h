//
//  ContentAddressCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/5/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ContentAddressCellLoactionBlock)(void);
@interface ContentAddressCell : UITableViewCell
@property(nonatomic, copy) ContentAddressCellLoactionBlock  block;
- (void)setupTitle:(NSString *)locationTitle;

@end
