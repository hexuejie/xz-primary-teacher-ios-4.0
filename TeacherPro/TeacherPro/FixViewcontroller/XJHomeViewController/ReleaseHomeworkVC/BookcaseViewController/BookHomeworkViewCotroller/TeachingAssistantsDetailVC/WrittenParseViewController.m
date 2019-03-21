
//
//  WrittenParseViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/11/3.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

//编写解析
#import "WrittenParseViewController.h"


#import "WrittenParseItemConentImageCell.h"
#import "WrittenParseItemTextCell.h"
#import "WrittenParseItemUploadImageCell.h"
#import "JFTopicParseNewBottomView.h"
#import "AssistantsQuestionModel.h"

#import "JFTopicParseNewAddSectionCell.h"
#import "SessionHelper.h"
#import "SessionModel.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "XXYActionSheetView.h"
#import "UploadFileModel.h"
#import "TabbarConfigManager.h"


NSString * const JFTopicParseNewAddSectionCellIdentifier = @"JFTopicParseNewAddSectionCellIdentifier";

NSString * const WrittenParseItemConentImageCellIdentifier = @"WrittenParseItemConentImageCellIdentifier";

NSString * const WrittenParseItemTextCellIdentifier = @"WrittenParseItemTextCellIdentifier";
NSString * const WrittenParseItemUploadImageCellIdentifier = @"WrittenParseItemUploadImageCellIdentifier";
#define   bottomHeight   65

#define     KWdefaultImageHeight  100
@interface WrittenParseViewController ()<TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic, strong) JFTopicParseNewBottomView * bottomView;
@property(nonatomic, copy) NSString * bookId;
@property(nonatomic, copy) NSString * bookName;
@property(nonatomic, strong) QuestionModel * model;
@property(nonatomic, copy) NSString * analysis;
@property(nonatomic, copy) NSString * analysisPicUrl;
@property(nonatomic, assign) BOOL sharing;//是否分享  默认是分享
@property(nonatomic, strong) NSMutableArray *selectedPhotos;//图片数据
@property(nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property(nonatomic, assign) BOOL isHasUploadImg;//是否有需要上传的图片


@end

@implementation WrittenParseViewController

- (instancetype)initWithBookId:(NSString *)bookId withBookName: (NSString *)bookName withModel:(QuestionModel *)model{
    if (self == [super init]) {
        self.bookId = bookId;
        self.model = model;
        self.bookName = bookName;
        self.sharing = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configTableView];
  if (!self.model.myAnalysis.analysisPic && !self.model.myAnalysis.analysis) {
       self.title = @"添加解析";
    }else{
        self.title = @"修改解析";
    }

    [self.view addSubview:self.bottomView];
    [self configurationBottomView];
    if (self.model.myAnalysis.analysisPic) {
        self.analysisPicUrl = self.model.myAnalysis.analysisPic;
    }
    if (self.model.myAnalysis.analysis) {
        self.analysis = self.model.myAnalysis.analysis;
    }
}
- (void)configTableView{
    self.tableView.backgroundColor = [UIColor clearColor];
    // 隐藏UITableViewStyleGrouped上边多余的间隔
    self.view.backgroundColor = project_background_gray;
}
- (void)configurationBottomView{
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
       
        CGFloat top = self.view.frame.size.height - bottomHeight;
        make.leading.mas_equalTo(self.view.mas_leading);
        make.trailing.mas_equalTo(self.view.mas_trailing);
        make.top.mas_equalTo(@(top));
        make.height.mas_equalTo(@(bottomHeight));
    }];
}
- (JFTopicParseNewBottomView *)bottomView{
    
    if (!_bottomView) {
        
        _bottomView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([JFTopicParseNewBottomView class]) owner:nil options:nil].firstObject;
        WEAKSELF
        _bottomView.sureBlock = ^(BOOL state) {
//            weakSelf.sharing = state;
            [weakSelf requestTeacherAddOrUpdateQuestAnalysis];
        };
        _bottomView.backgroundColor = [UIColor clearColor];
    }
    return _bottomView;
}

- (UITableViewStyle)getTableViewStyle{
    
    return UITableViewStyleGrouped;
}
- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JFTopicParseNewAddSectionCell   class]) bundle:nil] forCellReuseIdentifier:JFTopicParseNewAddSectionCellIdentifier];
 
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WrittenParseItemConentImageCell class]) bundle:nil] forCellReuseIdentifier:WrittenParseItemConentImageCellIdentifier];
 
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WrittenParseItemTextCell class]) bundle:nil] forCellReuseIdentifier:WrittenParseItemTextCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WrittenParseItemUploadImageCell class]) bundle:nil] forCellReuseIdentifier:WrittenParseItemUploadImageCellIdentifier];
}


- (CGRect)getTableViewFrame{
    
    return CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - bottomHeight);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row =  0;
    switch (section) {
        case 0:
            row = 1;
            break;
        case 1:
            row = 1;
            break;
        case 2:
            row = 2;
            break;
        default:
            break;
    }
    return row;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height =  44;
    if (indexPath.section == 0) {
        height = 50;
    }else if (indexPath.section == 1){
        height = 180;
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
             height = 50;
        }else {
             height = 140;
        }
        
    }
    return height;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [UIView new];
    return headerView;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footerView = [UIView new];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2)];
    imageView.backgroundColor = [UIColor clearColor];
    [footerView addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"edge_shadow_img"];
    
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height =  0.00001;
    if (section == 0) {
        height = 6;
    }
    return height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGFloat height =  0.00001;
    if (section == 0) {
        height = 6;
    }else if (section == 1) {
        height = 10;
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =  nil;
    
    if (indexPath.section == 0) {
        cell =  [self confightSectionCell:tableView withIndexPath:indexPath];
    }else if (indexPath.section == 1){
        cell = [self confightInputTextCell:tableView withIndexPath:indexPath];
    }else if (indexPath.section == 2){
        if (indexPath.row ==  0) {
            cell =  [self confightSectionCell:tableView withIndexPath:indexPath];
        }else  if (indexPath.row == 1) {
            cell = [self confightUploadImageCell:tableView withIndexPath:indexPath];
        }
    }

    //    switch (indexPath.row) {
    //        case 0:
    //            if (indexPath.section == 0) {
    //
    ////                WrittenParseItemTitleCell * tempCell = [tableView dequeueReusableCellWithIdentifier:WrittenParseItemTitleCellIdentifier];
    ////                  [tempCell setupModel:self.model];
    ////                 cell = tempCell;
    //            }else{
    //
    ////                WrittenParseItemDecTitleCell * tempCell = [tableView dequeueReusableCellWithIdentifier:WrittenParseItemDecTitleCellIdentifier];
    ////                if (indexPath.section ==1) {
    ////                      [tempCell setupTitle:@"文字解析"];
    ////                }else{
    ////                     [tempCell setupTitle:@"解析图片"];
    ////                }
    ////                 cell = tempCell;
    //            }
    //            break;
    //        case 1:
    //            if (indexPath.section == 0) {
    //                WrittenParseItemConentImageCell  * tempCell = [tableView dequeueReusableCellWithIdentifier:WrittenParseItemConentImageCellIdentifier];
    //                cell = tempCell;
    //            }else if (indexPath.section == 1){
    //                WrittenParseItemTextCell * tempCell = [tableView dequeueReusableCellWithIdentifier:WrittenParseItemTextCellIdentifier];
    //                [tempCell setupText:self.model.myAnalysis.analysis];
    //                WEAKSELF
    //                tempCell.inputTextBlock = ^(NSString *inputText) {
    //                    weakSelf.analysis = inputText;
    //                };
    //                cell = tempCell;
    //            }else if (indexPath.section == 2){
    //                WrittenParseItemUploadImageCell * tempCell = [tableView dequeueReusableCellWithIdentifier:WrittenParseItemUploadImageCellIdentifier];
    //                if (self.isHasUploadImg) {
    //                    UIImage * image = self.selectedPhotos.firstObject;
    //                    [tempCell setupImage:image ];
    //                }else{
    //                    if (self.model.myAnalysis.analysisPic) {
    //                       [tempCell setupImageUrl:self.model.myAnalysis.analysisPic];
    //                    }
    //                }
    //
    //                tempCell.addImageBlock = ^{
    //                    [self gotoAddUploadImage];
    //                };
    //                cell = tempCell;
    //            }
    //            break;
    //        default:
    //            break;
    //    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//标题
- (UITableViewCell *)confightSectionCell:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    JFTopicParseNewAddSectionCell * tempCell = [self.tableView dequeueReusableCellWithIdentifier:JFTopicParseNewAddSectionCellIdentifier];
    NSString *iconImg = @"";
    NSString *titleName = @"";
    BOOL  isShow = NO;
    if (indexPath.section == 0) {
        iconImg = @"jf_add_parse_openness_icon";
        titleName = @"公开我的试题解析";
        isShow = YES;
    }else if (indexPath.section == 2){
        iconImg = @"jf_add_parse_upload_icon";
        titleName = @"上传试题解析图片";
    }
    [tempCell setupIconImageName:iconImg withTitle:titleName];
    [tempCell setupSwitch:isShow];
    WEAKSELF
    tempCell.switchBlock = ^(BOOL state) {
       weakSelf.sharing = state;
    };
    return tempCell;
}
//文字解析
- (UITableViewCell *)confightInputTextCell:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
 
    WrittenParseItemTextCell * tempCell = [tableView dequeueReusableCellWithIdentifier:WrittenParseItemTextCellIdentifier];
    [tempCell setupText:self.model.myAnalysis.analysis];
    WEAKSELF
    tempCell.inputTextBlock = ^(NSString *inputText) {
        weakSelf.analysis = inputText;
    };
    
    return tempCell;
}

//上传图片
- (UITableViewCell *)confightUploadImageCell:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    
    WrittenParseItemUploadImageCell * tempCell = [tableView dequeueReusableCellWithIdentifier:WrittenParseItemUploadImageCellIdentifier];
    if (self.isHasUploadImg) {
        UIImage * image = self.selectedPhotos.firstObject;
        [tempCell setupImage:image ];
    }else{
        if (self.model.myAnalysis.analysisPic) {
            [tempCell setupImageUrl:self.model.myAnalysis.analysisPic];
        }
    }
    tempCell.addImageBlock = ^{
        [self gotoAddUploadImage];
    };
    tempCell.deleteImageBlock = ^(){
        self.analysisPicUrl = nil;
        [self.selectedPhotos  removeAllObjects];
        [self.selectedAssets removeAllObjects];
        self.isHasUploadImg = NO;
    };
    return tempCell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestTeacherAddOrUpdateQuestAnalysis{
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    NSString * unitId = self.model.unitId;
    NSString * questionNum = self.model.questionNum;
    
    if (!self.bookId || !self.model ) {
        return;
    }
    
    [dic addEntriesFromDictionary: @{@"bookId":self.bookId,@"bookType":@"JFBook",@"unitId":unitId,@"questionNum":questionNum}];
   
    if (self.isHasUploadImg) {
        [self uploadImgV];
        return ;
    }
  
    if (self.analysis) {
           [dic addEntriesFromDictionary:@{@"analysis":self.analysis}];
    }
    if (self.analysisPicUrl) {
          [dic addEntriesFromDictionary:@{@"analysisPicUrl":self.analysisPicUrl}];
    }
   bool  tempSaring  = false ;
    if (self.sharing) {
        tempSaring = true;
    }
    [dic addEntriesFromDictionary:@{@"sharing":@(tempSaring)}];
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherAddOrUpdateQuestAnalysis ] parameterDic:dic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherAddOrUpdateQuestAnalysis];
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_TeacherAddOrUpdateQuestAnalysis) {
            NSLog(@"添加解析成功");
            if ([strongSelf.delegate respondsToSelector:@selector(updateMyParse)]) {
                QuestionAnalysisModel * myAnalysis = [[QuestionAnalysisModel alloc]init];
                if (strongSelf.analysis) {
                  myAnalysis.analysis = strongSelf.analysis;
                }
                if (strongSelf.analysisPicUrl) {
                    myAnalysis.analysisPic = strongSelf.analysisPicUrl ;
                }
                strongSelf.model.myAnalysis = myAnalysis;
                [strongSelf.delegate updateMyParse ];
            }
            [strongSelf backViewController];
        }
    }];
}

- (void)gotoAddUploadImage{
    
    [self pushImagePickerController];
}
 
- (void)pushImagePickerController {
    int  MAX_IMAGE_COUNT = 1;
    int  COLUMN_IMAGE_COUNT =  4;
    if ( MAX_IMAGE_COUNT  <= 0) {
        return;
    }
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:MAX_IMAGE_COUNT columnNumber:COLUMN_IMAGE_COUNT delegate:self pushPhotoPickerVc:YES];
    
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = NO;
    
    if (MAX_IMAGE_COUNT > 1) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    }
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // imagePickerVc.navigationBar.translucent = NO;
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = NO;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    imagePickerVc.circleCropRadius = 100;
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //imagePickerVc.allowPreview = NO;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    [imagePickerVc setNaviBgColor:project_main_blue];
    [imagePickerVc setNaviTitleFont:fontSize_18];
    
    [imagePickerVc setDoneBtnTitleStr:@"确定"];
    
    [imagePickerVc setOKButtonTitleColorNormal:[UIColor whiteColor]];
    [imagePickerVc setOKButtonTitleColorDisabled:[UIColor lightGrayColor]];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}


// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    self.selectedPhotos = [NSMutableArray arrayWithArray:photos];
    self.selectedAssets = [NSMutableArray arrayWithArray:assets];
    self.isHasUploadImg = YES;
    NSArray * array = @[[NSIndexPath indexPathForRow:1 inSection:2]];
    [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
}

- (void)uploadImgV{
    WEAKSELF
    self.startedBlock = ^(NetRequest *request)
    {
        [weakSelf showHUDInfoByType:HUDInfoType_Loading];
    };
    NSURL * url = [NSURL URLWithString:Request_NameSpace_upload_internal];
    if ([[NSUserDefaults standardUserDefaults] integerForKey:EnvironmentIndex] == 2) {//181
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.1.181/res-upload/resource-upload-req"]];//
    }else if ([[NSUserDefaults standardUserDefaults] integerForKey:EnvironmentIndex] == 1) {//150
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://res.ajia.cn/res-upload/resource-upload-req"]];//
    }else if ([[NSUserDefaults standardUserDefaults] integerForKey:EnvironmentIndex] == 0) {//正式
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://res.ajia.cn/res-upload/resource-upload-req"]];//
    }
    
    NSDictionary * requestHeaders ;
    if ([[SessionHelper sharedInstance] checkSession]) {
        requestHeaders =@{@"auth-token":(SessionModel *)[[SessionHelper sharedInstance] getAppSession].token};
    }
    NSMutableDictionary * fileDic = [NSMutableDictionary dictionary];
    for (int i =0;i<[self.selectedAssets count] ;i++) {
        UIImage * image = self.selectedPhotos[i];
        
        
        NSString * fileName = @"";
        if (iOS8Later) {
            
            PHAsset * asset = self.selectedAssets[i];
            fileName= asset.localIdentifier;
       
        } else {
            ALAsset * asset = self.selectedAssets[i];
            fileName =  asset.defaultRepresentation.filename;
            
        }
        
        [fileDic setObject:image forKey: fileName];
    }
    
    if ([self.selectedAssets count] > 0) {
        
        [[NetRequestManager sharedInstance] sendUploadRequest:(NSURL *)url parameterDic:@{@"appType":@"Primary",@"busiType":@"avatar"} requestMethodType:RequestMethodType_UPLOADIMG requestTag:NetRequestType_TeacherUploadImage  delegate:self fileDic:fileDic];
    }
    
    
}

- (void)netRequest:(NetRequest *)request successWithInfoObj:(id)infoObj{
    if (request.tag == NetRequestType_TeacherUploadImage) {
        UploadFileModel *uplaodImageModel = [[UploadFileModel alloc]initWithDictionary:infoObj error:nil];
        self.isHasUploadImg = NO;
        self.analysisPicUrl =[ uplaodImageModel.visitUrls allValues].firstObject;
        [self requestTeacherAddOrUpdateQuestAnalysis];
    }else{
        [super netRequest:request successWithInfoObj:infoObj];
    }
}

@end
