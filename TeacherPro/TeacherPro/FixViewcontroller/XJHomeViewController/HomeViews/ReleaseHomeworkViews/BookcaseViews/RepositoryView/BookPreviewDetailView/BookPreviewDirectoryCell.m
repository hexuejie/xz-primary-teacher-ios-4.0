
//
//  BookPreviewDirectoryCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/6.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookPreviewDirectoryCell.h"
#import "PublicDocuments.h"
#import "BookPreviewModel.h"
@interface BookPreviewDirectoryCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property(nonatomic, weak)IBOutlet UILabel * directoryTitle;
@end
@implementation BookPreviewDirectoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{

}

- (void)setupDirectoryInfo:(BookUnitModel *)model{
    self.directoryTitle.textColor = HexRGB(0x525B66);
    self.directoryTitle.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.directoryTitle.text = model.unitName;
    self.leftConstraint.constant = 15;
}

- (void)setupChildrenDirectoryInfo:(BookUnitModel *)model{
    self.directoryTitle.textColor = HexRGB(0x8A8F99);
    self.directoryTitle.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    self.directoryTitle.text = model.unitName;
    self.leftConstraint.constant = 23;
}
@end
