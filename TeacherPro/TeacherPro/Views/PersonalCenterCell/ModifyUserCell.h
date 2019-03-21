//
//  ModifyUserCell.h
//  AplusKidsMasterPro
//
//  Created by neon on 16/5/6.
//  Copyright © 2016年 neon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ModifyUserCellBlock)(NSIndexPath * index,UITextField * contentInput,UIButton *changeBtn);
@interface ModifyUserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;
@property (weak, nonatomic) IBOutlet UITextField *contentInput;
@property (strong, nonatomic) NSIndexPath * indexPath;
@property (copy, nonatomic) ModifyUserCellBlock  changeBlock;
@end
