//
//  ReleaseEditMattersCell.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/13.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTextView.h"

@protocol ReleaseEditMattersDelegate <UITableViewDelegate, UITextViewDelegate>

@required
- (void)tableView:(UITableView *)tableView updatedText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath;


@optional
- (void)tableView:(UITableView *)tableView updatedHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath;
- (void)textViewShouldReturn;


- (void)customTextView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

@end
@interface ReleaseEditMattersCell : UITableViewCell
@property (nonatomic, weak) UITableView *expandableTableView;
@property (nonatomic, strong) UILabel * mattersNumber;
@property (nonatomic, strong, readonly) SZTextView *textView;

@property (nonatomic, readonly) CGFloat cellHeight;
@property (nonatomic, strong) NSString *text;

@property (nonatomic,weak) id<ReleaseEditMattersDelegate>delegate;

- (void)setupContentInfo:(NSString *)content withRow:(NSInteger )row;
@end
