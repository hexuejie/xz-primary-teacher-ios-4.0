
//
//  BookSearchHotContentCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/20.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookSearchHotContentCell.h"
#import "TagView.h"
#import "PublicDocuments.h"
#import "SearchModel.h"
@interface BookSearchHotContentCell ()<TagViewDelegate>
@property (nonatomic ,strong)TagView * tagView;
@property (nonatomic, strong) NSArray * dataArray;
@end
@implementation BookSearchHotContentCell

//- (void)awakeFromNib {
//    [super awakeFromNib];
//
//    [self setupSubView];
//
//}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubView];
    }
    return self;
    
}

- (void)setupSubView{
    [self addSubview:self.tagView];
    self.tagView.textColor = UIColorFromRGB(0x4D4D4D);
    self.tagView.itemBgColor = UIColorFromRGB(0xF4F4F4);
    self.tagView.edgeLineColor = [UIColor clearColor];
    self.tagView.btnFont = [UIFont systemFontOfSize:14];
    
}
-(TagView *)tagView{
    if (!_tagView) {
        _tagView = [[TagView alloc]initWithFrame:CGRectMake(0, 0,IPHONE_WIDTH, 0)];
        _tagView.backgroundColor = [UIColor whiteColor];
        _tagView.delegate = self;
    }
    return _tagView;
}

- (void)setupData:(NSArray *)array{
     self.dataArray = array;
      NSArray *arr = [BookSearchHotContentCell getSearchName:array];
      self.tagView.arr = arr;
}

+ (NSArray *)getSearchName:(NSArray *)array{
    
    NSMutableArray * tempArray = [NSMutableArray array];
    for (SearchModel * model in array) {
        [tempArray addObject: model.name];
    }
    return tempArray;
}
+ (CGFloat)getCellHeight:(NSArray *)array{
    
    CGFloat height = 0;
    NSArray *arr = [BookSearchHotContentCell getSearchName:array];
    height = [TagView getViewHeightData:arr];
    return height;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - CCTagViewDelegate
-(void)handleSelectTag:(NSString *)keyWord{
    NSLog(@"keyWord ---- %@",keyWord);
    if (self.searchBlock) {
        self.searchBlock(keyWord);
    }
}
@end
