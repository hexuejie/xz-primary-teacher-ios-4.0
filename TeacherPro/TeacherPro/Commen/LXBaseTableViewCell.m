//
//  LXBaseTableViewCell.m
//  lexiwed2
//
//  Created by Kyle on 2017/3/22.
//  Copyright © 2017年 乐喜网. All rights reserved.
//

#import "LXBaseTableViewCell.h"
#import "NSObject+Extension.h"


@interface  LXBaseTableViewCell()

@property (nonatomic, strong, readwrite) NSIndexPath *indexPath;
@property (nonatomic, strong, readwrite) LXSeparateView *lineView;

@end

@implementation LXBaseTableViewCell


-(id)init{
    
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[[self class] className]];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setup];
    }
    return self;
}


-(void)setup{

    self.selectionStyle = UITableViewCellSelectionStyleNone;

    self.lineView.backgroundColor = HexRGB(0xF7F7F7);
    [self.contentView addSubview:self.lineView];

    _lineHeight = 1;
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(_lineHeight);
    }];
    
}



#pragma mark
#pragma mark property

-(LXSeparateView *)lineView{
    if (_lineView != nil){
        return _lineView;
    }
    
    _lineView = [[LXSeparateView alloc]initWithFrame:CGRectZero];
    return _lineView;
}

-(void)setLineHeight:(CGFloat)lineHeight{

    if (_lineHeight == lineHeight){
        return;
    }

    _lineHeight = lineHeight;
    if(_lineHeight <= 0){
        _lineHeight = 0;
    }

    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_lineHeight);
    }];
    
}



-(NSIndexPath *)indexPath{
    
    UIView *superView = self.superview;
    UITableView *superTableView = nil;
    
    while (superView != nil) {
        if ([superView isKindOfClass:[UITableView class]]){
            superTableView = (UITableView *)superView;
            break;
        }
        superView = superView.superview;
    }
    
    if (superTableView ==nil){
        return nil;
    }    
    return [superTableView indexPathForCell:self];
    
}




-(void)setLineEdge:(UIEdgeInsets)lineEdge{
    if (UIEdgeInsetsEqualToEdgeInsets(_lineEdge, lineEdge)){
        return;
    }
    _lineEdge = lineEdge;

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading).offset(_lineEdge.left);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(_lineEdge.right);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(_lineEdge.bottom);
        make.height.mas_equalTo(_lineHeight);
    }];
}



@end
