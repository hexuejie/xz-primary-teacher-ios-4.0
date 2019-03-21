
//
//  HomeworkDetailViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/7/7.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "HomeworkDetailViewController.h"
#import "ReleaseStyleCell.h"
#import "CheckHomeworkDetailImageCell.h"
#import "ReleaseBookworkCell.h"
#import "ReleaseHeaderView.h"
#import "CheckHomeworkDetailModel.h"
#import "CheckHomeworkDetailTextCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ReleaseBookworkCell.h"
#import "PlaybackControlCell.h"
#import "CheckHomeworkDetailBookUnitCell.h"
#import "CheckHomeworkDetailCartoonUnitCell.h"
#import "ZFPlayer.h"
#import "SDAutoLayout.h"
#import "StudentHomeworkSectionHeaderCell.h"
#import "CheckHomeworkDetailBookSectionCell.h"
#import "CheckHomeworkDetailBookUnitSectionCell.h"
#import "CheckHomeworkDetailChapterSectionCell.h"
#import "CheckHomeworkDetailChapterContentCell.h"
#import "CheckHomeworkDetailKHLXUnitCell.h"
#import "CheckHomeworkDetailYWDDUnitCell.h"
#import "JFHomeworkQuestionViewController.h"
#import "HomeworkDetailKHLXListViewController.h"
#import "ProUtils.h"
#import "HomeworkDetailYWDDViewController.h"

typedef NS_ENUM(NSInteger, HomeworkDetailType) {
    HomeworkDetailType_backFeed = 0,//反馈方式
    HomeworkDetailType_date        ,//作业完成时间
    HomeworkDetailType_text        ,//文本
    HomeworkDetailType_image       ,//图片
    HomeworkDetailType_voice       ,//录音
    HomeworkDetailType_books       ,//书本
    
    
};
static NSString *const HomeworkDetailStyleCellIdentifier = @"HomeworkDetailStyleCellIdentifier";
static NSString *const CheckHomeworkDetailImageCellIdentifier = @"CheckHomeworkDetailImageCellIdentifier";
static NSString *const HomeworkDetailBookworkCellIdentifier = @"HomeworkDetailBookworkCellIdentifier";
static NSString *const HomeworkDetailPlaybackControlCellIdentifier = @"HomeworkDetailPlaybackControlCellIdentifier";
static NSString *const HomeworkDetailHeaderViewIdentifier = @"HomeworkDetailHeaderViewIdentifier";
static NSString *const CheckHomeworkDetailTextCellIdentifier = @"CheckHomeworkDetailTextCellIdentifier";

static NSString *const CheckHomeworkDetailBookUnitCellIdentifier = @"CheckHomeworkDetailBookUnitCellIdentifier";
static NSString *const CheckHomeworkDetailCartoonUnitCellIdentifier = @"CheckHomeworkDetailCartoonUnitCellIdentifier";
static NSString *const CheckHomeworkDetailSectionHeaderCellIdentifier = @"CheckHomeworkDetailSectionHeaderCellIdentifier";


static NSString *const CheckHomeworkDetailBookSectionCellIdentifier = @"CheckHomeworkDetailBookSectionCellIdentifier";

static NSString *const CheckHomeworkDetailBookUnitSectionCellIdentifier = @"CheckHomeworkDetailBookUnitSectionCellIdentifier";
static NSString *const CheckHomeworkDetailChapterSectionCellIdentifier = @"CheckHomeworkDetailChapterSectionCellIdentifier";
static NSString *const CheckHomeworkDetailChapterContentCellIdentifier = @"CheckHomeworkDetailChapterContentCellIdentifier";

static NSString *const CheckHomeworkDetailKHLXUnitCellIdentifier = @"CheckHomeworkDetailKHLXUnitCellIdentifier";

static NSString *const CheckHomeworkDetailYWDDUnitCellIdentifier = @"CheckHomeworkDetailYWDDUnitCellIdentifier";
////~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~/
//书本练习展示类型

//书本 信息
NSString *    Detail_BOOKINFO = @"BOOKINFO";

//绘本单元
NSString *    Detail_CartoonUnit = @"CartoonUnit";

//书本在线单元
NSString *    Detail_BookZxlxSection = @"BookZxlxSection";
//书本在线课后练习
NSString *    Detail_BookKHLXSection = @"BookKHLXSection";
//书本离线语文点读
NSString *    Detail_BookYWDDSection = @"BookYWDDSection";
//书本其它单元
NSString *    Detail_BookOtherSection = @"BookOtherSection";

//在线练习单元
NSString *    Detail_zxlxUnit = @"zxlxUnit";
//在线练习章节
NSString *    Detail_zxlxChapter = @"zxlxChapter";
//在线练习单词
NSString *    Detail_wordInfo = @"wordInfo";
//在线练习听写内容
NSString *    Detail_listenAndTalkInfo = @"listenAndTalkInfo";

//课后练习
NSString *    Detail_khlxUnit = @"khlxUnit";

//语文点读

NSString *    Detail_ywddUnit = @"ywddUnit";


//类型
NSString *    Detail_cellTypeKey = @"cellTypeKey";
NSString *      Type_khlx  =  @"khlx"; //课后练习
NSString *      Type_ywdd  =  @"ywdd"; //语文点读
NSString *      Type_zxlx  = @"zxlx"; //游戏练习

////~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~/

@interface HomeworkDetailViewController ()<ZFPlayerDelegate>
@property(nonatomic, copy) NSString * homeworkId;
@property(nonatomic, strong) CheckHomeworkDetailModel * model;
@property(nonatomic, strong)   NSMutableArray*  bookSectionUnits;
@property(nonatomic, strong)   NSDictionary* practiceTypes ;//教材教辅字段类型
@property(nonatomic, strong)   NSDictionary* cartoonTypes  ;//绘本类型字段
@property(nonatomic,strong)    NSDictionary * unityIconDic;//字段对应的图片
@property (nonatomic, strong) ZFPlayerView   *playerView;
@end

@implementation HomeworkDetailViewController
- (instancetype)initWithHomeworkId:(NSString *) homeworkId{
    
    self = [super init];
    if (self) {
        self.homeworkId = homeworkId;
    }
    return self;
}

- (UITableViewStyle)getTableViewStyle{
    
    return UITableViewStyleGrouped;
}

- (NSMutableArray *)bookSectionUnits{
    
    if (!_bookSectionUnits) {
        _bookSectionUnits = [[NSMutableArray alloc]init];
    }
    return _bookSectionUnits;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"作业概况"];
    [self setupData];
    self.view.backgroundColor = project_background_gray;
    self.tableView.backgroundColor = [UIColor clearColor];
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, FITSCALE(50))];
    footerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView =footerView;
    
    
}
- (void)setupData{
    
    self.practiceTypes = [ProUtils getHomworkDetailPracticeTypes];
    
    self.cartoonTypes = [ProUtils getHomworkDetailCartoonTypes];
    
    self.unityIconDic = [ProUtils getHomworkDetailUnitIconDic];
    
}

- (void)registerCell{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CheckHomeworkDetailTextCell class])  bundle:nil] forCellReuseIdentifier:CheckHomeworkDetailTextCellIdentifier];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReleaseStyleCell class])  bundle:nil] forCellReuseIdentifier:HomeworkDetailStyleCellIdentifier];
    //
    
    [self.tableView registerClass:[CheckHomeworkDetailImageCell class] forCellReuseIdentifier:CheckHomeworkDetailImageCellIdentifier ];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReleaseBookworkCell class]) bundle:nil]  forCellReuseIdentifier:HomeworkDetailBookworkCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PlaybackControlCell class]) bundle:nil]  forCellReuseIdentifier:HomeworkDetailPlaybackControlCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReleaseHeaderView  class])  bundle:nil]  forHeaderFooterViewReuseIdentifier:HomeworkDetailHeaderViewIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CheckHomeworkDetailCartoonUnitCell class]) bundle:nil] forCellReuseIdentifier:CheckHomeworkDetailCartoonUnitCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CheckHomeworkDetailBookUnitCell class]) bundle:nil] forCellReuseIdentifier:CheckHomeworkDetailBookUnitCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([StudentHomeworkSectionHeaderCell class]) bundle:nil] forCellReuseIdentifier:CheckHomeworkDetailSectionHeaderCellIdentifier];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CheckHomeworkDetailBookSectionCell class]) bundle:nil] forCellReuseIdentifier:CheckHomeworkDetailBookSectionCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CheckHomeworkDetailBookUnitSectionCell class]) bundle:nil] forCellReuseIdentifier:CheckHomeworkDetailBookUnitSectionCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CheckHomeworkDetailChapterSectionCell class]) bundle:nil] forCellReuseIdentifier:CheckHomeworkDetailChapterSectionCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CheckHomeworkDetailChapterContentCell class]) bundle:nil] forCellReuseIdentifier:CheckHomeworkDetailChapterContentCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CheckHomeworkDetailKHLXUnitCell  class]) bundle:nil] forCellReuseIdentifier:CheckHomeworkDetailKHLXUnitCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CheckHomeworkDetailYWDDUnitCell class]) bundle:nil] forCellReuseIdentifier:CheckHomeworkDetailYWDDUnitCellIdentifier];
    
}
- (void)getNormalTableViewNetworkData{
    
    [self requestHomeworkContent];
}

#pragma mark -----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger section =  0;
    if (self.model) {
        if ([self.bookSectionUnits count] >0) {
            section = 5 +1+ [self.bookSectionUnits count];
        }else{
            section = 5;
        }
    }
    return  section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger row =  1;
    if (section == HomeworkDetailType_backFeed) {
        row = 0;
    }else  if (section == HomeworkDetailType_date) {
        row = 0;
    } else if (section == HomeworkDetailType_voice) {
        row = self.model.sound?1:0;
    }else if (section == HomeworkDetailType_image){
        row = [self.model.photos count] ?1:0;
    }else if(section == HomeworkDetailType_text){
        
        row = self.model.text.length > 0?1:0;
    }else if (section == HomeworkDetailType_books){
        row = 1;
    }else{
        
        NSInteger bookSection = section - 6;
        NSDictionary * sectionInfo = self.bookSectionUnits[bookSection];
        if ([sectionInfo[Detail_cellTypeKey] isEqualToString:Detail_CartoonUnit]) {
            row = 1;
        }else  if ([sectionInfo[Detail_cellTypeKey] isEqualToString:Detail_BookZxlxSection]) {
            NSArray * tempArray =  sectionInfo[@"detail"] ;
            row = 1 + [tempArray count];
        }else if([sectionInfo[Detail_cellTypeKey] isEqualToString:Detail_BookOtherSection]){
            NSArray * tempArray =  sectionInfo[@"detail"] ;
            row = 1 + [tempArray count];
        }else if([sectionInfo[Detail_cellTypeKey] isEqualToString:Detail_BookKHLXSection]){
            NSArray * tempArray =  sectionInfo[@"detail"] ;
            row = 1 + [tempArray count];
        }else if([sectionInfo[Detail_cellTypeKey] isEqualToString:Detail_BookYWDDSection]){
            NSArray * tempArray =  sectionInfo[@"detail"] ;
            row = 1 + [tempArray count];
        }else if ([sectionInfo[Detail_cellTypeKey] isEqualToString:Detail_BOOKINFO]){
            
            row = 1;
        }
        
    }
    return row;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat  height = 44;
    if (indexPath.section == HomeworkDetailType_text) {
        
        CGSize sizeToFit = [self.model.text sizeWithFont:[UIFont systemFontOfSize:16]
                             constrainedToSize:CGSizeMake(kScreenWidth -30.0, CGFLOAT_MAX)
                                 lineBreakMode:NSLineBreakByWordWrapping];
        height = sizeToFit.height + 26;
    }else if (indexPath.section == HomeworkDetailType_image){
        height = [self.model.photos count] ?(ScreenWidth/4):0;
        [ tableView cellHeightForIndexPath:indexPath model:self.model keyPath:@"model" cellClass:[CheckHomeworkDetailImageCell class] contentViewWidth:[self cellContentViewWith]] ;
    }else if(indexPath.section ==  HomeworkDetailType_voice){
        height = FITSCALE(44) ;
    }else if (indexPath.section ==  HomeworkDetailType_books){
        height = 44;
        
    } else if(indexPath.section > HomeworkDetailType_books){
        
        NSInteger section = indexPath.section - 6;
        
        NSDictionary * sectionInfo = self.bookSectionUnits[section];
        
        //书本信息
        if ([sectionInfo[Detail_cellTypeKey] isEqualToString:Detail_BOOKINFO]) {
            height = 144;
        }else {
            //选的类型
            height = [self getBookInfoHeight:sectionInfo withIndexPath:indexPath];
        }
        
    }
    
    return height;
}

- (CGFloat)cellHeightWithMsg:(NSString *)msg
{
    UILabel *label = [[UILabel alloc] init];
    label.text = msg;
    label.font = [UIFont systemFontOfSize:16];
    label.numberOfLines = 0;
    CGSize size = [label sizeThatFits:CGSizeMake(kScreenWidth-45, CGFLOAT_MAX)];
    return size.height;
}
- (CGFloat)getBookInfoHeight:(NSDictionary *)sectionInfo withIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    if ([sectionInfo[Detail_cellTypeKey] isEqualToString:Detail_CartoonUnit]) {
        height = 42;
    }else  if ([sectionInfo[Detail_cellTypeKey] isEqualToString:Detail_BookZxlxSection]) {
        
        if (indexPath.row ==0) {
            height = 32;
        }else {
            NSInteger tempRow = indexPath.row-1;
            NSArray * tempArray =  sectionInfo[@"detail"] ;
            if ([tempArray[tempRow][Detail_cellTypeKey] isEqualToString:Detail_zxlxUnit]) {
                height = 40;
            }else  if ([tempArray[tempRow ][Detail_cellTypeKey] isEqualToString:Detail_zxlxChapter]) {
                height = 29;
            }
//            else  if ([tempArray[tempRow][Detail_cellTypeKey] isEqualToString:Detail_wordInfo]) {
//                height = 29;
//            }else  if ([tempArray[tempRow][Detail_cellTypeKey] isEqualToString:Detail_listenAndTalkInfo]) {
//                height = 29;
//            }
            else {
                height = [self cellHeightWithMsg:tempArray[tempRow][@"content"]] +15;
            }
        }
    }else  if ([sectionInfo[Detail_cellTypeKey] isEqualToString:Detail_BookKHLXSection]){
        if (indexPath.row == 0) {
            height = 32;
        }else{
            height = 40;
        }
        
    }else  if ([sectionInfo[Detail_cellTypeKey] isEqualToString:Detail_BookYWDDSection]){
        if (indexPath.row == 0) {
            height = 32;
        }else{
            height = 40;
        }
        
    }else if([sectionInfo[Detail_cellTypeKey] isEqualToString:Detail_BookOtherSection]){
        if (indexPath.row == 0) {
            height = 32;
        }else{
            height = 40;
        }
    }
    return height;
}
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    if (self.tableView.editing) {
        
        width = width - FITSCALE(20);
    }
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat headerHeight = 0.00000001;
    if(section == HomeworkDetailType_backFeed){
        headerHeight = 44;
    }else if (section == HomeworkDetailType_image) {
        headerHeight = 0.01;//[self.model.photos count]>0 ? 44 :headerHeight;
    }else if ( section == HomeworkDetailType_voice){
        headerHeight = 0.01;
    }else if (section == HomeworkDetailType_books){
        headerHeight =  0.01;
    }else if (section == HomeworkDetailType_books+1){
        headerHeight = 0.01;
        
    } else if (section > HomeworkDetailType_books+1){
        NSInteger tempSection =  section - 6;
        
        NSDictionary * sectionInfo = self.bookSectionUnits[tempSection];
        
        //书本间隔
        if ([sectionInfo[Detail_cellTypeKey] isEqualToString:Detail_BOOKINFO]) {
            
            headerHeight = FITSCALE(8);
        }
        
    }
    
    
    return headerHeight;
}

- ( UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    NSString * headerTitle = @"";
    
    ReleaseHeaderView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HomeworkDetailHeaderViewIdentifier];
    headerView.hidden = YES;
    if (section == HomeworkDetailType_backFeed) {
        headerView.toplineHeight.constant = 0;
        headerView.hidden = NO;
        headerView.moreBookButton.hidden = YES;
        headerView.iconTitleLabel.text = @"";
        headerView.titleLabel.text = @"备注";
        headerView.titleLabel.font = [UIFont systemFontOfSize:14];
        headerView.titleLabel.textColor = HexRGB(0x8A8F99);
        headerView.contentView.backgroundColor = HexRGB(0xF6F6F8);
        headerView.viewBackgrgoud.backgroundColor = HexRGB(0xF6F6F8);
    }
//    if (section == HomeworkDetailType_image) {
//        if ([self.model.photos count] > 0) {
//            headerTitle = [NSString stringWithFormat:@"%zd张图片",self.model.photos.count];
//            headerView.hidden = NO;
//            headerView.titleLabel.hidden = NO;
//            headerView.titleLabel.text = headerTitle;
//
//        }
//        headerView.iconImgV.hidden = YES;
//        headerView.iconTitleLabel.hidden = YES;
//        headerView.iconlineView.hidden = YES;
//        headerView.topLineView.hidden = NO;
//        headerView.moreBookButton.hidden = YES;
//    }else if (section == HomeworkDetailType_voice ){
//        if (self.model.sound.length  >0) {
//            headerTitle =  @"" ;
//            headerView.hidden = NO;
//            headerView.titleLabel.hidden = NO;
//            headerView.titleLabel.text = headerTitle;
//            headerView.moreBookButton.hidden = YES;
//        }
//        headerView.iconImgV.hidden = YES;
//        headerView.iconTitleLabel.hidden = YES;
//        headerView.iconlineView.hidden = YES;
//        headerView.topLineView.hidden = NO;
//    }
    
    return headerView;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footerView = [UIView new];
    return  footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    CGFloat footerHeight =  0.0001;
    if (section == HomeworkDetailType_date){
        
        footerHeight = 0.01;
    }else if (section >= HomeworkDetailType_books+1){
        NSInteger tempSection =  section - 6;
        
        NSDictionary * sectionInfo = self.bookSectionUnits[tempSection];
        
        //书本间隔
        if ([sectionInfo[Detail_cellTypeKey] isEqualToString:Detail_BOOKINFO]) {
            
            footerHeight = 0.01;
        }
        
    }
    
    return footerHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = nil;
    if (indexPath.section <= 1) {
        
        cell = [self confighReleaseStyleCell:tableView indexPath:indexPath];
    }else if(indexPath.section == HomeworkDetailType_text){
        
        cell = [self confighDetailText:tableView withIndexPath:indexPath];
    }else if (indexPath.section == HomeworkDetailType_image){
        
        
        cell =  [self configDetailImage:tableView withIndexPath:indexPath];
    }else if(indexPath.section ==  HomeworkDetailType_voice){
        cell = [self configPlayAudioCell:tableView withIndexPath:indexPath] ;
        
    }else if (indexPath.section == HomeworkDetailType_books){
        cell = [self configSectionHeaderCell:tableView withIndexPath:indexPath];
    } else {
        
        NSInteger section = indexPath.section - 6;
        
        NSDictionary * sectionInfo = self.bookSectionUnits[section];
        
        //书本信息
        if ([sectionInfo[Detail_cellTypeKey] isEqualToString:Detail_BOOKINFO]) {
            cell =  [self configBookworkCell:tableView withSection:section];
            
        }else {
            cell = [self confightTableView:tableView BookUnitSectionSectionInfo:sectionInfo withIndexPath:indexPath];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableViewCell *)confightTableView:(UITableView *)tableView BookUnitSectionSectionInfo:(NSDictionary *)sectionInfo   withIndexPath:(NSIndexPath *)indexPath  {
    UITableViewCell * cell = nil;
    if ([sectionInfo[Detail_cellTypeKey] isEqualToString:Detail_CartoonUnit]) {
        cell = [self configCartoonUnitCell:tableView withSectionInfo:sectionInfo];
        
    }else  if ([sectionInfo[Detail_cellTypeKey] isEqualToString:Detail_BookZxlxSection]) {
        cell = [self confightZxlxTableView:tableView withIndexPath:indexPath withSectionInfo:sectionInfo];
    }else  if ([sectionInfo[Detail_cellTypeKey] isEqualToString:Detail_BookKHLXSection]){
        
        cell = [self confightKHLXTableView:tableView withIndexPath:indexPath withSectionInfo:sectionInfo];
    }else  if ([sectionInfo[Detail_cellTypeKey] isEqualToString:Detail_BookYWDDSection]){
        
        cell = [self confightYWDDTableView:tableView withIndexPath:indexPath withSectionInfo:sectionInfo];
    }
    else if([sectionInfo[Detail_cellTypeKey] isEqualToString:Detail_BookOtherSection]){
        
        NSArray * tempArray =  sectionInfo[@"detail"] ;
        NSDictionary *detailInfo = tempArray[0];
        
        if (indexPath.row == 0) {
            cell =  [self configBookOtherSectionOneCell:tableView withSectionInfo:sectionInfo withDetailInfo:detailInfo];
            
        }else{
            
            cell = [self configBookUnitSectionTwoCell:tableView withDetailInfo:detailInfo];
            
        }
        
    }
    return cell;
}

#pragma mark =在线游戏练习

- (UITableViewCell * )confightZxlxTableView:(UITableView *)tableView withIndexPath:(NSIndexPath * )indexPath withSectionInfo:(NSDictionary *)sectionInfo{
    UITableViewCell * cell = nil;
    if (indexPath.row == 0) {
        cell = [self configBookSectionCell:tableView withSectionInfo:sectionInfo];
    }else{
        
        NSArray * tempArray =  sectionInfo[@"detail"] ;
        NSDictionary *detailInfo = tempArray[indexPath.row - 1];
        if ([detailInfo[Detail_cellTypeKey] isEqualToString:Detail_zxlxUnit]) {
            //在线练习类型  单元标题
            cell = [self configBookUnitSectionCell:tableView withInfo:detailInfo];
        }else  if ([detailInfo[Detail_cellTypeKey] isEqualToString:Detail_zxlxChapter]) {
            //在线练习类型 单元章节
            
            cell = [self configChapterSectionCell:tableView withInfo:detailInfo];
        }else{
            //内容
            
            cell = [self configChapterContentCell:tableView withInfo:detailInfo withArray:tempArray atIndexPath:indexPath];
        }
        
    }
    return cell;
}
#pragma mark =-- 在线 课后练习


- (UITableViewCell * )confightKHLXTableView:(UITableView *)tableView withIndexPath:(NSIndexPath * )indexPath withSectionInfo:(NSDictionary *)sectionInfo{
    UITableViewCell * cell = nil;
    if (indexPath.row == 0) {
        cell = [self configBookSectionCell:tableView withSectionInfo:sectionInfo];
    }else{
        
        NSArray * tempArray =  sectionInfo[@"detail"] ;
        NSDictionary *detailInfo = tempArray[indexPath.row - 1];
        
        if ([detailInfo[Detail_cellTypeKey] isEqualToString:Detail_khlxUnit]) {
            cell = [self configKHLXUnitCell:tableView withDetailInfo:detailInfo withIndexPath: indexPath];
        }
    }
    return cell;
}


#pragma mark =-- 离线 语文点读


- (UITableViewCell * )confightYWDDTableView:(UITableView *)tableView withIndexPath:(NSIndexPath * )indexPath withSectionInfo:(NSDictionary *)sectionInfo{
    UITableViewCell * cell = nil;
    if (indexPath.row == 0) {
        cell = [self configBookSectionCell:tableView withSectionInfo:sectionInfo];
    }else{
        NSArray * tempArray =  sectionInfo[@"detail"] ;
        NSDictionary *detailInfo = tempArray[indexPath.row - 1];
        if ([detailInfo[Detail_cellTypeKey] isEqualToString:Detail_ywddUnit]) {
            cell = [self configYWDDUnitCell:tableView withDetailInfo:detailInfo];
        }
        
    }
    return cell;
}
#pragma mark --

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section > HomeworkDetailType_books) {
        NSInteger section = indexPath.section - 6;
        NSDictionary * sectionInfo = self.bookSectionUnits[section];
        //书本信息
        if ([sectionInfo[Detail_cellTypeKey] isEqualToString:Detail_BOOKINFO]) {
            [self selectedJFBookIndexSection:section];
        }else if ([sectionInfo[Detail_cellTypeKey] isEqualToString:Detail_BookKHLXSection]){
            if (indexPath.row >0) {
                [self gotoKHLXDetailVCAtIndex:indexPath];
            }
        }else if ([sectionInfo[Detail_cellTypeKey] isEqualToString:Detail_BookYWDDSection]){
            if (indexPath.row >0) {
                [self gotoYWDDDetailVCAtIndex:indexPath];
            }
        }
    }
}
//教辅
- (void)selectedJFBookIndexSection:(NSInteger)section{
    
    NSDictionary * dic = self.bookSectionUnits[section];
    //教辅
    if ([dic[@"bookType"] isEqualToString:@"JFBook"]){
        
        NSDictionary * bookHomeworkDic = self.model.bookHomeworks[section];
        NSString *  bookHomeworkId = bookHomeworkDic[@"bookHomeworkId"];
        NSString *  bookId =  bookHomeworkDic[@"bookId"];
        [self gotoAssistantsVCBookId:bookId withBookHomeworkId:bookHomeworkId];
    }
}
#pragma mark ---
- (UITableViewCell *)confighReleaseStyleCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    ReleaseStyleCell * tempCell = [tableView dequeueReusableCellWithIdentifier:HomeworkDetailStyleCellIdentifier ];
    ReleaseStyle style  = 0;
    NSString * detail = @"";
    switch (indexPath.section) {
        case HomeworkDetailType_backFeed:{
            style = ReleaseStyle_ReleaseFeedback;
            
            if ([self.model.feedback isEqualToString:@"none"]) {
                detail =  @"不需要反馈";
            }
            
            if ([self.model.feedback isEqualToString:@"signature"]) {
                detail =  @"签字反馈";
            }
            if ([self.model.feedback isEqualToString:@"sound"]) {
                detail =  @"录音反馈";
            }
            if ([self.model.feedback isEqualToString:@"photo"]) {
                detail =  @"拍照反馈";
            }
            
        }
            break;
        case HomeworkDetailType_date:
            style = ReleaseStyle_ReleaseCompleteDate;
            detail =   self.model.endTime;
            break;
            
        default:
            break;
    }
    [tempCell hiddeArrow];
    tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [tempCell setupReleaseHomeworkStyle:style withDetail:detail];
    return tempCell;
    
}

- (UITableViewCell *)confighDetailText:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    
    CheckHomeworkDetailTextCell * detailTextCell  = [tableView dequeueReusableCellWithIdentifier:CheckHomeworkDetailTextCellIdentifier];
    [self configureCell:detailTextCell atIndexPath:indexPath];
    detailTextCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return detailTextCell;
}

- (UITableViewCell *)configDetailImage:(UITableView *)tableView withIndexPath :(NSIndexPath *)indexPath{
    CheckHomeworkDetailImageCell * tempCell = [tableView dequeueReusableCellWithIdentifier:CheckHomeworkDetailImageCellIdentifier];
    tempCell.model = self.model;
    tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return tempCell;
}
- (UITableViewCell *)configPlayAudioCell:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    
    PlaybackControlCell * tempCell = [tableView dequeueReusableCellWithIdentifier:HomeworkDetailPlaybackControlCellIdentifier ];
    
    tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    tempCell.indexPath = indexPath;
    WEAKSELF
    tempCell.playIndexPathBlock = ^(BOOL playBtnSelected, PlaybackControlCell *cell, NSIndexPath *indexPath) {
        STRONGSELF
        if (playBtnSelected) {
            //当前点击的播放的语音是上次播放的 且为暂停状态
            if ([weakSelf.playerView getCurrentPlayerIndex] && [weakSelf.playerView getCurrentPlayerIndex] == indexPath &&weakSelf.playerView.isPauseByUser) {
                [weakSelf.playerView play];
            }else{
                // 取出字典中的第一视频URL
                NSURL *videoURL = [NSURL URLWithString: strongSelf.model.sound];
                ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
                playerModel.videoURL         =  videoURL;
                playerModel.scrollView       = weakSelf.tableView;
                playerModel.indexPath        = indexPath;
                playerModel.fatherViewTag    = cell.fatherView.tag;
                
                // 设置播放控制层和model
                [strongSelf.playerView playerControlView:nil playerModel:playerModel playerView:cell];
                // 下载功能
                strongSelf.playerView.hasDownload = NO;
                // 自动播放
                [strongSelf.playerView autoPlayTheVideo];
            }
        }else{
            strongSelf.playerView.isPauseByUser = YES;
            [strongSelf.playerView pause];
        }
    };
    return tempCell;
}
- (void)zf_playerItemPlayerComplete{
    ////
    PlaybackControlCell * tempCell = [self.tableView dequeueReusableCellWithIdentifier:HomeworkDetailPlaybackControlCellIdentifier ];
    tempCell.playButton.selected = NO;
    self.playerView.isPauseByUser = NO;
}

- (UITableViewCell *)configSectionHeaderCell:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath{
    
    StudentHomeworkSectionHeaderCell * headerCell = [tableView dequeueReusableCellWithIdentifier:CheckHomeworkDetailSectionHeaderCellIdentifier];

    headerCell.nameLabel.textColor = UIColorFromRGB(0x8A8F99);
    headerCell.nameLabel.font = [UIFont systemFontOfSize:14];
    headerCell.bgView.backgroundColor = HexRGB(0xF6F6F8);
    
    [headerCell setupName:@"书本作业"];
    return headerCell;
}

- (UITableViewCell *)configBookworkCell:(UITableView *)tableView withSection:(NSInteger)section{
    
    ReleaseBookworkCell * tempCell = [tableView dequeueReusableCellWithIdentifier:HomeworkDetailBookworkCellIdentifier];
    [tempCell setuphomeworkBookInfo:self.bookSectionUnits[section]];
    
    [tempCell showHemoworkDetailType];
    return tempCell;
}

- (UITableViewCell *)configCartoonUnitCell:(UITableView *)tableView withSectionInfo:(NSDictionary *)sectionInfo{
    
    CheckHomeworkDetailCartoonUnitCell * tempCell = [tableView dequeueReusableCellWithIdentifier:CheckHomeworkDetailCartoonUnitCellIdentifier];
    
    NSString * title = self.cartoonTypes[sectionInfo[@"title"]];
    NSString * imageName = self.unityIconDic [sectionInfo[@"title"]];
    [tempCell setupTitle:title withImageName:imageName ];
    return tempCell;
}

- (UITableViewCell *)configBookSectionCell:(UITableView *)tableView withSectionInfo:(NSDictionary *)sectionInfo{
    
    CheckHomeworkDetailBookSectionCell *  tempCell = [tableView dequeueReusableCellWithIdentifier:CheckHomeworkDetailBookSectionCellIdentifier];
    
    NSString * title = self.practiceTypes[sectionInfo[@"title"]];
    NSString * imageName = self.unityIconDic [sectionInfo[@"title"]];
    NSString * detail = @"";
    for (NSDictionary * dic in sectionInfo[@"detail"]) {
        if (detail.length == 0) {
            detail =  dic[@"typeCn"];
        }else{
            detail = [detail stringByAppendingFormat:@",%@",dic[@"typeCn"]];
        }
        
    }
    NSString * number = @"";
    NSString * count = @"";
    if ([sectionInfo[@"title"] isEqualToString:Type_zxlx]) {
        NSArray * tempArray =  sectionInfo[@"detail"] ;
        NSInteger countNumber = 0;
        for (NSDictionary * dic in tempArray) {
            NSString * count = dic[@"count"];
            countNumber =  countNumber+[count integerValue];
        }
        number = [NSString stringWithFormat:@"个练习"];
        count = [NSString stringWithFormat:@"%zd",countNumber];
    }else if ([sectionInfo[@"title"] isEqualToString:Type_khlx]){
        NSArray * tempArray =  sectionInfo[@"detail"] ;
        NSInteger countNumber = 0;
        countNumber = [tempArray count];
        
        number = [NSString stringWithFormat:@"个练习"];
        count = [NSString stringWithFormat:@"%zd",countNumber];
    }
    [tempCell setupTitle:title withImageName:imageName withCount:count withNumber:number];
    
    return tempCell;
}

- (UITableViewCell *)configBookUnitSectionCell:(UITableView *)tableView withInfo:(NSDictionary *)info{
    CheckHomeworkDetailBookUnitSectionCell *  tempCell = [tableView dequeueReusableCellWithIdentifier:CheckHomeworkDetailBookUnitSectionCellIdentifier];
    [tempCell setupUnitTitle:info[@"title"]];
    return tempCell;
    
}


- (UITableViewCell *)configChapterSectionCell:(UITableView *)tableView  withInfo:(NSDictionary *)detailInfo{
    CheckHomeworkDetailChapterSectionCell *  tempCell = [tableView dequeueReusableCellWithIdentifier:CheckHomeworkDetailChapterSectionCellIdentifier];
    
    [tempCell setupUnitTitle:detailInfo[@"title"]];
    return tempCell;
}

- (UITableViewCell *)configChapterContentCell:(UITableView *)tableView withInfo:(NSDictionary *)detailInfo  withArray:(NSArray *)tempArray atIndexPath:(NSIndexPath *)indexPath{
    CheckHomeworkDetailChapterContentCell *  tempCell = [tableView dequeueReusableCellWithIdentifier:CheckHomeworkDetailChapterContentCellIdentifier];
    [tempCell setupContent:detailInfo[@"content"]];
    if (indexPath.row   == [tempArray count]  ) {
        [tempCell setupHiddenLine];
    }
    return tempCell;
}


- (UITableViewCell *)configBookOtherSectionOneCell:(UITableView *)tableView withSectionInfo:(NSDictionary *)sectionInfo withDetailInfo:(NSDictionary *)detailInfo {
    
    CheckHomeworkDetailBookSectionCell *  tempCell = [tableView dequeueReusableCellWithIdentifier:CheckHomeworkDetailBookSectionCellIdentifier];
    NSString * title = self.practiceTypes[sectionInfo[@"title"]];
    NSString * imageName = self.unityIconDic [sectionInfo[@"title"]];
    
    
    NSString * detail = @"";
    for (NSDictionary * dic in sectionInfo[@"detail"]) {
        if (detail.length == 0) {
            detail =  dic[@"typeCn"];
        }else{
            detail = [detail stringByAppendingFormat:@",%@",dic[@"typeCn"]];
        }
        
    }
    
    NSString * number = @"";
    NSString * countNumber = @"";
    if ([sectionInfo[@"title"] isEqualToString:@"ldkw"]) {
        number = [NSString stringWithFormat:@"遍"];
        countNumber = [NSString stringWithFormat:@"%@",detailInfo[@"count"]];
        
    }else if ([sectionInfo[@"title"] isEqualToString:@"tkwly"]) {
        number = [NSString stringWithFormat:@"遍"];
        countNumber = [NSString stringWithFormat:@"%@",detailInfo[@"count"]];
    }   else if ([sectionInfo[@"title"] isEqualToString:@"dctx"]) {
        NSString * count = @"0";
        if (detailInfo[@"wordCount"]) {
            count = detailInfo[@"wordCount"];
        }
        number = [NSString stringWithFormat:@"个词"];
        countNumber = [NSString stringWithFormat:@"%@",count];
    }
    
    [tempCell setupTitle:title withImageName:imageName withCount:countNumber withNumber:number];
    return  tempCell;
}

- (UITableViewCell *)configBookUnitSectionTwoCell:(UITableView *)tableView withDetailInfo:(NSDictionary *) detailInfo{
    
    CheckHomeworkDetailBookUnitSectionCell *  tempCell = [tableView dequeueReusableCellWithIdentifier:CheckHomeworkDetailBookUnitSectionCellIdentifier];
    [tempCell setupUnitTitle:detailInfo[@"unitName"]];
    return tempCell;
}

- (UITableViewCell *)configKHLXUnitCell:(UITableView *)tableView withDetailInfo:(NSDictionary *) detailInfo withIndexPath:(NSIndexPath * )indexPath{
    CheckHomeworkDetailKHLXUnitCell *  tempCell = [tableView dequeueReusableCellWithIdentifier:CheckHomeworkDetailKHLXUnitCellIdentifier];
    [tempCell setupTitle:detailInfo[@"title"]];
    tempCell.indexPath = indexPath;
    tempCell.detailBlock = ^(NSIndexPath *indexPath) {
        [self gotoKHLXDetailVCAtIndex:indexPath];
    };
    return tempCell;
}

- (UITableViewCell *)configYWDDUnitCell:(UITableView *)tableView withDetailInfo:(NSDictionary *) detailInfo{
    CheckHomeworkDetailYWDDUnitCell*  tempCell = [tableView dequeueReusableCellWithIdentifier:CheckHomeworkDetailYWDDUnitCellIdentifier];
    NSInteger segmentNumber = [detailInfo[@"segmentNumber"] integerValue];
    [tempCell setupTitle:detailInfo[@"title"]  withNumber:segmentNumber];
    
    return tempCell;
}
#pragma mark ---
//- (void)confighBookCell:(CheckHomeworkDetailBookUnitCell *)cell indexPath:(NSIndexPath *)indexPath{
//
//    cell.fd_enforceFrameLayout = NO;
//    NSInteger section = indexPath.section - 5;
//    NSArray * sectionArray = self.bookSectionUnits[section];
//    NSDictionary * detailDic    = sectionArray.firstObject;
//    NSString * title = self.practiceTypes[detailDic[@"title"]];
//    NSString * imageName = self.unityIconDic [detailDic[@"title"]];
//
//    NSString * content = detailDic[@"detail"][0][@"unitName"];
//    NSString * detail = @"";
//    for (NSDictionary * dic in detailDic[@"detail"]) {
//        if (detail.length == 0) {
//             detail =  dic[@"typeCn"];
//        }else{
//             detail = [detail stringByAppendingFormat:@",%@",dic[@"typeCn"]];
//        }
//
//    }
//
//
//    NSString * number = @"";
//    if ([detailDic[@"title"] isEqualToString:@"zxlx"]) {
//        number = [NSString stringWithFormat:@"%zd个练习",[detailDic[@"detail"] count]];
//    }else if ([detailDic[@"title"] isEqualToString:@"ldkw"]) {
//        number = [NSString stringWithFormat:@"%@遍",detailDic[@"detail"][0][@"count"]];
//    }else if ([detailDic[@"title"] isEqualToString:@"tkwly"]) {
//        number = [NSString stringWithFormat:@"%@遍",detailDic[@"detail"][0][@"count"]];
//    }   else if ([detailDic[@"title"] isEqualToString:@"dctx"]) {
//        NSString * count = @"0";
//        if (detailDic[@"detail"][0][@"count"]) {
//            count = detailDic[@"detail"][0][@"count"];
//        }
//        number = [NSString stringWithFormat:@"%@遍",count];
//    }
//
//    [cell setupTitle:title withImageName:imageName  withContent:content withDetail:detail withNumber:number];
//}
- (void)configureCell:(CheckHomeworkDetailTextCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    [cell setupTextCell:self.model.text];
    
}


#pragma mark  ---网络请求
- (void)requestHomeworkContent{
    
    NSDictionary* parameterDic = @{@"homeworkId":self.homeworkId};
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_QueryHomeworkContent] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_QueryHomeworkContent];
}

- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_QueryHomeworkContent) {
            strongSelf.model = [[CheckHomeworkDetailModel alloc]initWithDictionary:successInfoObj error:nil];
            
            [strongSelf resetHomeworkDetailData];
        }
    }];
}





- (void)resetHomeworkDetailData{
    
    
    if (self.bookSectionUnits) {
        [self.bookSectionUnits removeAllObjects];
    }
    
    for (NSDictionary * dic in self.model.bookHomeworks) {
        
        //存储书本信息 是一个字典类型
        
        
        //存书本 教材 绘本 信息
        NSMutableDictionary * bookMutableDic = [[NSMutableDictionary alloc]init];
        
        [bookMutableDic addEntriesFromDictionary:@{@"bookName":dic[@"bookName"],
                                                   @"coverImage":dic[@"coverImage"]
                                                   }];
        if ( dic[@"bookType"] ) {
            [bookMutableDic addEntriesFromDictionary:@{@"bookType":  dic[@"bookType"]}];
        }
        if ( dic[@"bookTypeName"]) {
            [bookMutableDic addEntriesFromDictionary:@{@"bookTypeName": dic[@"bookTypeName"]}];
        }
        if (dic[@"workTotal"]) {
            
            [bookMutableDic addEntriesFromDictionary:@{@"workTotal":dic[@"workTotal"]}];
        }
        if (dic[@"subject"]) {
            [bookMutableDic addEntriesFromDictionary:@{@"subject":dic[@"subject"]}];
            
        }
        if (dic[@"subjectName"]) {
            [bookMutableDic addEntriesFromDictionary:@{@"subjectName":dic[@"subjectName"]}];
        }
        
        [bookMutableDic setObject: Detail_BOOKINFO forKey: Detail_cellTypeKey];
        
        
        [self.bookSectionUnits addObject:bookMutableDic];
        
        
        //找出绘本单元
        if ([dic[@"bookType"] isEqualToString:@"CartoonNew"]) {
            NSArray * cartoonHomework = dic[@"cartoonHomework"];
            for (NSDictionary * tempDic in cartoonHomework) {
                NSString * key = tempDic[@"type"];
                NSDictionary * fistObject =  @{@"title":key,
                                               
                                               @"bookType":@"Cartoon",
                                               Detail_cellTypeKey: Detail_CartoonUnit
                                               };
                //存储绘本单元信息
                [self.bookSectionUnits addObject:fistObject];
                
            }
            
        }else if ([dic[@"bookType"] isEqualToString:@"Book"]){
            [self configureBookInfo:dic];
        }
        
    }
    
    [self updateTableView];
    NSLog(@"%@===",self.bookSectionUnits);
}
- (void)configureBookInfo:(NSDictionary *)bookInfo{
    
    //找出教辅单元
    for (NSString * key in bookInfo) {
        //教材
        if ([self.practiceTypes.allKeys containsObject:key]) {
            //在线练习
            if ([key isEqualToString:Type_zxlx]) {
                
                /**
                 把布置的书本作业 用一个数组 包装一下 用于区分 书本 和作业单元项
                 **/
                [self configuraZXLX:bookInfo withKey:key];
            }
            //课后练习
            else if ([key isEqualToString:Type_khlx]){
                [self configuraKHLX:bookInfo withKey:key];
            }
            //语文点读
            else if ([key isEqualToString:Type_ywdd]){
                [self configuraYWDD:bookInfo withKey:key];
            }
            
            else{
                //其它类型作业只显示书本 数据 不展示详情
                NSDictionary * fistObject =  @{@"title":key,
                                               @"detail": bookInfo[key],
                                               @"bookType":@"Book",
                                               Detail_cellTypeKey: Detail_BookOtherSection
                                               };
                [self.bookSectionUnits addObject:fistObject];
                
                /**
                 把布置的书本作业 用一个数组 包装一下 用于区分 书本 和作业单元项
                 **/
            }
            
        }
        
    }
}
#pragma mark ------在线课后练习
- (void)configuraKHLX:(NSDictionary *)bookInfo withKey:(NSString *)key{
    
    NSArray * array = bookInfo[key];
    NSMutableArray * zxkxArray = [[NSMutableArray alloc]init];
    for (NSDictionary *zxlxDic in array) {
        
        //单元标题
        NSString * unitName = zxlxDic[@"unitName"];
        NSString * unitId = zxlxDic[@"unitId"];
        NSArray * questions = zxlxDic[@"questions"];
        
        NSNumber * expectTime = @(0);
        if ( zxlxDic[@"expectTime"]) {
            expectTime = zxlxDic[@"expectTime"];
        }
        NSMutableDictionary * tempDic = [NSMutableDictionary dictionary];
        
        [tempDic addEntriesFromDictionary:@{@"title":unitName,
                                            Detail_cellTypeKey: Detail_khlxUnit,
                                            @"unitId":unitId,
                                            @"expectTime":expectTime,
                                            @"questions":questions}];
        if (zxlxDic[@"finishStudentCount"]) {
            NSNumber * finishStudentCount = zxlxDic[@"finishStudentCount"];
            [tempDic addEntriesFromDictionary:@{ @"finishStudentCount":finishStudentCount}];
        }
        if (zxlxDic[@"homeworkStudents"]) {
            NSArray * homeworkStudents = zxlxDic[@"homeworkStudents"];
            [tempDic addEntriesFromDictionary:@{ @"homeworkStudents":homeworkStudents}];
        }
        [zxkxArray addObject:tempDic];
        //        //存单元标题
        //        [zxkxArray addObject:@{@"title":unitName,
        //                               Detail_cellTypeKey: Detail_khlxUnit,
        //                               @"unitId":unitId,
        //                               @"questions":questions,
        //                               @"finishStudentCount":finishStudentCount,
        //                               @"homeworkStudents":homeworkStudents
        //                               }];
        
    }
    NSDictionary * fistObject =  @{@"title":key,
                                   @"detail":zxkxArray,
                                   @"bookType":@"Book",
                                   Detail_cellTypeKey: Detail_BookKHLXSection
                                   };
    [self.bookSectionUnits addObject:fistObject];
}

#pragma mark ------ 离线语文点读
- (void)configuraYWDD:(NSDictionary *)bookInfo withKey:(NSString *)key{
    
    NSArray * array = bookInfo[key];
    NSDictionary *zxlxDic = array.firstObject;
    
    NSMutableArray * zxkxArray = [[NSMutableArray alloc]init];
    NSString * unitId = zxlxDic[@"unitId"];
    //单元标题
    NSString * unitName = zxlxDic[@"unitName"];
    //单元 选择的段数
    NSString *segmentNumber = [NSString stringWithFormat:@"%ld",[zxlxDic[@"sections"] count]];
    //存单元标题
    [zxkxArray addObject:@{@"title":unitName,
                           Detail_cellTypeKey: Detail_ywddUnit,
                           @"unitId":unitId,
                           @"segmentNumber":segmentNumber
                           }];
    NSMutableArray * sections =[NSMutableArray array];
    for (NSDictionary * dic in  zxlxDic[@"sections"]) {
        if(dic[@"id"]){
            [sections addObject:dic[@"id"]];
        }
    }
    NSDictionary * fistObject =  @{@"title":key,
                                   @"detail":zxkxArray,
                                   @"sections":sections,
                                   @"bookType":@"Book",
                                   Detail_cellTypeKey: Detail_BookYWDDSection
                                   };
    [self.bookSectionUnits addObject:fistObject];
    
}
#pragma mark ------在线游戏练习作业

- (void)configuraZXLX:(NSDictionary *)bookInfo withKey:(NSString *)key{
    
    NSArray * array = bookInfo[key];
    NSDictionary *zxlxDic = array.firstObject;
    
    NSMutableArray * zxkxArray = [[NSMutableArray alloc]init];
    //单元标题
    NSString * unitName = zxlxDic[@"unitName"];
    //存单元标题
    [zxkxArray addObject:@{@"title":unitName,
                           Detail_cellTypeKey: Detail_zxlxUnit
                           }];
    //单词
    [self confightWords:zxlxDic withArray:zxkxArray];
    //听写
    [self confightListenAndTalk:zxlxDic withArray:zxkxArray];
    NSDictionary * fistObject =  @{@"title":key,
                                   @"detail":zxkxArray,
                                   @"bookType":@"Book",
                                   Detail_cellTypeKey: Detail_BookZxlxSection
                                   };
    [self.bookSectionUnits addObject:fistObject];
    
}
//单词
- (void)confightWords:(NSDictionary *)zxlxDic withArray:(NSMutableArray *)zxkxArray{
    
    //单词
    for (NSDictionary * tempDic in zxlxDic[@"words"]) {
        
        //章节名
        NSString * chapterName = tempDic[@"sectionName"];
        [zxkxArray addObject:@{@"title":chapterName,
                               Detail_cellTypeKey: Detail_zxlxChapter}];
        
        
        NSArray * sectionWords = tempDic[@"appType"];
        
        
        NSMutableDictionary * mutableDic = [[NSMutableDictionary alloc]init];
        NSString * typeCNStr = @"";
        for (NSDictionary * tempDic in sectionWords) {
            if (typeCNStr.length == 0 ) {
                typeCNStr =  tempDic[@"typeCn"];
            }else{
                
                typeCNStr = [typeCNStr stringByAppendingString:[NSString stringWithFormat:@"  %@",tempDic[@"typeCn"]]];
            }
            
        }
        [mutableDic addEntriesFromDictionary:@{@"content":typeCNStr,@"count":@([sectionWords count])}];
        [mutableDic addEntriesFromDictionary:@{ Detail_cellTypeKey: Detail_wordInfo}];
        
        [zxkxArray addObject:mutableDic];
    }
    
}
//听写
- (void)confightListenAndTalk:(NSDictionary *)zxlxDic withArray:(NSMutableArray *)zxkxArray{
    
    //听写
    for (NSDictionary * tempDic in zxlxDic[@"listenAndTalk"]) {
        
        //章节名
        NSString * chapterName = tempDic[@"sectionName"];
        [zxkxArray addObject:@{@"title":chapterName,
                               Detail_cellTypeKey: Detail_zxlxChapter}];
        
        NSArray * sectionListens = tempDic[@"appType"];
        
        
        NSMutableDictionary * mutableDic = [[NSMutableDictionary alloc]init];
        NSString * typeCNStr = @"";
        for (NSDictionary * tempDic in sectionListens) {
            if (typeCNStr.length == 0 ) {
                typeCNStr =  tempDic[@"typeCn"];
            }else{
                
                typeCNStr = [typeCNStr stringByAppendingString:[NSString stringWithFormat:@"  %@",tempDic[@"typeCn"]]];
            }
        }
        [mutableDic addEntriesFromDictionary:@{@"content":typeCNStr,@"count":@([sectionListens count])}];
        [mutableDic addEntriesFromDictionary:@{ Detail_cellTypeKey: Detail_listenAndTalkInfo}];
        [zxkxArray addObject:mutableDic ];
        
    }
}

#pragma mark -----
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        _playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
        ZFPlayerShared.isLockScreen = YES;
    }
    return _playerView;
}



// 页面消失时候
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playerView resetPlayer];
    
    [self navUIBarBackground:8];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self navUIBarBackground:0];
}


- (void)zf_playerItemStatusFailed:(NSError *)error{
    NSString * content = @"语音播放失败！请稍后再试";
    [self showAlert:TNOperationState_Fail content:content block:nil];
    
}


- (void)gotoAssistantsVCBookId:(NSString *)bookId withBookHomeworkId:(NSString *)bookHomeworkId{
    
    
    JFHomeworkQuestionViewController * questionVC = [[JFHomeworkQuestionViewController alloc]initWithHomeworkId:self.homeworkId withBookId:bookId withBookHomeworkId:bookHomeworkId];
    [self pushViewController:questionVC];
}

- (void)gotoKHLXDetailVCAtIndex:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section - (HomeworkDetailType_books+1);
    NSDictionary* sectionInfo= self.bookSectionUnits[section];
    NSArray * tempArray =  sectionInfo[@"detail"] ;
    NSDictionary * unitDic = [tempArray objectAtIndex:indexPath.row -1];
    //     NSString * unitId = unitDic[@"unitId"];
    NSString * unitName = unitDic[@"title"];
    NSArray * questions =  unitDic[@"questions"];
    NSNumber * finishStudentCount = unitDic[@"finishStudentCount"];
    NSArray  *homeworkStudents  = unitDic[@"homeworkStudents"];
    NSNumber * expectTime = unitDic[@"expectTime"];
    HomeworkDetailKHLXListViewController * khlxListVC = [[HomeworkDetailKHLXListViewController alloc]initWithUnitName:unitName withQuestions:questions withFinishStudentCount:finishStudentCount withHomeworkStudents:homeworkStudents withExpectTime: expectTime];
    [self pushViewController:khlxListVC];
}

- (void)gotoYWDDDetailVCAtIndex:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section - (HomeworkDetailType_books+1);
    NSDictionary* sectionInfo= self.bookSectionUnits[section];
    NSArray * tempArray =  sectionInfo[@"detail"] ;
    NSDictionary * unitDic = [tempArray objectAtIndex:indexPath.row -1];
    NSString * unitId = unitDic[@"unitId"];
    
    NSArray *cacheData = nil;
    if ([sectionInfo[@"sections"] count] > 0) {
        NSDictionary *sectionDic = @{@"sections":sectionInfo[@"sections"]};
        cacheData = @[sectionDic];
    }
    
    HomeworkDetailYWDDViewController * detailVC =[[HomeworkDetailYWDDViewController alloc]initWithBookId:@"" withUnitId:unitId withBookName:@"语文点读" withBookInfo:nil withCacheData:cacheData];
    [self pushViewController:detailVC];
}
@end

