//
//  SDCollectionPreCollectionViewCell.m
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/29.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "PublicDocuments.h"
#import "SDCollectionPreCollectionViewCell.h"
#import "UIView+SDExtension.h"

@implementation SDCollectionPreCollectionViewCell
{
    NSArray *lyricJson;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _backGView = [[UIView alloc]initWithFrame:CGRectMake(16, 0, IPHONE_WIDTH-32, (314+116)*kCustomFit)];
    _backGView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_backGView];
    [_backGView setCornerRadius:4 withShadow:YES withOpacity:10];
    
    _advImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,
                                                                 IPHONE_WIDTH-32, 314*kCustomFit)];
    [_backGView addSubview:_advImageView];
    _advImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:_advImageView.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerTopLeft) cornerRadii:CGSizeMake(4,4)];//圆角大小
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = _advImageView.bounds;
    maskLayer2.path = maskPath2.CGPath;
    _advImageView.layer.mask = maskLayer2;
    
    _contentLabel = [[UITextView alloc]init];
    _contentLabel.textColor = HexRGB(0x8A8F99);//33AAFF
    _contentLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.showsHorizontalScrollIndicator = NO;
    _contentLabel.showsVerticalScrollIndicator = NO;
//    _contentLabel.numberOfLines = 0;

//    _contentLabel.lineBreakMode = NSLineBreakByClipping;
    [_backGView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_advImageView.mas_bottom).offset(21);
        make.leading.equalTo(_backGView).offset(16);
        make.trailing.equalTo(_backGView).offset(-16);
        make.bottom.equalTo(_backGView.mas_bottom).offset(-22);
    }];
    
    _advImageView.backgroundColor = [UIColor whiteColor];
    
    if (kScreenWidth == 375&&kScreenHeight>667){
        _backGView.frame = CGRectMake(16, 0, IPHONE_WIDTH-32, (374+116)*kCustomFit);
        _advImageView.frame = CGRectMake(0, 0,
                                         IPHONE_WIDTH-32, 374*kCustomFit);
    }
    
//    if (!_progressTimer) {
//        _progressTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
//        [_progressTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
//
//    }
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pictureVoiceNot:) name:@"pictureVoiceNot" object:nil];
}

- (void)pictureVoiceNot:(NSNotification *)not{
    NSDictionary *tempDic = not.userInfo;
    
    if (_contentLabel.text.length == 0) {
        return;
    }
    //更新歌词
    for (int i = 0; i < lyricJson.count; i ++) {
        NSDictionary *model = lyricJson[i];
        
        NSInteger next = i + 1;
        
        NSDictionary *nextLrcModel = nil;
        if (next < lyricJson.count) {
            nextLrcModel = lyricJson[next];
        }
        NSLog(@"currentTime %@  tempDic %@  model  %@ ",tempDic[@"currentTime"],tempDic[@"totalTime"], model[@"time"]);
        //        NSLog(@"next %ld",next);  self.currentLcrIndex != i && currentTime >= model.msTime
        if (self.currentLcrIndex != i && [tempDic[@"currentTime"] floatValue]*1000 >= [model[@"time"] integerValue])
        {
            BOOL show = NO;
            if (nextLrcModel) {
                if (self.currentLcrIndex < [nextLrcModel[@"time"] integerValue]) {
                    show = YES;
                }
            }else{
                show = YES;
            }
            
            if (show) {
                NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                NSIndexPath *previousIndexPath = [NSIndexPath indexPathForRow:self.currentLcrIndex inSection:0];
                
                self.currentLcrIndex = i;
                
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_contentLabel.text];
                NSRange range1 = [[str string] rangeOfString:model[@"info"]];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range1];
                
                _contentLabel.attributedText = str;
                
                
                
                //                MusicLRCTableViewCell *currentCell = [self.lrcTableView cellForRowAtIndexPath:currentIndexPath];
                //                MusicLRCTableViewCell *previousCell = [self.lrcTableView cellForRowAtIndexPath:previousIndexPath];
                //
                //                //设置当前行的状态
                //                [currentCell reloadCellForSelect:YES];
                //                //取消上一行的选中状态
                //                [previousCell reloadCellForSelect:NO];
                //
                //
                //                if (!self.isDrag) {
                //
                //                    [self.lrcTableView scrollToRowAtIndexPath:currentIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                //                }
            }
        }
        
        if (self.currentLcrIndex == i) {
            //            MusicLRCTableViewCell *cell = [self.lrcTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            //            cell.lrcLable.progress = 1.0;
        }
    }
}

- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    NSArray *sentencesArray = _dataDic[@"sentences"];
  
    NSString *strstr;
    for (NSDictionary *tempDic in sentencesArray) {
        if (strstr) {
            strstr = [NSString stringWithFormat:@"%@\n%@",strstr,tempDic[@"en"]];
        }else{
            strstr = tempDic[@"en"];
        }
    }
    _contentLabel.text = strstr;
//    if (self.isChinese) {
//        _contentLabel.text = tempDic[@"cn"];
//    }else{
//        _contentLabel.text = ;;
//    }
//    lyricJson = tempDic[@"lyricJson"][@"list"];;
}



@end
