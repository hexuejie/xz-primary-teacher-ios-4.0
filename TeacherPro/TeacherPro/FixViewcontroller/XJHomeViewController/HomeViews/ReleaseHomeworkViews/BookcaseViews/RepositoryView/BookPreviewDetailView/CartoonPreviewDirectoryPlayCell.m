//
//  CartoonPreviewDirectoryPlayCell.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/20.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "CartoonPreviewDirectoryPlayCell.h"
#import "UIImageView+WebCache.h"

@interface CartoonPreviewDirectoryPlayCell()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImgV;
@property (weak, nonatomic) IBOutlet UIImageView *playImgV;
@property (weak, nonatomic) IBOutlet UIView *imagePlase;

@end
@implementation CartoonPreviewDirectoryPlayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundImgV.layer.cornerRadius = 4.0;
    self.backgroundImgV.layer.masksToBounds = YES;
    self.imagePlase.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    self.imagePlase.hidden = YES;
    [self setupSubview];
}

- (void)setupSubview{

    
}

- (void)setupImageUrl:(NSString *)url{

    UIImage *placeholderImage =  nil;
    [self.backgroundImgV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholderImage];
}
@end
