//
//  CartoonProfilePreviewCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/20.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "CartoonProfilePreviewCell.h"
#import "PublicDocuments.h"

@interface CartoonProfilePreviewCell()
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end
@implementation CartoonProfilePreviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSubview];
}

- (void)setupSubview{

}

- (void)setupDetailName:(NSString *)detail{

    self.detailLabel.text = detail;
}
@end
