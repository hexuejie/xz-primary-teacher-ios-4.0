//
//  SubBookCartoonPreViewController.h
//  TeacherPro
//
//  Created by 何学杰 on 2018/12/5.
//  Copyright © 2018年 ZNXZ. All rights reserved.
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
#import "AssistantsHomeworkViewController.h"
#import "ReleaseAddBookworkCell.h"
#import "BookPreCartoonHeader.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^BookPreviewDetailSelectedBlock)(NSIndexPath * indexPath);
@interface SubBookCartoonPreViewController : BaseCollectionViewController<ReleaseAddBookworkCellDelegate> ////////绘本  BookTypeCartoon
////////绘本 预览 子页面

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



- (instancetype)initWithBookId:(NSString *)bookId withExistsBookcase:(BOOL)isExists;
- (instancetype)initWithFromHomeBookId:(NSString *)bookId  withExistsBookcase:(BOOL)isExists;

- (void)uploadeView;
@property(nonatomic, strong) NSIndexPath * indexPath;
@property(nonatomic, strong) BookPreviewDetailSelectedBlock   selectedBlock;

@end

NS_ASSUME_NONNULL_END