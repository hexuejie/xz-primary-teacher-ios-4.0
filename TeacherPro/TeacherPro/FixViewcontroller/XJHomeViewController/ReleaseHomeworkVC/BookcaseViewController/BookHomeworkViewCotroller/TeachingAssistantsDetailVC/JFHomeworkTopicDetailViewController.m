//
//  JFHomeworkTopicDetailViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/12/20.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "JFHomeworkTopicDetailViewController.h"
#import "JFHomeworkTopicImageContentCell.h"
#import "JFHomeworkTopicContentSectionTitleCell.h"
#import "JFTopicParseItemOriginalCell.h"
#import "JFTopicAddMyParseCell.h"
#import "JFTopicOtherParseCell.h"
#import "JFAssistantsAnswerCell.h"
#import "ChooseParseDescriptionCell.h"
#import "TeachingAssistantsListBigItemAudioCell.h"
#import "ChooseParseMyEditCell.h"
#import "AssistantsQuestionModel.h"
#import "WrittenParseViewController.h"
#import "ZFPlayerView.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "UIImageView+WebCache.h"
#import "ProUtils.h"

#import "JFTopicOtherTeacherParseViewController.h"

#import "DSImageScrollItem.h"
#import "DSImageScrollView.h"
#import "DSImageShowView.h"

NSString * const JFHomeworkTopicImageContentCellIdentifier = @"JFHomeworkTopicImageContentCellIdentifier";

NSString * const JFHomeworkTopicContentSectionTitleCellIdentifier = @"JFHomeworkTopicContentSectionTitleCellIdentifier";
NSString * const JFTopicParseItemOriginalCellIdentifier = @"JFTopicParseItemOriginalCellIdentifier";
NSString * const JFTopicAddMyParseCellIdentifier = @"JFTopicAddMyParseCellIdentifier";
NSString * const JFTopicOtherParseCellIdentifier = @"JFTopicOtherParseCellIdentifier";
NSString * const JFAssistantsAnswerCellIdentifier = @"JFAssistantsAnswerCellIdentifier";
NSString * const  JFParseDescriptionCellIdentifier = @"JFParseDescriptionCellIdentifier";
NSString * const  JFTeachingAssistantsListBigItemAudioCellIdentifier = @"JFTeachingAssistantsListBigItemAudioCellIdentifier";
NSString * const  JFChooseParseMyEditCellIdentifier = @"JFChooseParseMyEditCellIdentifier";

#define   kBottomHeight   FITSCALE(60)
#define   KCdefaultImageHeight  120
@interface JFHomeworkTopicDetailViewController ()<ZFPlayerDelegate,WrittenParseViewDelegate>
@property(nonatomic, strong)  UIView * bottomView;

@property (nonatomic, strong) ZFPlayerView        *playerView;
@end

typedef NS_ENUM(NSInteger, JFHomeworkTopicType) {
    JFHomeworkTopicType_normal = -1,
    JFHomeworkTopicType_image = 0,//图片
    JFHomeworkTopicType_audios  ,//听力材料
    JFHomeworkTopicType_originalAnswer  ,//原书答案
    JFHomeworkTopicType_parse  ,//我的解析 和原书解析
    JFHomeworkTopicType_otherParse  ,//其它老师解析
};
@implementation JFHomeworkTopicDetailViewController

- (instancetype)initWithBookId:(NSString *)bookId withBookName: (NSString *)bookName withModel:(QuestionModel *)model withSelectedIndex:(NSInteger)selectedIndex{
    if (self = [super init]) {
        self.model = model;
        self.bookId = bookId;
        self.bookName = bookName;
        // 上一次选择中的解析
        if (selectedIndex != -1) {
            self.selectedIndex = selectedIndex;
        }else{
            if (self.model.myAnalysis) {
                ///我的解析
                self.selectedIndex = 2;
            }
            //原书解析
            else if (self.model.analysis ) {
                self.selectedIndex = 1;
            }
            else{
                self.selectedIndex = 3;
            }
        }
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = self.bookName;
    // Do any additional setup after loading the view.
    [self.view addSubview:self.bottomView];
    [self congfightBottomView];
    [self configTableView];
}

- (void)configTableView{
    self.tableView.backgroundColor = [UIColor clearColor];
    // 隐藏UITableViewStyleGrouped上边多余的间隔
    self.view.backgroundColor = project_background_gray;
}
- (UIView *)bottomView{
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - kBottomHeight, self.view.frame.size.width, kBottomHeight)];
    }
    return _bottomView;
}

- (void)congfightBottomView{
    
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确 定" forState:UIControlStateNormal];
    sureBtn.backgroundColor = project_main_blue;
    [sureBtn setFrame:CGRectMake(10, 10,self.view.frame.size.width - 10*2, kBottomHeight -10 *2)];
//    UIEdgeInsets edge = UIEdgeInsetsMake(0, 0, 0, 10);
//    [sureBtn setImageEdgeInsets: edge];
//    [sureBtn setImage:[UIImage imageNamed:@"sure_btn_icon"] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.layer.cornerRadius = (kBottomHeight -10*2)/2;
    sureBtn.layer.masksToBounds = YES;
    [self.bottomView addSubview:sureBtn];
    [self updateBottomView];
}

- (void)sureBtnAction:(id)sender{
    
    [self updatePopTopicListData];
    [self backViewController];
}

- (CGRect)getTableViewFrame{
    
    return CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kBottomHeight);
}

- (UITableViewStyle)getTableViewStyle{
    
    return UITableViewStyleGrouped;
}
- (void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JFHomeworkTopicImageContentCell  class ]) bundle:nil] forCellReuseIdentifier:JFHomeworkTopicImageContentCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JFHomeworkTopicContentSectionTitleCell  class ]) bundle:nil] forCellReuseIdentifier:JFHomeworkTopicContentSectionTitleCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JFTopicParseItemOriginalCell  class]) bundle:nil] forCellReuseIdentifier:JFTopicParseItemOriginalCellIdentifier];
 
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JFTopicAddMyParseCell  class]) bundle:nil] forCellReuseIdentifier:JFTopicAddMyParseCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JFTopicOtherParseCell class]) bundle:nil] forCellReuseIdentifier:JFTopicOtherParseCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JFAssistantsAnswerCell  class]) bundle:nil] forCellReuseIdentifier:JFAssistantsAnswerCellIdentifier];
     [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TeachingAssistantsListBigItemAudioCell  class]) bundle:nil] forCellReuseIdentifier:JFTeachingAssistantsListBigItemAudioCellIdentifier];
    
    [self.tableView registerClass:[ChooseParseDescriptionCell  class]   forCellReuseIdentifier:JFParseDescriptionCellIdentifier];
    
   [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ChooseParseMyEditCell  class]) bundle:nil] forCellReuseIdentifier:JFChooseParseMyEditCellIdentifier];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger section = 0;
    if (self.model) {
        //其它老师
        if ([self validationOtherParse] > 0) {
            section  = 4 + 1;
        }else{
             section  = 4 ;
        }
    }
    
    return section;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row =  0;
    row = [self getNumberOfRow:section];
    return row;
}

- (NSInteger)getNumberOfRow:(NSInteger)section{
     NSInteger row =  0;
    if (section == JFHomeworkTopicType_image) {
        //图片
        row =  [self.model.imgs  count] +1;
    }else if(section == JFHomeworkTopicType_audios){
        //听力材料
        if ([self validationIsAudio:self.model]) {
            if ([self.model.singleAudios count] > 0) {
                row = [self.model.singleAudios count] + 1;
            }else if ([self.model.continuousAudios count] > 0){
                row = [self.model.continuousAudios count] +1;
            }
        }
        
    }else  if (section == JFHomeworkTopicType_originalAnswer && self.model.answer) {
        //原书答案
        row = 2;
    }else if (section == JFHomeworkTopicType_parse ){
        
        //试题解析
        row =  1  + ([self validationMyParse]?2:1) + ([self validationOranageParse]?1:0);
        
    }else if (section == JFHomeworkTopicType_otherParse){
        if ([self validationOtherParse]) {
            row = 1;
        }
        
    }
    return row;
}

- (  UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.0001;
    if (section == 0) {
        height = 10;
    }
    return  height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGFloat height = FITSCALE(0.00001) ;
    if (section == JFHomeworkTopicType_image && [self.model.imgs  count] > 0) {
        height = FITSCALE(4);
    }else{
        if ([self validationIsAudio:self.model] && section == JFHomeworkTopicType_audios) {
             height = FITSCALE(10);
        }else if (section == JFHomeworkTopicType_originalAnswer && self.model.answer) {
            //原书答案
            height = FITSCALE(10);
        }else if (section == JFHomeworkTopicType_parse){
            //试题解析
           height = FITSCALE(10);
        }else if (section == JFHomeworkTopicType_otherParse){
            //其它老师试题解析
            height = FITSCALE(10);
        }
    }
    return height;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection: (NSInteger)section{
    UIView * footerView = [[UIView alloc]init];
    footerView.backgroundColor = [UIColor clearColor];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2)];
    imageView.backgroundColor = [UIColor clearColor];
    [footerView addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"edge_shadow_img"];
    
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height =  0;
    height = [self getTableView:tableView heightIndex:indexPath];
    return height;
}

// 获取高度
- (CGFloat )getTableView:(UITableView *)tableView heightIndex:(NSIndexPath *)indexPath{
    CGFloat height =  0;
    if (indexPath.section == 0) {
        //图片
        if (indexPath.row >0) {
            height = KCdefaultImageHeight;
        }
    }else if (indexPath.section == 1){
        //听力
        if (indexPath.row == 0) {
            height = 44;
        }else{
            height = FITSCALE(50);
        }
        
    }else if (indexPath.section == 2){
        //原书答案
        if (indexPath.row == 0) {
            height = 44;
        }else{
            height = [tableView fd_heightForCellWithIdentifier:JFAssistantsAnswerCellIdentifier configuration:^(id cell) {
                [self configureCell:cell atIndexPath:indexPath];
            } ] + 20;
        }
    }else if (indexPath.section == 3){
        //试题解析
        if (indexPath.row == 0) {
            height = 44;
        }else if (indexPath.row == 1) {
            //我的解析
            if (![self validationMyParse]) {
                height =  100;
            }else{
                QuestionAnalysisModel * model =  self.model.myAnalysis;
                height =  [self.tableView  cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ChooseParseDescriptionCell class] contentViewWidth:[self cellContentViewWith]];
            }
            
        }else if (indexPath.row == 2){
            //我的解析
            if ([self validationMyParse]) {
                height =  44;
            }else{
                //原书解析
                height = [self.tableView fd_heightForCellWithIdentifier:JFTopicParseItemOriginalCellIdentifier   configuration:^(id cell) {
                [self configureOriginalCell:cell atIndexPath:indexPath];
                } ]  ;
                
            }
        }else if (indexPath.row == 3){
            //原书解析
            height = [self.tableView fd_heightForCellWithIdentifier:JFTopicParseItemOriginalCellIdentifier   configuration:^(id cell) {
                [self configureOriginalCell:cell atIndexPath:indexPath];
            } ]  ;
        }
    }else if (indexPath.section == 4){
//        height = FITSCALE(60);
        if ( self.selectedIndex == 3) {
              height =  85;
        }else{
             height =  65;
        }
    
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =  nil;
    
    if (indexPath.section ==  JFHomeworkTopicType_image) {
        if (indexPath.row == 0) {
            cell = [self confightTitleTableView:tableView withIndexPath:indexPath];
        }else{
             cell = [self confightParseItemContentImageTableView:tableView withIndexPath:indexPath];
        }
      
    }else if (indexPath.section == JFHomeworkTopicType_audios){
        if (indexPath.row == 0) {
            cell = [self confightTitleTableView:tableView withIndexPath:indexPath];
        }else{
            cell = [self confightAudioContent:tableView   withIndexPath:indexPath];
        }
    }else if (indexPath.section == JFHomeworkTopicType_originalAnswer){
        if (indexPath.row == 0) {
             cell = [self confightTitleTableView:tableView withIndexPath:indexPath];
        }else{
            cell =  [self confightAnswerContent:tableView withIndexPath:indexPath];
 
        }
    }else if (indexPath.section == JFHomeworkTopicType_parse){
        if (indexPath.row == 0) {
           cell = [self confightTitleTableView:tableView withIndexPath:indexPath];
        }else if(indexPath.row == 1){
            if ([self validationMyParse]) {
               cell = [self confightPareDesciptionContent:tableView withIndexPath:indexPath ];
            }else{
                cell = [self confightMyPareAddContent:tableView withIndexPath:indexPath];
            }
        }else if (indexPath.row == 2){
            if ([self validationMyParse]) {
                cell = [self confightMyParseMyEditContent:tableView withIndexPath:indexPath];
            }else{
                cell = [self confightOriginalParseContent:tableView withIndexPath:indexPath];
            }
        }else if (indexPath.row == 3){
            cell = [self confightOriginalParseContent:tableView withIndexPath:indexPath];
        }
    }else if (indexPath.section == JFHomeworkTopicType_otherParse){
        cell = [self confightOtherParseContent:tableView withIndexPath:indexPath];
    }
    
 
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == JFHomeworkTopicType_image) {
        NSInteger  index =  indexPath.row -1;
        [self showPhotoBrowser:index withIndexPath: indexPath];
    }else if (indexPath.section == JFHomeworkTopicType_otherParse){
        
        [self gotoOtherParseVC];
    }
}

#pragma mark --- custom validation
//检查是否有音频
- (BOOL)validationIsAudio:(QuestionModel *)model{
    BOOL yesOrNo = NO;
    if (model.continuousAudios && [model.continuousAudios count]) {
        yesOrNo = YES;
    }else{
        if(model.singleAudios && [model.singleAudios count]) {
            yesOrNo = YES;
        }
    }
    return yesOrNo;
}

- (BOOL)validationOranageParse{
    CGFloat yesOrNo =  NO;
    if (self.model.analysis) {
        yesOrNo = YES;
    }
    return yesOrNo;
}
- (BOOL)validationMyParse{
    CGFloat yesOrNo =  NO;
    if (self.model.myAnalysis) {
        yesOrNo = YES;
    }
    return yesOrNo;
}
- (BOOL)validationOtherParse{
    CGFloat yesOrNo =  NO;
    if (self.model.otherAnalysis && [self.model.otherAnalysis count] > 0) {
        yesOrNo = YES;
    }
    return yesOrNo;
}
//- (BOOL) validationMyParseEnd:(NSIndexPath *)indexPath {
//    BOOL yesOrNo = NO;
//    if ([self validationMyParse] &&indexPath.section == 2 && indexPath.row ==2) {
//        yesOrNo = YES;
//    }
//    return yesOrNo;
//}


//- (CGFloat)getParseHeight:(NSIndexPath *)indexPath{
//    CGFloat height = 44;
//    //我的解析存在 时 显示 内容的高
//    if (indexPath.section == 2 &&indexPath.row == 1 ) {
//        if (![self validationMyParse]) {
//            height = FITSCALE(70);
//        }else{
//            height =  [self getParseContentHeight:indexPath];
//        }
//    }else if([self validationMyParseEnd:indexPath]){
//        height = 44;
//    } else{
//
//        height =  [self getParseContentHeight:indexPath];
//    }
//
//    return height;
//}
//-(CGFloat)getParseTitleCellHeight:(NSIndexPath *)indexPath{
//
//    CGFloat height = 44;
//    if (indexPath.section == 1) {
//        if (self.model.analysis) {
//            height = 44;
//        }else{
//            height = 0.00001;
//        }
//    }else{
//        QuestionAnalysisModel * model  = [self getParseModel:indexPath.section];
//        if (indexPath.section == 2 && !model) {
//            height = 44;
//        }else{
//            if (!model) {
//                height = 0.00001;
//            }
//        }
//    }
//
//
//    return height;
//}
//- (CGFloat)getParseContentHeight:(NSIndexPath *)indexPath {
//    CGFloat height =  44;
//    if (indexPath.section == 1) {
////        height = [self.tableView fd_heightForCellWithIdentifier:ChooseParseItemOriginalCellIdentifier  configuration:^(id cell) {
////            [self configureOriginalCell:cell atIndexPath:indexPath];
////        } ]  ;
//    }else{
//        QuestionAnalysisModel * model = [self getParseModel:indexPath.section];
//        if (!model) {
//            height = 0.00001;
//        }else{
////            height =  [self.tableView  cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ChooseParseDescriptionCell class] contentViewWidth:[self cellContentViewWith]];
//        }
//
//    }
//
//    return height;
//}


#pragma mark --- sd  cell 自动适配height
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

#pragma mark -- fd  cell 自动适配 height
//原书解析
- (void)configureOriginalCell:(JFTopicParseItemOriginalCell*)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    [cell setupTextCell:self.model.analysis];
}
//答案
- (void)configureCell:(JFAssistantsAnswerCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    [cell setupTextCell:self.model.answer];
    
}
#pragma mark --- cell congfihg
//图片
- (UITableViewCell *)confightParseItemContentImageTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    
    JFHomeworkTopicImageContentCell * tempCell = [tableView dequeueReusableCellWithIdentifier:JFHomeworkTopicImageContentCellIdentifier];
    CGFloat height =  KCdefaultImageHeight;
    [tempCell setupModel:self.model withImgHeight:height withIndexPath:indexPath.row - 1];
    return tempCell;
}
//标题
- (UITableViewCell *)confightTitleTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
     JFHomeworkTopicContentSectionTitleCell * tempCell = [tableView dequeueReusableCellWithIdentifier:JFHomeworkTopicContentSectionTitleCellIdentifier];
    NSString *iconName = @"";
    NSString *titleName = @"";
    if (indexPath.section == JFHomeworkTopicType_audios) {
        iconName = @"audio_title_parse_icon";
        titleName = @"听力材料";
    }else if (indexPath.section == JFHomeworkTopicType_originalAnswer){
        iconName = @"answer_title_parse_icon";
        titleName = @"原书答案";
    }else if (indexPath.section == JFHomeworkTopicType_parse){
        iconName = @"topic_title_parse_icon";
        titleName = @"试题解析";
    }
    [tempCell setupIcon:iconName withTitle:titleName];
    return tempCell;
}
//音频
- (UITableViewCell *)confightAudioContent:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    
    TeachingAssistantsListBigItemAudioCell * tempCell = [tableView dequeueReusableCellWithIdentifier:JFTeachingAssistantsListBigItemAudioCellIdentifier];
    NSArray * tempArry = [self getAudios];
 
    tempCell.indexPath = indexPath;
    QuestionAnalysisAudioModel * model = tempArry [indexPath.row-1];
    //    if (self.playerCurrentIndex != indexPath.row) {
    //        [tempCell resetVoiceView];
    //    }
    [tempCell setupVoiceDuration:model.playTime];
    
    WEAKSELF
    tempCell.playIndexPathBlock = ^(BOOL playBtnSelected, TeachingAssistantsListBigItemAudioCell *cell, NSIndexPath *cellIndexPath) {
        [weakSelf playOrPauseCell:cell withState:playBtnSelected atIndexPath:cellIndexPath];
    };
    
    return  tempCell;
    
}
//答案
- (UITableViewCell *)confightAnswerContent:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    
   JFAssistantsAnswerCell  * tempCell = [tableView dequeueReusableCellWithIdentifier:JFAssistantsAnswerCellIdentifier];
    [self configureCell:tempCell atIndexPath:indexPath];
    return tempCell;
}
//编辑 解析
- (UITableViewCell *)confightMyParseMyEditContent:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    
    ChooseParseMyEditCell  * tempCell = [tableView dequeueReusableCellWithIdentifier:JFChooseParseMyEditCellIdentifier];
    tempCell.deleteBlock = ^{
        [self askIsDelete];
    };
    tempCell.editBlock = ^{
        [self gotoWrittenParseVC];
    };
    return   tempCell;
}
//添加解析
- (UITableViewCell *)confightMyPareAddContent:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    
    JFTopicAddMyParseCell * tempCell = [tableView dequeueReusableCellWithIdentifier:JFTopicAddMyParseCellIdentifier];
    tempCell.addBlock = ^{
        [self gotoWrittenParseVC];
    };
    return   tempCell;
}
//解析内容
- (UITableViewCell *)confightPareDesciptionContent:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    
    QuestionAnalysisModel * model = self.model.myAnalysis;
    ChooseParseDescriptionCell * tempCell = [tableView dequeueReusableCellWithIdentifier:JFParseDescriptionCellIdentifier];
    BOOL state = NO;
    tempCell.indexPath = indexPath;
    if (self.selectedIndex == 2) {
        state = YES;
    }
    [tempCell setupSelectedState:state];
    tempCell.model = model;
    tempCell.selectedAnalysisBlock = ^(NSIndexPath *indexPath) {
        self.selectedIndex = 2;
        [self updateAssistantListView];
        [self updateTableView];
        
    };
    return   tempCell;
}
//原书解析
- (UITableViewCell *)confightOriginalParseContent:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    
    JFTopicParseItemOriginalCell * tempCell = [tableView dequeueReusableCellWithIdentifier:JFTopicParseItemOriginalCellIdentifier];
    
    [self configureOriginalCell:tempCell atIndexPath:indexPath];
    BOOL state = NO;
    tempCell.indexPath = indexPath;
    if (self.selectedIndex == 1) {
        state = YES;
    }
    [tempCell setupSelectedState:state];
 
    tempCell.selectedAnalysisBlock = ^(NSIndexPath *indexPath) {
        self.selectedIndex = 1;
        [self updatePopTopicListData];
       [self updateTableView];
    };
    return   tempCell;
}

- (UITableViewCell *)confightOtherParseContent:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    
    JFTopicOtherParseCell * tempCell = [tableView dequeueReusableCellWithIdentifier:JFTopicOtherParseCellIdentifier];
    NSInteger count = 0;
    if (!self.model.otherAnalysis) {
        count = 0;
    }else{
        count = [self.model.otherAnalysis count];
    }
    BOOL  show = NO;
    if (self.selectedIndex == 3) {
        show = YES;
    }
    [tempCell  setupOther:count withShowChooseParsing:show];
    return   tempCell;
}



#pragma mark --- delete
//是否删除我的解析
- (void)askIsDelete{
    
    MMPopupItemHandler itemHandler = ^(NSInteger index){
        [self requestDeleteParse];
    };
    NSArray * items = @[MMItemMake(@"否", MMItemTypeHighlight, nil),
                        MMItemMake(@"是", MMItemTypeHighlight, itemHandler)];;
    [self showNormalAlertTitle:@"温馨提示" content:@"是否删除我的解析" items:items block:nil];
}

- (void)requestDeleteParse{
    if (!self.model) {
        return ;
    }
    NSDictionary * dic = @{@"bookId":self.bookId,@"bookType":@"JFBook",@"unitId":self.model.unitId,@"questionNum":self.model.questionNum};
    
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherDeleteQuestAnalysis] parameterDic:dic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherDeleteQuestAnalysis];
    
}


- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_TeacherDeleteQuestAnalysis) {
            strongSelf.model.myAnalysis = nil;
            if ([strongSelf validationOranageParse]) {
                strongSelf.selectedIndex = 1;
                [strongSelf updatePopTopicListData];
            }else{
                strongSelf.selectedIndex = -1;
            }
            [strongSelf updateAssistantListView];
            [strongSelf updateBottomView];
            [strongSelf updateTableView];
           
        }
    }];
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateBottomView{
    
    if (![self validationHasAnalysis]) {
        self.bottomView.hidden = YES;
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }else{
        self.bottomView.hidden = NO;
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height- kBottomHeight);
    }
    
}

- (BOOL)validationHasAnalysis{
    BOOL isAnalysis = YES;
    if (!self.model.myAnalysis) {
        if (!self.model.analysis) {
            if (!self.model.otherAnalysis) {
                isAnalysis = NO;
            }else{
                
                if ([self.model.otherAnalysis count] == 0) {
                    isAnalysis = NO;
                }
            }
        }
        
    }
    
    return isAnalysis;
}

#pragma mark  -- 添加解析
- (void)gotoWrittenParseVC {
    WrittenParseViewController * writtenParseVC = [[WrittenParseViewController alloc]initWithBookId:[self getBookId] withBookName:self.bookName withModel:self.model];
    writtenParseVC.delegate = self;
    [self pushViewController:writtenParseVC];
}
- (NSString *)getBookId{
    return self.bookId;
}
#pragma mark --- play

- (void)playOrPauseCell:(TeachingAssistantsListBigItemAudioCell *)cell withState:(BOOL) playBtnSelected atIndexPath:(NSIndexPath *)cellIndexPath{
    
//    self.playerCurrentIndex = cellIndexPath.row;
    if (playBtnSelected) {
        NSIndexPath * playerIndexPath = [self.playerView getCurrentPlayerIndex];
        //当前点击的播放的语音是上次播放的 且为暂停状态
        if (playerIndexPath && [playerIndexPath compare: cellIndexPath] == NSOrderedSame &&self.playerView.isPauseByUser) {
            //暂停后点击播放
            [self.playerView play];
        }else{
            //开始播放
            NSArray * tempArray = [self getAudios];
            QuestionAnalysisAudioModel * model = tempArray[cellIndexPath.row-1];
            // 取出字典中的第一视频URL
            NSURL *videoURL = [NSURL URLWithString:model.voice];
            ZFPlayerModel *playerModel = nil;
            if (![self.playerView getZFPlayerModel]) {
                playerModel = [[ZFPlayerModel alloc] init];
            }else{
                playerModel = [self.playerView getZFPlayerModel];
            }
            //        playerModel.title            = model.title;
            playerModel.videoURL         =  videoURL;
            //        playerModel.placeholderImageURLString = model.coverForFeed;
            playerModel.scrollView       = self.tableView;
            playerModel.indexPath        = cellIndexPath;
            // 赋值分辨率字典
            //        playerModel.resolutionDic    = dic;
            // player的父视图tag
            playerModel.fatherViewTag    = cell.bgView.tag;
            // 设置播放控制层和model
            [self.playerView playerControlView:[UIView new] playerModel:playerModel playerView:cell];
            // 下载功能
            self.playerView.hasDownload = NO;
            // 自动播放
            [self.playerView autoPlayTheVideo];
            //            NSIndexPath *  path = [self.playerView getCurrentPlayerIndex];
            //            NSLog(@"%@---=",path);
            //更新
            //                [strongSelf updateAudioView];
        }
    }else{
        //暂停
        [self.playerView pause];
    }
}
- (void)updateAudioView{
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}
- (NSArray *)getAudios{
    
    NSArray * tempArry = nil;
    if ( [self.model.singleAudios count] >0) {
        tempArry  = self.model.singleAudios;
    }else if([self.model.continuousAudios count] >0){
        tempArry  = self.model.continuousAudios;
    }
    return tempArry;
}

#pragma mark  播放器
- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        _playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
        
        // 当cell划出屏幕的时候停止播放
        _playerView.stopPlayWhileCellNotVisable = YES;
        ZFPlayerShared.isLockScreen = YES;
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        // 静音
        // _playerView.mute = YES;
    }
    return _playerView;
}
- (void)zf_playerItemStatusFailed:(NSError *)error{
    NSString * content = @"语音播放失败！请稍后再试";
    [self showAlert:TNOperationState_Fail content:content block:nil];
    
}

- (void)zf_playerItemPlayerComplete{
    
       NSLog(@"播放完成");
   
}
#pragma mark  添加解析 delegate
- (void)updateMyParse {
    [self updateAssistantListView];
    [self updateBottomView];
    self.selectedIndex = 2;
    [self updateTableView];
    [self updatePopTopicListData];
}
//替换上一个页面的题目解析
- (void)updatePopTopicListData{
    if ([self.delegate respondsToSelector:@selector(chooseItmeIndex:withParsingIndex:)]) {
        [self.delegate chooseItmeIndex:self.seletedChangePareTopicIndexPath withParsingIndex:self.selectedIndex];
    }
}
- (void)updateAssistantListView{
    if ([self.delegate  respondsToSelector:@selector(updateListData)]) {
        [self.delegate updateListData];
    }
}

#pragma mark ---
- (void)showPhotoBrowser:(NSInteger )index withIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    UIView * sourceContainerView = cell.contentView;
//    SDPhotoBrowser *browserView = [[SDPhotoBrowser alloc] init];
//    browserView.currentImageIndex = index;
//    browserView.sourceImagesContainerView = sourceContainerView;
//    browserView.imageCount = self.model.imgs.count;
//    browserView.delegate = self;
//    [browserView show];
    [self present:index withIndexPath:indexPath];
  
}

- (void)present:(NSInteger )index withIndexPath:(NSIndexPath *)indexPath{
    //这里应该根据你项目中实际情况的点击来处理，我这个方法传过来的值基本都用不上，这里只给出较无脑的处理方式。。。
    NSMutableArray *items = [NSMutableArray array];
    //获取当前可见的cell的indexPath 动画效果需要使用到缩略图。若只需要默认动画效果，这一步可以忽略。请参考下面注释
    NSArray *visibleCells = [self.tableView indexPathsForVisibleRows];
    
    //这里因为每个cell都是相当于图片cell,所以总共的cell就是_layouts的count.如果是实际中，应该判断一下cell中的消息类型
    for (NSInteger i = 0,max = [self.model.imgs count]; i < max; i++) {
        
       
        DSImageScrollItem * item = [[DSImageScrollItem alloc] init];
        item.isVisibleThumbView = NO;
        item.largeImageURL = [NSURL URLWithString:self.model.imgs[i]];
//        item.largeImageSize = CGSizeMake(imageData.largeImage.width, imageData.largeImage.height);
        for (NSIndexPath *indexPath in visibleCells) {
            if ([[self.tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[JFHomeworkTopicImageContentCell class]]) {
                if (indexPath.row == i+1) {
                    JFHomeworkTopicImageContentCell *cell = (JFHomeworkTopicImageContentCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                    
                    UIImageView *thumbnail = cell.subviews.firstObject.subviews.firstObject;
                    item.thumbView = thumbnail;
                    item.isVisibleThumbView = YES;
                }
            }
           
        }
        
        [items addObject:item];
    }
    
    NSInteger currentIndex = index;
    UIView *fromView = ((DSImageScrollItem *)items[currentIndex]).thumbView;
    DSImageShowView *scrollView = [[DSImageShowView alloc] initWithItems:items type:DSImageShowTypeDefault];
    [scrollView presentfromImageView:fromView toContainer:self.navigationController.view index:currentIndex animated:YES completion:nil];
    scrollView.longPressBlock = ^(UIImageView *imageView) {
        //todo
        NSLog(@"长按%ld",currentIndex);
        [self showAlertController:imageView.image];
    };

}
- (void)showAlertController:(UIImage *)image{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否保存图片" message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    WEAKSELF
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf saveImg:image];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:archiveAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)saveImg:(UIImage *)img{
    
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    if (error) {
       NSLog(@"图片保存失败");
    } else {
        NSLog(@"图片保存成功");
    }
  
}
#pragma mark - SDPhotoBrowserDelegate


// 页面消失时候
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playerView resetPlayer];
}
- (void)gotoOtherParseVC{
    JFTopicOtherTeacherParseViewController * otherVC = [[JFTopicOtherTeacherParseViewController alloc]initWithHomework:self.model.unitId withQuestionNum:self.model.questionNum];
    otherVC.seletedChangePareTopicIndexPath = self.seletedChangePareTopicIndexPath;
    [self pushViewController:otherVC];
}
@end
