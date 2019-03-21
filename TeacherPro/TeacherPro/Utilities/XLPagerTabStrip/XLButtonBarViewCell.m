//
//  XLButtonBarViewCell.m
//  XLPagerTabStrip ( https://github.com/xmartlabs/XLPagerTabStrip )
//
//  Copyright (c) 2015 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "XLButtonBarViewCell.h"

@interface XLButtonBarViewCell()

@property IBOutlet UIImageView * imageView;
@property IBOutlet UILabel * label;
@property IBOutlet UIButton * button;
@end

@implementation XLButtonBarViewCell

- (void)awakeFromNib{

    [super awakeFromNib];
    self.button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    self.button.titleLabel.font = [UIFont systemFontOfSize:15];
    self.backgroundColor = [UIColor clearColor];
    
}
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (!self.label.superview){
        // If label wasn't configured in a XIB or storyboard then it won't have
        // been added to the view so we need to do it programmatically.
        [self.contentView addSubview:self.label];
        self.label.frame = self.contentView.bounds;
    }
}
-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:14];
    }
    return _label;
}


@end
