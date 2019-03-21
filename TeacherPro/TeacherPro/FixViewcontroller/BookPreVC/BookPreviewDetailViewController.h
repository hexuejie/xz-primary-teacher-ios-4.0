//
//  BookPreviewDetailViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/9/5.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseCollectionViewController.h"
#import "BookPreviewModel.h"
#import "HWCircleView.h"
#import "ReleaseAddBookworkCell.h"
#import "BookPreviewModel.h"
#import "BookPreviewDirectoryCell.h"
#import "BookPreviewDetailTitleCell.h"
#import "BookPreviewDetailTypeCell.h"
#import "PreviewPictureBookAudioViewController.h"
#import "CartoonPreviewDirectoryPlayCell.h"
#import "CartoonProfilePreviewCell.h"
#import "ProUtils.h"
#import "HSDownloadManager.h"
#import "HWCircleView.h"
#import "BookcaseViewController.h"
#import "BookHomeworkViewController.h"
#import "ReleaseAddBookworkCell.h"
#import "BookPreCartoonHeader.h"
#import "XJRepositoryTipsView.h"

#define bottomViewHeight  65
#define kSureBgBtnTag  777676

typedef void(^BookPreviewDetailSelectedBlock)(NSIndexPath * indexPath);
@interface BookPreviewDetailViewController : BaseCollectionViewController <ReleaseAddBookworkCellDelegate> ////////绘本  BookTypeCartoon


@property (nonatomic, copy) NSString * courseType;
@property (nonatomic, copy) NSString * bookId;
//@property (nonatomic, copy) NSString * bookType;
@property (nonatomic, strong)BookPreviewModel *detailModel;

@property (nonatomic, assign) BOOL isExists;
@property (nonatomic, strong) NSDictionary * unityIconDic;//字段对应的图片

@property (nonatomic, strong) NSMutableArray * playCartoonBookArray;//播放的数据
@property (nonatomic, strong) NSMutableArray * cartoonBookDownloadUrlArray;//音频下载地址
@property (nonatomic, strong) NSMutableArray * cartoonBookImgArray;//图片
@property (nonatomic, assign) NSInteger currentDownPage;//
@property (nonatomic, assign) NSInteger downIndex;
@property (nonatomic, strong) HWCircleView *circleView;
@property (nonatomic, strong) UIView *mongoliaView;

@property (nonatomic, assign) BOOL isFromHome;///是否需要bottomview

@property (nonatomic, strong) ReleaseAddBookworkCell * bottomView;


- (instancetype)initWithBookId:(NSString *)bookId withExistsBookcase:(BOOL)isExists;
- (instancetype)initWithFromHomeBookId:(NSString *)bookId  withExistsBookcase:(BOOL)isExists;

- (void)uploadeView;
@property(nonatomic, strong) NSIndexPath * indexPath;
@property(nonatomic, strong) BookPreviewDetailSelectedBlock   selectedBlock;
@end
