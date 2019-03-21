//
//  ClassChooseTableViewCell.m
//  TeacherPro
//
//  Created by 何学杰 on 2018/11/19.
//  Copyright © 2018年 ZNXZ. All rights reserved.
//

#import "ClassChooseCollectionViewCell.h"
#import "ClassChooseTableViewCell.h"
#import "ClassManageModel.h"

@interface ClassChooseTableViewCell ()<ClassChooseCollectionViewCellDelegate>

@end

@implementation ClassChooseTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        
        [self layoutView];
    }
    return self;
}

- (void)layoutView{
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    
}

-(NSMutableArray *)classViews{
    if (_classViews != nil){
        return _classViews;
    }
    
    _classViews = [NSMutableArray arrayWithCapacity:0];
    return _classViews;
}

-(void)setClassArray:(NSMutableArray *)classArray{
    
    _classArray = classArray;
    
    while (self.classViews.count > _classArray.count) {
        ClassChooseCollectionViewCell *item = [self.classViews lastObject];//class
        [item removeFromSuperview];
        [self.classViews addObject:item];
        [self.classViews removeLastObject];
    }
    
    while (_classArray.count > self.classViews.count) {
        
        ClassChooseCollectionViewCell *item = nil;
//        if(self.classViews.count >0){
//            item = [self.classViews lastObject];
//            [self.classViews removeLastObject];
//        }else{
            item = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ClassChooseCollectionViewCell class]) owner:nil options:nil].firstObject;
//        }
        item.delegate = self;
        [self.classViews addObject:item];
    }
    [self layoutCommentViews];
}


-(void)layoutCommentViews{
    
    CGFloat itemWidth = (kScreenWidth-13*3-16*2)/4;//减去间距 一行三个
    CGFloat itemHeight = itemWidth*36/76;
    
    if (self.classArray.count == 0){
        return;
    }
    NSInteger loopNumber = self.classViews.count;
    
    for (int i=0 ; i< loopNumber;i++){
        
        NSInteger itemY = floor(i/4);
        NSInteger itemX = i%4;
        
        ClassChooseCollectionViewCell *replyView = self.classViews[i];
        
        ClassManageModel *coment = self.classArray[i];
        replyView.tag = i;
        replyView.model = coment;
        [self.contentView addSubview:replyView];
        
        [replyView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset((itemHeight+10)*itemY +15);
            make.leading.equalTo(self.contentView.mas_leading).offset(16 +itemX*(itemWidth+13));
            make.width.mas_equalTo(itemWidth);
            make.height.mas_equalTo(itemHeight);
        }];
        
        if (i == loopNumber -1){
            [replyView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
            }];
        }
    }
}

- (void)didChooseButton:(ClassChooseCollectionViewCell *)cell{
    if ([self.delegate respondsToSelector:@selector(didChooseButtonCell:ChooseItem:)]) {
        [self.delegate didChooseButtonCell:self ChooseItem:cell];
    }
}

@end
