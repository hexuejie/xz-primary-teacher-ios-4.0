//
//  ReleaseCopyEditorViewCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/13.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ReleaseCopyEditorBlock)(NSMutableArray * inputContents);
@interface ReleaseCopyEditorViewCell : UITableViewCell
@property(nonatomic, copy) ReleaseCopyEditorBlock inputBlock;
- (void)setupCopyEditor:(NSString *)inputText;
@end
