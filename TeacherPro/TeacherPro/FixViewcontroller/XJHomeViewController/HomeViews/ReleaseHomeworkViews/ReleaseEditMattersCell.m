//
//  ReleaseEditMattersCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/13.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ReleaseEditMattersCell.h"
#import "PublicDocuments.h"
#import "Masonry.h"
#define kPadding 2
@interface ReleaseEditMattersCell()<UITextViewDelegate>
@property (nonatomic, strong) SZTextView *textView;
@end
@implementation ReleaseEditMattersCell
- (void)setupContentInfo:(NSString *)content withRow:(NSInteger )row{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans"];
    formatter.locale = locale;
//    formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
    
    NSString *rowStr = [formatter stringFromNumber:[NSNumber numberWithInteger: row+1]];
    self.textView.placeholder = [NSString stringWithFormat:@"事项%@",rowStr];
    if (content) {
       
        self.textView.frame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y
                                         , self.textView.frame.size.width, self.textView.frame.size.height+26);
       self.textView.text = content; 
    }
    
    self.mattersNumber.text =  [NSString stringWithFormat:@"%zd.",row+1];
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.textView];
       
        [self.contentView addSubview:self.mattersNumber];
    }
    return self;
}

- (UILabel *)mattersNumber{

    if (!_mattersNumber) {
        _mattersNumber = [[UILabel alloc]initWithFrame:CGRectMake(6, 10, 40, 20)];
        _mattersNumber.backgroundColor = [UIColor clearColor];
        _mattersNumber.textColor = UIColorFromRGB(0x4d4d4d);
        _mattersNumber.textAlignment =  NSTextAlignmentCenter;
        _mattersNumber.font = [UIFont systemFontOfSize:16];
        _mattersNumber.text = @"1.";
        
    }
    return _mattersNumber;
}
- (SZTextView *)textView
{
    if (_textView == nil) {
        CGRect cellFrame = CGRectMake(35, 0, self.contentView.bounds.size.width-60, self.contentView.bounds.size.height)  ;
        cellFrame.origin.y += kPadding;
        cellFrame.size.height -= kPadding;
        
        _textView = [[SZTextView alloc] initWithFrame:cellFrame];
        _textView.delegate = self;
        
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font =  systemFontSize(16);
        _textView.textColor = UIColorFromRGB(0x4D4D4D);
        _textView.placeholderTextColor = UIColorFromRGB(0xB3B3B3);
        _textView.scrollEnabled = NO;
        _textView.showsVerticalScrollIndicator = NO;
        _textView.showsHorizontalScrollIndicator = NO;
        // textView.contentInset = UIEdgeInsetsZero;
    }
    return _textView;
}

- (void)setText:(NSString *)text
{
    _text = text;
    
    // update the UI and the cell size with a delay to allow the cell to load
    self.textView.text = text;
    [self performSelector:@selector(textViewDidChange:)
               withObject:self.textView
               afterDelay:0.1];
}

- (CGFloat)cellHeight
{
    return [self.textView sizeThatFits:CGSizeMake(self.textView.frame.size.width , FLT_MAX)].height + kPadding * 2;
}


#pragma mark - Text View Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        
        //在这里做你响应return键的代码
        if ([textView.text length] >0) {
            if ([self.expandableTableView.delegate conformsToProtocol:@protocol(ReleaseEditMattersDelegate)]) {
              id<ReleaseEditMattersDelegate> delegate = (id<ReleaseEditMattersDelegate>)self.expandableTableView.delegate;
                [delegate textViewShouldReturn];
            
            }
        }
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    if ([self.delegate respondsToSelector:@selector(customTextView:shouldChangeTextInRange:replacementText:)]) {
        [self.delegate customTextView:textView shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    // make sure the cell is at the top
    [self.expandableTableView scrollToRowAtIndexPath:[self.expandableTableView indexPathForCell:self]
                                    atScrollPosition:UITableViewScrollPositionTop
                                            animated:YES];
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.expandableTableView.delegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
            [(id<ReleaseEditMattersDelegate>)self.expandableTableView.delegate textViewDidBeginEditing:textView];
        }
    });
}


- (void)textViewDidChange:(UITextView *)theTextView
{
    if ([self.expandableTableView.delegate conformsToProtocol:@protocol(ReleaseEditMattersDelegate)]) {
       
        id<ReleaseEditMattersDelegate> delegate = (id<ReleaseEditMattersDelegate>)self.expandableTableView.delegate;
        NSIndexPath *indexPath = [self.expandableTableView indexPathForCell:self];
        
        // update the text
        _text = self.textView.text;
        
        [delegate tableView:self.expandableTableView
                updatedText:_text
                atIndexPath:indexPath];
        
        CGFloat newHeight = [self cellHeight];
        CGFloat oldHeight = [delegate tableView:self.expandableTableView heightForRowAtIndexPath:indexPath];
        if (fabs(newHeight - oldHeight) > 0.01) {
            
            // update the height
            if ([delegate respondsToSelector:@selector(tableView:updatedHeight:atIndexPath:)]) {
                [delegate tableView:self.expandableTableView
                      updatedHeight:newHeight
                        atIndexPath:indexPath];
            }
            
            // refresh the table without closing the keyboard
            [self.expandableTableView beginUpdates];
            [self.expandableTableView endUpdates];
            NSLog(@"%f",self.expandableTableView.contentSize.height);
            
        }
    }
}

@end
