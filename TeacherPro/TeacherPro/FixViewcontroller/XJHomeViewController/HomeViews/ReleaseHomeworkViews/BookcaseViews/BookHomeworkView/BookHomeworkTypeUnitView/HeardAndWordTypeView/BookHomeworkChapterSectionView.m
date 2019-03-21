
//
//  BookHomeworkChapterSectionView.m
//  TeacherPro
//
//  Created by DCQ on 2017/9/11.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BookHomeworkChapterSectionView.h"
#import "PublicDocuments.h"
@interface BookHomeworkChapterSectionView()
@property (weak, nonatomic) IBOutlet UILabel *chapterNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pointImgV;
@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end
@implementation BookHomeworkChapterSectionView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   [self setupSubView];
}

- (void)setupSubView{
    
    self.chapterNameLabel.textColor = UIColorFromRGB(0x6b6b6b);
    self.chapterNameLabel.font = fontSize_14;
    
    self.pointImgV.layer.masksToBounds = YES;
    self.pointImgV.layer.cornerRadius = 5;
    self.pointImgV.backgroundColor = UIColorFromRGB(0xff607a);
    
    self.topLine.backgroundColor = project_line_gray;
    self.bottomLine.backgroundColor = project_line_gray;
}
- (void)setupChapterName:(NSString *)unitName{
    
    self.chapterNameLabel.text = unitName;
}
@end
