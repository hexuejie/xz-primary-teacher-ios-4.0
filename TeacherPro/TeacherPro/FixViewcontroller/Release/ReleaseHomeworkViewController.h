//
//  ReleaseHomeworkViewController.h
//  TeacherPro
//
//  Created by DCQ on 2017/6/13.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "BaseTableViewController.h"

#define MAX_IMAGE_COUNT             9
#define COLUMN_IMAGE_COUNT          4
#define itemHeight                  25

static NSString *const ReleaseStyleCellIdentifier = @"ReleaseStyleCellIdentifier";
static NSString *const ReleaseCopyEditorViewCellIdentifier = @"ReleaseCopyEditorViewCellIdentifier";
static NSString *const ReleaseEditContentFooterViewIdentifier = @"ReleaseEditContentFooterViewIdentifier";
static NSString *const ReleaseEditMattersCellIdentifier = @"ReleaseEditMattersCellIdentifier";
static NSString *const AddReleaseEditMattersCellIdentifier = @"AddReleaseEditMattersCellIdentifier";
static NSString *const ReleaseImageCellIdentifier = @"ReleaseImageCellIdentifier";
static NSString *const ReleaseAddBookworkCellIdentifier = @"ReleaseAddBookworkCellIdentifier";
static NSString *const ReleaseBookworkCellIdentifier = @"ReleaseBookworkCellIdentifier";
static NSString *const ReleaseVoiceworkCellIdentifier = @"ReleaseVoiceworkCellIdentifier";
static NSString *const ReleaseHeaderViewIdentifier = @"ReleaseHeaderViewIdentifier";

@class UploadFileModel;
typedef NS_ENUM(NSInteger ,  ReleaseHomeworkSectionType){
    /**
     布置作业班级 时间 反馈类型选择 块
     */
    ReleaseHomeworkSectionType_complete  = 0,
    /**
     布置作业 消息内容类型标题切换选择
     */
    ReleaseHomeworkSectionType_contentTab  = 1,
    
    /**
     布置 录音
     */
    ReleaseHomeworkSectionType_voice    =  2,
    
    /**
     布置作业 图片
     */
    ReleaseHomeworkSectionType_images    = 3,
    
    /**
     布置 书本
     */
    ReleaseHomeworkSectionType_books    = 4,
} ;

@interface ReleaseHomeworkViewController : BaseTableViewController
- (instancetype)initWithData:(NSDictionary *)userInfo;
@property(nonatomic , copy)  NSString *  contentType; //消息内容类型(00-文字、01-事项
@property (nonatomic, strong) UploadFileModel *uplaodImageModel;//图片地址信息
@property (nonatomic, strong) UploadFileModel *uplaodAudioModel;//音频地址信息
@property(nonatomic, strong) NSMutableArray * inputContentArrays;//输入的内容
@property(nonatomic, strong) NSMutableArray *selectedVoice;//录音数据
@property(nonatomic, strong) NSMutableArray *selectedPhotos;//图片数据
@property(nonatomic, strong) NSMutableArray *selectedAssets;
@property(nonatomic, assign) NSInteger totalLength;//录音时长
- (void)uploadAudio;
- (void)uploadImgV;
@end
