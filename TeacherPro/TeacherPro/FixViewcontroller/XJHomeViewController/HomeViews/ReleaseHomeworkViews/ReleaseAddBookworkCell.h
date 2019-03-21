//
//  ReleaseAddBookworkCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/13.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ReleaseAddBookworkBlock)();
@class ReleaseAddBookworkCell;

@protocol ReleaseAddBookworkCellDelegate <NSObject>

- (void)didAddBookwork:(ReleaseAddBookworkCell *)header;

@end

@interface ReleaseAddBookworkCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonCenterY;

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property(nonatomic, assign) id<ReleaseAddBookworkCellDelegate> delegate;
@property(nonatomic, copy) ReleaseAddBookworkBlock  addBookBlock;



@end
