//
//  ReleaseHomeworkViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/13.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//发布家庭作业

#import "ReleaseHomeworkViewController.h"
#import "TZImagePickerController.h"
#import "FeedbackViewController.h"
#import "FeedbackModel.h"
#import "ReleaseStyleCell.h"
#import "ReleaseHWWebViewController.h"
#import "RecordingView.h"
#import "ReleaseCopyEditorViewCell.h"
#import "ReleaseEditContentFooterView.h"
#import "ReleaseEditMattersCell.h"
#import "AddReleaseEditMattersCell.h"
#import "ReleaseImageCell.h"
#import "ReleaseAddBookworkCell.h"
#import "ReleaseBookworkCell.h"
#import "ReleaseVoiceworkCell.h"
#import "ReleaseHeaderView.h"
#import "SessionHelper.h"
#import "SessionModel.h"
#import "UploadFileModel.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ChooseClassViewController.h"
#import "ClassManageModel.h"
#import "lame.h"
#import "ProUtils.h"
#import "GTMBase64.h"
#import "IQKeyboardManager.h"
#import "XJRepositoryTipsView.h"
#import "BookcaseViewController.h"
#import "ReleaseDeleteBookTipView.h"
#import "ReleaseHomeworkTimeViewMask.h"
#import "BookHomeworkViewController.h"
#import "ProUtils.h"
#import "CheckDetialTipsView.h"

@interface ReleaseHomeworkViewController ()<TZImagePickerControllerDelegate,ReleaseEditMattersDelegate,ChooseClassViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic, assign) NSInteger selectedFeedbackIndex;

@property(nonatomic, strong) FeedbackModel *selectedFeedbackModel;//反馈数据
@property(nonatomic, strong) NSString  *CompletionTime;
@property(nonatomic, assign) BOOL  isCompletionTime;

@property(nonatomic, assign) CGFloat  itemWH;
@property(nonatomic, assign) CGFloat  margin;

@property(nonatomic, assign) CGFloat  formerHeight;
@property(nonatomic, assign) BOOL  isTextView;//事项 和文本切换 YES 表示当前是文本， NO 表示显示事项
@property(nonatomic, assign) ReleaseEditContentFooterViewType chooseButtonType;//选中的发布编辑内容


@property(nonatomic, strong) NSMutableArray *selectedBooks;//书本数据
@property(nonatomic, strong) NSIndexPath *selectedBookIndex;//删除哪本书的标记
@property (nonatomic, strong) NSMutableArray *mattersCellHeights;//事项高度

@property (nonatomic, copy) NSString *subjects;//没有选择书本时选择的科目
@property (nonatomic, copy) NSString *bookSubjectName;//书本的科目
@property (nonatomic, strong) NSDictionary * addBookDic;
@property (nonatomic, strong) ReleaseDeleteBookTipView *deleteBookTipView;


///////
@property (nonatomic, strong) NSArray * classArray;//班级数据
@property (nonatomic, strong) NSString * className;

@property (nonatomic, strong) UIButton * releaseBtn;

@property (nonatomic, strong) ReleaseHomeworkTimeViewMask *timeViewMask;

@property (nonatomic, strong) AddReleaseEditMattersCell  * addCell;
@property (nonatomic, strong) CheckDetialTipsView *checkTipView;
@end

@implementation ReleaseHomeworkViewController

- (instancetype)initWithData:(NSDictionary *)userInfo{
    self = [super init];
    if (self) {
        self.addBookDic = userInfo;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationItemTitle:@"布置作业"];
    self.CompletionTime = @"选择截止时间";
    self.isCompletionTime = YES;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = project_background_gray;

    self.tableView.allowsSelectionDuringEditing = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self initData];
    [self registerCell];
    [self setupNavigationRightbar];
    self.tableView.separatorColor = [UIColor clearColor];
    self.contentType = @"00";
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addHomework:) name:BOOK_HOMEWORK_ADD_NEW object:nil];
    
    if (self.addBookDic) {
        NSString * content = self.addBookDic[@"content"];
        if (!self.bookSubjectName) {
            NSDictionary * json = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
            self.bookSubjectName = json[@"subjectName"];
        }
        [self.selectedBooks addObject:content];
        [self updateTableView];
    }
    _deleteBookTipView = [[[NSBundle mainBundle] loadNibNamed:@"ReleaseDeleteBookTipView" owner:nil options:nil] lastObject];
    [self.tableView addSubview:_deleteBookTipView];
    _deleteBookTipView.hidden = YES;
    
}


- (void) setupNavigationRightbar{
    _releaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_releaseBtn setTitle:@"发布" forState:UIControlStateNormal];
    
    [_releaseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_releaseBtn setTitleColor:UIColorFromRGB(0xB3B3B3) forState:UIControlStateNormal];//才能发布
    [_releaseBtn addTarget:self action:@selector(releaseAction:) forControlEvents:UIControlEventTouchUpInside];
    [_releaseBtn setFrame:CGRectMake(0, 5, 40,60)];
    _releaseBtn.titleLabel.font = systemFontSize(16);
  
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc]initWithCustomView:_releaseBtn];
    self.navigationItem.rightBarButtonItem = rightBar;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self updatePostState];
    [self navUIBarBackground:0];
}

- (void)updatePostState{//检查是否满足发布调节
    if (self.classArray.count>0 && self.selectedFeedbackModel) {
        if ([self.inputContentArrays count] > 0 || self.uplaodAudioModel || self.uplaodImageModel||[self.selectedBooks count] >0
            ) {
            [_releaseBtn setTitleColor:UIColorFromRGB(0x4D4D4D) forState:UIControlStateNormal];
        }
    }
}

- (NSString *)getTodayDate{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd 23:59"];
    NSDate* date = [NSDate date];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
    
}

- (UITableViewStyle )getTableViewStyle{
    return UITableViewStyleGrouped;
}

- (void)initData{
    
    [[NSUserDefaults standardUserDefaults]  removeObjectForKey:SAVE_RELEASEHOMEWORKCLASS];
    self.selectedFeedbackIndex = -1;
    self.inputContentArrays = [NSMutableArray array];
    self.selectedVoice =  [NSMutableArray array];
    self.selectedBooks = [NSMutableArray array];
    self.isTextView = YES;
    self.chooseButtonType = ReleaseEditContentFooterViewType_textViewButton;
    self.mattersCellHeights = [NSMutableArray array];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger row ;
    if (section ==  ReleaseHomeworkSectionType_complete) {
        row = 3 ;
    }else if (section ==  ReleaseHomeworkSectionType_contentTab){
        if (self.isTextView) {
            row = 1;
        }else{
            row = [self.inputContentArrays count] + ([self.inputContentArrays count]>0?1:2);
        }
    }else if(section ==  ReleaseHomeworkSectionType_images){
        
        row = 1;
    }else if(section ==  ReleaseHomeworkSectionType_voice){
        
        row = [self.selectedVoice count];
    }else if(section ==  ReleaseHomeworkSectionType_books){
        row = [self.selectedBooks count]+1;
    }else
        row = 0;
    return row;
    
}

#pragma mark cellHeight
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height =   48;
    if (indexPath.section == ReleaseHomeworkSectionType_complete) {
        return 48;
    }
    _formerHeight = 0;
    if (indexPath.section == ReleaseHomeworkSectionType_contentTab) {
        if (self.isTextView) {
            height =   140;
        }else
        {
            if ([self.mattersCellHeights count] < indexPath.row+1) {
                height = 104;
            }else
            if([self.mattersCellHeights count] >= indexPath.row+1){
                                height  = MAX(itemHeight,[self.mattersCellHeights[indexPath.row] floatValue]);
            }else{
                height = 104;
//                if (_formerHeight < 105) {
//
//                }else{
//                    height = 40;
//                }
//
            }
            
        }
        
    }else if (indexPath.section == ReleaseHomeworkSectionType_images){
        self.margin = 4;
//        NSInteger tepColumn = 4;
        self.itemWH = ((IPHONE_WIDTH -20)/3);
        NSInteger countPhoto = [self.selectedPhotos count];
        if (countPhoto != 9&&countPhoto!=0) {
            countPhoto = countPhoto+1;
        }
#warning 待优化
        if(countPhoto ==0){
            height = 0;
        } else if (countPhoto>0 &&countPhoto <4 ) {
            height = self.itemWH +20 +8;
        }else if (countPhoto >=4 &&countPhoto<7){
            height = (self.itemWH +10)* 2 +8;
        }else if(countPhoto >=7){
            height = (self.itemWH + 10) * 3 +8;
        }else{
            height = 0;
        }
        
    }else if(indexPath.section ==  ReleaseHomeworkSectionType_voice){
        height =  48;
    }else if (indexPath.section == ReleaseHomeworkSectionType_books){
        if ([self.selectedBooks count] == indexPath.row) {
            if([self.selectedBooks count]>0){
                height = 0.01;
            }
            height = 88;
        }else{
            height = 138;
        }
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    UITableViewCell * cell;
    if (indexPath.section == ReleaseHomeworkSectionType_complete) {
        
        ReleaseStyleCell * tempCell = [tableView dequeueReusableCellWithIdentifier:ReleaseStyleCellIdentifier ];
        ReleaseStyle style ;
        NSString * detail = nil;
        tempCell.detailLabel.textColor = HexRGB(0xB3B3B3);
        
        switch (indexPath.row) {
            case ReleaseStyle_ReleaseGrade:{
                style = ReleaseStyle_ReleaseGrade;
                //有选中的班级
                if (self.classArray.count>0) {
                    detail = self.className;
                    tempCell.detailLabel.textColor = HexRGB(0x4D4D4D);
//                    #4D4D4D
                }
            }
                break;
            case ReleaseStyle_ReleaseFeedback:{
                style = ReleaseStyle_ReleaseFeedback;
                detail =  self.selectedFeedbackModel.name;
                if (self.selectedFeedbackModel.name) {
                    tempCell.detailLabel.textColor = HexRGB(0x4D4D4D);
                }
            }
                break;
            case ReleaseStyle_ReleaseCompleteDate:
                style = ReleaseStyle_ReleaseCompleteDate;
                detail = self.CompletionTime ;
                if (!self.isCompletionTime) {
                    tempCell.detailLabel.textColor = HexRGB(0x4D4D4D);
                }
                break;
                
            default:
                style = ReleaseStyle_Normal;
                break;
        }
        
        [tempCell setupReleaseHomeworkStyle:style withDetail:detail];
        cell = tempCell;
        
    }else if (indexPath.section == ReleaseHomeworkSectionType_contentTab){
        if (self.isTextView) {//消息内容 一段
            ReleaseCopyEditorViewCell * inputCell = [tableView dequeueReusableCellWithIdentifier:ReleaseCopyEditorViewCellIdentifier  ];
            [inputCell setupCopyEditor:[self.inputContentArrays componentsJoinedByString:@"\n"]];
            
            inputCell.inputBlock = ^(NSMutableArray *inputContents) {
                [self.inputContentArrays removeAllObjects];
                if ([inputContents count] >0) {
                    [self.inputContentArrays addObjectsFromArray: inputContents];
                    [self updatePostState];
                }
            };
            cell = inputCell;
        }else{//事项e内容 1.2.3.
            
            NSInteger  count ;
            if ([self.inputContentArrays count]>0) {
                count = [self.inputContentArrays count];
            }else{
                count = 1;
            }
            
            if (indexPath.row == count) {//添加事件
                
                _addCell = [tableView dequeueReusableCellWithIdentifier:AddReleaseEditMattersCellIdentifier ];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addItemDecorateHomeworkCustom)];
                [_addCell addGestureRecognizer:tap];
//                self.inputContentArrays
                
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans"];
                formatter.locale = locale;
                formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
                
                NSString *rowStr = [formatter stringFromNumber:[NSNumber numberWithInteger: indexPath.row+1]];
                _addCell.detailLabel.text = [NSString stringWithFormat:@"%ld.  点击添加事项%@",indexPath.row+1,rowStr];
              
                _addCell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell = _addCell;
            }else{//已有事件    updatedText更新数据
                ReleaseEditMattersCell  * mattersCell = [tableView dequeueReusableCellWithIdentifier:ReleaseEditMattersCellIdentifier ];
                mattersCell.selectionStyle = UITableViewCellSelectionStyleNone;
                if ([self.inputContentArrays count] >0) {
                    [mattersCell setupContentInfo:self.inputContentArrays[indexPath.row] withRow:indexPath.row];
                }else{
                    [mattersCell setupContentInfo:nil withRow:indexPath.row];
                }
             
                mattersCell.delegate = self;
                mattersCell.expandableTableView = self.tableView;
                cell = mattersCell;
            }
        }
        
    }else if (indexPath.section == ReleaseHomeworkSectionType_images){//图片
        ReleaseImageCell * imagesCell = [tableView dequeueReusableCellWithIdentifier:
                                         ReleaseImageCellIdentifier];
        imagesCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [imagesCell setupReleaseImageCellPhotos:self.selectedPhotos withAssets:self.selectedAssets];
        imagesCell.deleteBlock = ^(UIButton *btn) {
            [self deleteBtnClik:btn];
        };
        imagesCell.lookImageBlock = ^(NSIndexPath *index) {
            [self lookImageDetail:index];
        };
        imagesCell.backgroundColor = [UIColor whiteColor];
        cell = imagesCell;
    }else if(indexPath.section == ReleaseHomeworkSectionType_voice){//录音
        ReleaseVoiceworkCell * voiceworkCell = [tableView dequeueReusableCellWithIdentifier:ReleaseVoiceworkCellIdentifier  ];
        voiceworkCell.deleteBlock = ^{
            [self deleteVoiceAction];
        };
        [voiceworkCell updateVoice:self.selectedVoice[indexPath.row][@"urlCaf"]];
        cell = voiceworkCell ;
        
    }else if(indexPath.section == ReleaseHomeworkSectionType_books){
        if (indexPath.row < [self.selectedBooks count]) {
            ReleaseBookworkCell * bookworkCell = [tableView dequeueReusableCellWithIdentifier:ReleaseBookworkCellIdentifier];
            bookworkCell.selectionStyle = UITableViewCellSelectionStyleNone;
            bookworkCell.index = indexPath;
            bookworkCell.deleteBlock = ^(NSIndexPath *index) {
                [self deleteBookwork:index];
            };
            bookworkCell.lineView.hidden = YES;
            [bookworkCell setupBookworkInfo:self.selectedBooks[indexPath.row]];
            cell = bookworkCell ;
        }else  if (indexPath.row == [self.selectedBooks count]) {
            
            ReleaseAddBookworkCell * addbook = [tableView dequeueReusableCellWithIdentifier:ReleaseAddBookworkCellIdentifier ];
            addbook.buttonCenterY.constant = 5;
            WEAKSELF
            addbook.addBookBlock = ^{
                [weakSelf addNewBookDecorateHomework];
            };
            if([self.selectedBooks count]>0){
                addbook.hidden = YES;
            }else{
                addbook.hidden = NO;
            }
            cell = addbook ;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    ReleaseHeaderView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ReleaseHeaderViewIdentifier];
    headerView.hidden = YES;
    if (section == ReleaseHomeworkSectionType_books&&[self.selectedBooks count] > 0){
        headerView.hidden = NO;
        headerView.topLineView.hidden = YES;
        headerView.titleLabel.text = @"书本作业";
        headerView.moreBookButton.hidden = NO;
        headerView.iconTitleLabel.hidden = YES;
        [headerView.moreBookButton addTarget:self action:@selector(moreBookClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        headerView.moreBookButton.hidden = YES;
        if (section == ReleaseHomeworkSectionType_images) {
            if ([self.selectedPhotos count] > 0) {
                headerView.hidden = NO;
                headerView.titleLabel.hidden = NO;
                headerView.titleLabel.text = @"图片";
                headerView.iconTitleLabel.hidden = NO;
                headerView.iconTitleLabel.text = [NSString stringWithFormat:@"%zd张",self.selectedPhotos.count];
            }
        }else if (section == ReleaseHomeworkSectionType_voice ){
            if ([self.selectedVoice  count] >0) {
                headerView.hidden = NO;
                headerView.titleLabel.hidden = NO;
                headerView.titleLabel.text = @"录音" ;
                headerView.iconTitleLabel.hidden = NO;
                if (self.totalLength<=9) {
                    headerView.iconTitleLabel.text = [NSString stringWithFormat:@"00:0%zd",self.totalLength];
                }else{
                    headerView.iconTitleLabel.text = [NSString stringWithFormat:@"00:%zd",self.totalLength];
                }
            }
            
        }
    }
    return headerView;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footerView = [UIView new];
    if (section == ReleaseHomeworkSectionType_complete) {
        ReleaseEditContentFooterView * editContentFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:  ReleaseEditContentFooterViewIdentifier];
        WEAKSELF
        editContentFooterView.buttonsBlock = ^(ReleaseEditContentFooterViewType type) {
            STRONGSELF
            if (type<3) {
                strongSelf.chooseButtonType = type;
            }
            
            if (type == ReleaseEditContentFooterViewType_voiceButton) {
                
                [self voiceAction];
            }else if (type == ReleaseEditContentFooterViewType_photoButton){
                [self pushPickerAction];
                
            }else if (type == ReleaseEditContentFooterViewType_todoButton){
                
                [self addItemDecorateHomework];
                [self todoAction];
            }else if (type == ReleaseEditContentFooterViewType_textViewButton){
                
                [self textViewAction];
            }
        };
        [editContentFooterView buttonSelectedTag:self.chooseButtonType];
        
        footerView = editContentFooterView;
    }
    return footerView;
}

- (void)addItemDecorateHomeworkCustom{
    [self addItemDecorateHomework];
    [self todoAction];
}
//766633728
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == ReleaseHomeworkSectionType_contentTab) {
        return 1.0;
    }else if ( section == ReleaseHomeworkSectionType_voice){
        return [self.selectedVoice count]>0 ? 58 :0.01;
    }else if (section == ReleaseHomeworkSectionType_images) {
          return [self.selectedPhotos count]>0 ? 58 :0.01;
    }else if (section == ReleaseHomeworkSectionType_books){
            return [self.selectedBooks count]>0 ? 58 :0.01;
    }
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    CGFloat footerHeight =  0.0001;
    if (section == ReleaseHomeworkSectionType_complete) {
        footerHeight = 48+8;
    }else if (section == ReleaseHomeworkSectionType_complete){
        
        footerHeight = 7;
    }
    
    return footerHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section ==  ReleaseHomeworkSectionType_complete) {
        if (indexPath.row == ReleaseStyle_ReleaseFeedback) {
            [self gotoFeedbackVC];
        }else if (indexPath.row == ReleaseStyle_ReleaseCompleteDate){
            [self showCompletionAlertView];
        }else if (indexPath.row == ReleaseStyle_ReleaseGrade){
            [self gotoChooseClass];
        }
        
    }else if (indexPath.section ==  ReleaseHomeworkSectionType_books){
        
        if (self.selectedBooks.count == 0 ||indexPath.row == self.selectedBooks.count ) {
            [self addNewBookDecorateHomework];
        }else{//回填
            if (self.selectedBooks.count>0) {
                NSDictionary *tempDic = [ProUtils dictionaryWithJsonString:[self.selectedBooks firstObject]];
                if (tempDic&&tempDic[@"bookId"]&&tempDic[@"bookType"]) {
                    BookHomeworkViewController * bookHomeworkVC = [[BookHomeworkViewController alloc]initWithBookId:tempDic[@"bookId"] withBookType:tempDic[@"bookType"] withClear:NO];
                    bookHomeworkVC.backContent = tempDic;
                    [self pushViewController:bookHomeworkVC];
                }
            }
        }
    }else if (indexPath.section ==  ReleaseHomeworkSectionType_contentTab){
        NSInteger row = [self.inputContentArrays count] + ([self.inputContentArrays count]>0?1:2);
        if (!self.isTextView ) {
            if ( row>2 && indexPath.row == row - 1 ) {
                if ([self.inputContentArrays lastObject] ) {
                    NSString * str = [self.inputContentArrays lastObject];
                    if (str.length >0) {
                        [self addItemDecorateHomework];
                    }
                }
                
            }else if (row ==2 && [self.inputContentArrays count]==1){
                [self addItemDecorateHomework];
                [self todoAction];
            }
        }
    }
    
}

#pragma mark 事项Textview
- (void)tableView:(UITableView *)tableView updatedHeight:(CGFloat)height atIndexPath:(NSIndexPath *)indexPath
{
    if ([self.mattersCellHeights count] >= indexPath.row+1) {
        [self.mattersCellHeights replaceObjectAtIndex:indexPath.row withObject:@(height) ];
    }else{
        
        [self.mattersCellHeights addObject:@(height)];
    }
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (_deleteBookTipView && _deleteBookTipView.hidden == NO) {
//        [UIView animateWithDuration:0.2 animations:^{
//            _deleteBookTipView.hidden = YES;
//        }];
//    }
//}

- (void)tableView:(UITableView *)tableView updatedText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.inputContentArrays count]>=indexPath.row+1) {
        [self.inputContentArrays replaceObjectAtIndex:indexPath.row withObject:text];
    }else{
        if ([self.inputContentArrays count ]== 0) {
            [self.inputContentArrays addObject:text];
        }else
            [self.inputContentArrays addObject:[NSString stringWithFormat:@"\n%@",text]];
    }
    [self updatePostState];
}
- (void)textViewShouldReturn{
    [self addItemDecorateHomeworkCustom];
}

- (void)customTextView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    self.inputContentArrays
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self customTextViewUpdatePost];
    });
}

- (void)customTextViewUpdatePost{
    [self updatePostState];
    if (_addCell == nil) {
        return;
    }
    NSInteger tempint = 0;
    for (NSString *strTemp in self.inputContentArrays) {
        tempint = [strTemp length]+tempint;
    }
    _addCell.countLabel.text = [NSString stringWithFormat:@"%ld/1000",tempint];
    NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:_addCell.countLabel.text];
    NSRange redRange = NSMakeRange([_addCell.countLabel.text rangeOfString:@"/1000"].location,[ _addCell.countLabel.text rangeOfString:@"/1000"].length);
    //修改特定字符的颜色
    [attrDescribeStr addAttribute:NSForegroundColorAttributeName value:HexRGB(0xB3B3B3) range:redRange];
    _addCell.countLabel.attributedText = attrDescribeStr;
}

#pragma mark 获取班级信息
- (NSString *)getChooseClassId{
    
    NSString * classId = @"";
    for (ClassListGruopModel * model in  self.classArray) {
        
        for (ClassManageModel *classMode in model.clazzes) {
            if (classMode.isSelected == YES) {
                if ([classId length] <=0) {
                    classId = classMode.clazzId;
                }else{
                    
                    classId = [classId stringByAppendingString:[NSString stringWithFormat:@",%@",classMode.clazzId]];
                }
            }
        }
    }
    
    classId = [NSString stringWithFormat:@"%@",classId];
    
    return  classId;
}

- (void)ChooseClassViewController:(ChooseClassViewController *)classViewController data:(NSArray *)dataArray gradeStr:(NSString*)grade{
    
    self.classArray = dataArray;
//    self.className = [NSString stringWithFormat:@"%@所有班级",grade];

    NSString *strGrade;
//    for (NSInteger i = 0;i<self.dataArray.count; i++) {
//        ClassChooseHeaderVIew * tempHeaderView = [self.tableView headerViewForSection:i];
//        if (tempHeaderView.allClassButton.selected) {
//            strGrade = tempHeaderView.gradeLabel.text;
//        }
//    }
    
    NSString * classId = @"";
    NSString * className = strGrade;
    for (ClassListGruopModel * model in  dataArray) {
        for (ClassManageModel *classMode in model.clazzes) {
            if (classMode.isSelected == YES) {
                if ([classId length] <=0) {
                    classId = classMode.clazzId;
                    className = classMode.clazzName;
    
                }else{
                    
                    classId = [classId stringByAppendingString:[NSString stringWithFormat:@",%@",classMode.clazzId]];
                    className = [className stringByAppendingString:[NSString stringWithFormat:@",%@",classMode.clazzName]];
                }
            }
        }
    }
    
    classId = [NSString stringWithFormat:@"%@",classId];
    self.className = className;
    
//    if (grade == nil) {
//        for (NSInteger i = 0;i<self.classArray.count; i++) {
//            ClassListGruopModel *tempModel = self.classArray[i];
//            for (ClassManageModel *classMode in tempModel.clazzes) {
//                if (classMode.isSelected == YES) {
//                    self.className = [NSString stringWithFormat:@"%@ %@",tempModel.gradeName,classMode.clazzName];; ///////// 选出选择的班级
//                }
//            }
//        }
//    }
    
    [self.tableView reloadData];
}

#pragma mark  touch event
- (void)gotoChooseClass{
    
    ChooseClassViewController * chooseClassVC = [[ChooseClassViewController alloc]initWithViewControllerFromeType:ViewControllerFromeType_Choose];
    chooseClassVC.chooseDelegate = self;
    if (self.classArray.count >0) {
        chooseClassVC.classIds = [self getChooseClassId];
    }
    
    [self pushViewController:chooseClassVC];
}
- (void)gotoFeedbackVC{
    
    FeedbackViewController * feedbackVC = [[FeedbackViewController alloc]initWithIndex:self.selectedFeedbackIndex];
    WEAKSELF
    feedbackVC.feedbackBlock = ^(FeedbackModel *model, NSInteger  index){
        STRONGSELF
        strongSelf.selectedFeedbackIndex = index;
        strongSelf.selectedFeedbackModel = model;
        [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:ReleaseStyle_ReleaseFeedback inSection:ReleaseHomeworkSectionType_complete]] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self pushViewController:feedbackVC];
}

- (void)showCompletionAlertView{
    

    UIWindow *firstWindow = [UIApplication.sharedApplication.windows firstObject];
    _timeViewMask  = [[[NSBundle mainBundle] loadNibNamed:@"ReleaseHomeworkTimeViewMask" owner:nil options:nil] lastObject];
    _timeViewMask.frame = firstWindow.bounds;
    _timeViewMask.contentView .backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    [_timeViewMask.finishButton addTarget:self action:@selector(timefinishClick:) forControlEvents:UIControlEventTouchUpInside];
    [_timeViewMask.cancleButton addTarget:self action:@selector(timecancleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [firstWindow addSubview:_timeViewMask];
    _timeViewMask.pickBottom.backgroundColor = [UIColor whiteColor];
}

- (void)timecancleButtonClick:(UIButton *)button{
     [_timeViewMask removeFromSuperview];
}
- (void)timefinishClick:(UIButton *)button{
    [_timeViewMask removeFromSuperview];
    
    NSDate *select = _timeViewMask.pickBottom.date;
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc]init];
    selectDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateAndTime = [selectDateFormatter stringFromDate:select];

//    2019-01-26 23:59
    self.CompletionTime = dateAndTime;
    self.isCompletionTime = NO;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:ReleaseStyle_ReleaseCompleteDate inSection:ReleaseHomeworkSectionType_complete]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)deleteBookDecorateHomework{
    if (_deleteBookTipView.hidden == NO) {
        [self customTouchesBegan:nil];
    }
//    NSString * content = userInfo[@"content"];
    self.bookSubjectName = @"";
    self.selectedBooks = [NSMutableArray new];
//    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedBooks count]-1 inSection:ReleaseHomeworkSectionType_books]]  withRowAnimation:UITableViewRowAnimationBottom];
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.selectedBooks count] inSection:ReleaseHomeworkSectionType_books] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    [self.tableView reloadData];
}

#pragma mark - Click Event 事件处理
- (void)moreBookClick:(UIButton *)button{
    //弹出框   更换书，h删除    跳我的书架  124  96
    [self scrollTableToFoot:YES];
    _deleteBookTipView.hidden = NO;
    _deleteBookTipView.frame = CGRectMake(kScreenWidth -124-16, self.tableView.contentSize.height -65-95-88, 124, 95);
    [self.tableView bringSubviewToFront:_deleteBookTipView];
    [_deleteBookTipView.changeButton addTarget:self action:@selector(addNewBookDecorateHomework) forControlEvents:UIControlEventTouchUpInside];
    [_deleteBookTipView.deleteButton addTarget:self action:@selector(deleteBookDecorateHomework) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customTouchesBegan:)];
    tap1.delegate = self;
    [self.tableView addGestureRecognizer:tap1];
}
- (void)customTouchesBegan:(UITapGestureRecognizer *)tap{
    if (_deleteBookTipView) {
        [UIView animateWithDuration:0.2 animations:^{
            _deleteBookTipView.hidden = YES;
        }];
    }
    [tap removeTarget:nil action:NULL];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UITableView class]]
        ||[NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
  
        return NO;
    }
    if (self.deleteBookTipView.hidden == YES) {
        return NO;
    }
    return  YES;
}



- (void)scrollTableToFoot:(BOOL)animated
{
    NSInteger s = [self.tableView numberOfSections];  //有多少组
    if (s<1) return;  //无数据时不执行 要不会crash
    NSInteger r = [self.tableView numberOfRowsInSection:s-1]; //最后一组有多少行
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];  //取最后一行数据
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated]; //滚动到最后一行
}

- (void)reloadImages{
    NSIndexSet * indexset = [NSIndexSet indexSetWithIndex:ReleaseHomeworkSectionType_images];
    [UIView performWithoutAnimation:^{
        [self.tableView reloadSections:indexset withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:ReleaseHomeworkSectionType_images] atScrollPosition:UITableViewScrollPositionNone animated:NO];
}

- (void)deleteVoiceAction{
    [self.selectedVoice removeAllObjects];
    self.totalLength =  0;
    
    [UIView performWithoutAnimation:^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex: ReleaseHomeworkSectionType_voice] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
}

- (void)pushPickerAction{
    [UIView performWithoutAnimation:^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex: ReleaseHomeworkSectionType_contentTab] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    [self pushImagePickerController];
}

- (void)voiceAction{
    
    if ([self.selectedVoice count] >0) {
        
        [SVProgressHelper dismissWithMsg:@"只能添加一条语音哦!"];
    }else{
        //语音
        [UIView performWithoutAnimation:^{
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex: ReleaseHomeworkSectionType_contentTab] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        RecordingView *recording= [[RecordingView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        WEAKSELF
        recording.saveRecordingBlock = ^(NSURL * recordingUrl,NSURL *mp3Url, NSInteger totalLength){
            
            if ([self.selectedVoice count] == 0) {
                [self.selectedVoice addObject:@{@"urlCaf":recordingUrl,@"urlMp3":mp3Url}];
            }
            weakSelf.totalLength = totalLength;
            
            [UIView performWithoutAnimation:^{
                [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex: ReleaseHomeworkSectionType_voice] withRowAnimation:UITableViewRowAnimationNone];
            }];
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:ReleaseHomeworkSectionType_voice] atScrollPosition:UITableViewScrollPositionNone animated:YES];
            
        };
        [[UIApplication sharedApplication].keyWindow  addSubview:recording];
    }
}

- (void)textViewAction{
    //文字
    self.isTextView = YES;
    self.contentType = @"00";
    [self.tableView reloadData];
}


- (void)deleteBtnClik:(UIButton *)sender {
    
    
    [UIView performWithoutAnimation:^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:ReleaseHomeworkSectionType_images] withRowAnimation:UITableViewRowAnimationNone];
    }];
//    [self.tableView reloadData];
}

- (void)deleteBookwork:(NSIndexPath *)index{
 
    if ([self.selectedBooks count]>= index.row) {
        NSData * data = [ self.selectedBooks[index.row] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]; ;
        NSString * content =[NSString stringWithFormat:@"确定删除\n%@",dic[@"name"]];
        
        self.selectedBookIndex = index;
        WEAKSELF
        [self showNormalAlertTitle:@"温馨提示" content:content items:nil block:^(NSInteger index) {
            STRONGSELF
            [self.selectedBooks removeObjectAtIndex:strongSelf.selectedBookIndex.row];
         
            [self.tableView deleteRowsAtIndexPaths:@[strongSelf.selectedBookIndex]  withRowAnimation:UITableViewRowAnimationBottom];
            if (self.selectedBooks.count == 0) {
                self.bookSubjectName = nil;
                
            }
        }];
      
    }
}

//添加书本作业
- (void)addNewBookDecorateHomework{
    if (_deleteBookTipView.hidden == NO) {
        [self customTouchesBegan:nil];
    }
    
    NSString * subjectName = self.bookSubjectName;
    //原生
    BookcaseViewController *bookcaseVC = [[BookcaseViewController alloc]initWithbzSubjectName:subjectName];
    [self pushViewController:bookcaseVC];
}

- (void)addItemDecorateHomework {
    
    [self.inputContentArrays addObject:@""];
    
    [UIView performWithoutAnimation:^{
        [self.tableView  reloadSections:[NSIndexSet indexSetWithIndex: ReleaseHomeworkSectionType_contentTab] withRowAnimation:UITableViewRowAnimationNone];
    }];
    NSInteger row = [self.inputContentArrays count]-1;
    ReleaseEditMattersCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:ReleaseHomeworkSectionType_contentTab]];
    [cell.textView becomeFirstResponder];
    
}

- (void)releaseAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    sender.enabled = NO;
    if (sender.selected) {
        [self releaseHomework];
    }
}

-(int)compareDate:(NSString*)startDate withDate:(NSString*)endDate{
    
    int comparisonResult;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] init];
    date1 = [formatter dateFromString:startDate];
    date2 = [formatter dateFromString:endDate];
    NSComparisonResult result = [date1 compare:date2];
    NSLog(@"result==%ld",(long)result);
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending:
            comparisonResult = 1;
            break;
            //date02比date01小
        case NSOrderedDescending:
            comparisonResult = -1;
            break;
            //date02=date01
        case NSOrderedSame:
            comparisonResult = 0;
            break;
        default:
            NSLog(@"erorr dates %@, %@", date1, date2);
            break;
    }
    return comparisonResult;
}
- (NSString * )getNowDate
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    
    return dateStr;
}

#pragma mark 准备提交任务
- (void)releaseHomework{

    [[IQKeyboardManager sharedManager] resignFirstResponder];
    //清空上次选择的上传成功后的数据
    self.uplaodImageModel = nil;
    self.uplaodAudioModel = nil;
    NSString *  clazzIds = [self getChooseClassId];//必传
    if ([clazzIds length] <=0) {
        NSString * content = @"请您选择布置作业的班级";
        [SVProgressHelper dismissWithMsg:content];
        [self enabldSenderBtn];
        return;
    }
    
    
    NSString *  endTime= self.CompletionTime;//必传
    if ([endTime isEqualToString:@"选择截止时间"]||[endTime isEqualToString:@""]) {
        [SVProgressHelper dismissWithMsg:@"请选择截止时间"];
        [self enabldSenderBtn];
        return;
    }
    
    
    if ([endTime length] <=0) {
        NSString * content = @"请您选择布置作业的完成时间";
        [SVProgressHelper dismissWithMsg:content];
        [self enabldSenderBtn];
        return;
    }
//    NSComparisonResult result = [[self timeWithTimeIntervalString:endTime] compare:[self getNowDate]];
    int result = [self compareDate:endTime withDate:[self getNowDate]];
    if (result >= 0) {
        NSString * content = @"作业截⽌止时间错误";//24
        [SVProgressHelper dismissWithMsg:content];
        [self enabldSenderBtn];
        return;
    }
    
    if ([self.selectedVoice count]== 0 && [self.selectedAssets count] ==0 && [self.inputContentArrays count]== 0 &&[self.selectedBooks count]== 0) {
        NSString * content = @"请您布置作业内容";
        [SVProgressHelper dismissWithMsg:content];
        [self enabldSenderBtn];
        return;
    }
    if (self.selectedFeedbackModel == nil) {
        NSString * content = @"请您选择反馈方式";
        [SVProgressHelper dismissWithMsg:content];
        [self enabldSenderBtn];
        return;
    }
    
    if ([self.selectedBooks count]== 0 && !self.subjects) {
        self.subjects = @"004";
//        [self showSubjectsAlert];
//        [self enabldSenderBtn];
//        return;
    }
    if ([self.selectedAssets count] >0) {
        [self uploadImgV];
    }else if ([self.selectedAssets count] == 0 && [self.selectedVoice count] >0){
        
        [self uploadAudio];
    }else if ([self.selectedVoice count] == 0 && [self.selectedAssets count] ==0){
        
        [self requestReleaseHomework];
    }

}

- (void)enabldSenderBtn{

    UIButton * releaseBtn = self.navigationItem.rightBarButtonItem.customView;
    releaseBtn.selected = NO;
    releaseBtn.enabled = YES;
}

#pragma mark 上传
- (void)uploadImgV{
    
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
            
//            NSArray *resources = [PHAssetResource assetResourcesForAsset:asset];
//            fileName = ((PHAssetResource*)resources[0]).originalFilename;
        } else {
            ALAsset * asset = self.selectedAssets[i];
            fileName =  asset.defaultRepresentation.filename;
            
        }
        [fileDic setObject:image forKey: fileName];
    }
    
    if ([self.selectedAssets count] > 0) {
      
        [[NetRequestManager sharedInstance] sendUploadRequest:(NSURL *)url parameterDic:@{@"appType":@"Primary",@"busiType":@"avatar"} requestMethodType:RequestMethodType_UPLOADIMG requestTag:NetRequestType_HomeworkUploadImage  delegate:self fileDic:fileDic];
    }
}

- (void)uploadAudio{
   for (int i =0;i<[self.selectedVoice count] ;i++) {
        [self  transformCAFToMP3UrlCaf:self.selectedVoice[i][@"urlCaf"] withMp3Url:self.selectedVoice[i][@"urlMp3"]];
    }
}

#pragma mark  request
- (void)requestReleaseHomework{
   
    NSString *  clazzIds = [self getChooseClassId];//必传
    NSString *  endTime= [NSString stringWithFormat:@"%@:59",self.CompletionTime];//必传
    
    NSString *  feedback = @"";//可选
    NSString *  text = @"";//可传
    NSString *  photos= @"";//可传
    NSString *  sound= @"";//可传
    NSString *  bookHomeworks= @"";//可传
    
    NSMutableDictionary  *requestParameterDic = [NSMutableDictionary dictionary];
    NSDictionary * mustDic =  @{
                                @"clazzIds":clazzIds,
                                @"endTime":endTime,
                                
                                };
    [requestParameterDic addEntriesFromDictionary:  mustDic];
    
    if (self.selectedFeedbackModel) {
        feedback = self.selectedFeedbackModel.id;
        [requestParameterDic addEntriesFromDictionary:@{@"feedback":feedback}];
    }
    
    if ([self.inputContentArrays count] > 0) {
        
        if ([self.contentType  isEqualToString:@"00"]) {
            text = [self.inputContentArrays componentsJoinedByString:@"\n"];
            [requestParameterDic addEntriesFromDictionary:@{@"text":text}];
        }else if ([self.contentType isEqualToString:@"01"]){
            
            for (int i = 0; i<[self.inputContentArrays count]; i++) {
                NSString * newline = @"\n";
                if (i ==0) {
                    newline = @"";
                }
              text = [text stringByAppendingString:[NSString stringWithFormat:@"%@%zd、%@",newline,i+1,self.inputContentArrays[i]]] ;
                
            }
            
            [requestParameterDic addEntriesFromDictionary:@{@"text":text}];
        }
        
    }
    if (self.uplaodAudioModel) {
        sound = [self.uplaodAudioModel.visitUrls allValues][0];
        [requestParameterDic addEntriesFromDictionary:@{@"sound": sound}];
    }
    if (self.uplaodImageModel){
        for (int i =0;i<[self.selectedAssets count] ;i++) {
            
            NSString * fileName = @"";
            if (iOS8Later) {
                
                PHAsset * asset = self.selectedAssets[i];
                 fileName= asset.localIdentifier;
                if (![fileName containsString:@".jpg"]) {
                    fileName = [fileName stringByAppendingString:@".jpg"];
                }
            } else {
                ALAsset * asset = self.selectedAssets[i];
                fileName =  asset.defaultRepresentation.filename;
                
            }
            
            if ([photos length] <=0) {
                photos = [self.uplaodImageModel.visitUrls objectForKey:fileName];
            }else{
                photos = [NSString stringWithFormat:@"%@,%@",photos,[self.uplaodImageModel.visitUrls objectForKey:fileName]];
            }
            
        }
        
        [requestParameterDic addEntriesFromDictionary:@{@"photos":photos}];
    }
    if([self.selectedBooks count] >0){
        bookHomeworks =[NSString stringWithFormat:@"[%@]",[self.selectedBooks componentsJoinedByString:@","]];
        
        bookHomeworks = [bookHomeworks stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        bookHomeworks = [bookHomeworks stringByReplacingOccurrencesOfString:@" " withString:@""];
        bookHomeworks = [bookHomeworks stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [requestParameterDic addEntriesFromDictionary:@{@"bookHomeworks":bookHomeworks}];
    }
    if (self.subjects) {
           [requestParameterDic addEntriesFromDictionary:@{@"subjectId":self.subjects}];
    }
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherAssignHomework] parameterDic: requestParameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherAssignHomework];
    
}

- (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error{

    [super netRequest:request failedWithError:error];
    UIButton * releaseBtn = self.navigationItem.rightBarButtonItem.customView;
    releaseBtn.selected = NO;
    releaseBtn.enabled = YES;
}

- (void)netRequest:(NetRequest *)request successWithInfoObj:(id)infoObj{
    
     UIButton * releaseBtn = self.navigationItem.rightBarButtonItem.customView;
     releaseBtn.selected = NO;
     releaseBtn.enabled = YES;
    if (request.tag == NetRequestType_HomeworkUploadImage) {
        self.uplaodImageModel = [[UploadFileModel alloc]initWithDictionary:infoObj error:nil];
         [super hideHUD];
        if ([self.selectedVoice count]> 0) {
            [self uploadAudio];
        }else{
            [self requestReleaseHomework];
        }
        
    }else if (request.tag == NetRequestType_HomeworkUploadAudio){
        self.uplaodAudioModel = [[UploadFileModel alloc]initWithDictionary:infoObj error:nil];
        [super hideHUD];
        [self requestReleaseHomework];
        
    }else if (request.tag == NetRequestType_TeacherAssignHomework){
        
        [super netRequest:request successWithInfoObj:infoObj];
    }else{
       [super netRequest:request successWithInfoObj:infoObj];
    }
}



- (void)setNetworkRequestStatusBlocks{
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_TeacherAssignHomework) {
//            [strongSelf showAlert:TNOperationState_OK content:@"布置作业完成" block:^(NSInteger index) {
               [strongSelf checkTipViewSure];
//            }];
            
            UIWindow *firstWindow = [UIApplication.sharedApplication.windows firstObject];
            XJRepositoryTipsView *noticeView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XJRepositoryTipsView class]) owner:nil options:nil].firstObject;
            noticeView.tipLabel.text = @"布置作业完成";
            noticeView.frame =  CGRectMake((kScreenWidth-148)/2, (kScreenHeight-113)/2, 148, 113);
            //    noticeView.image = [UIImage imageNamed:@"6DE32DA4-BCC4-475A-9B9D-9F3D30E63D8A"];
            noticeView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
            noticeView.layer.cornerRadius = 6.0;
            noticeView.layer.masksToBounds = YES;
            [firstWindow addSubview:noticeView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [noticeView removeFromSuperview];
            });
        }
    }];
}

#pragma mark  choose Delegate
//- (void)chooseClassInfo:(NSDictionary *)info{
//
//    self.selectedClassInfo = info;
//    NSMutableArray * tempArray = [NSMutableArray array];
//    for (ClassManageModel *model in [self.selectedClassInfo allValues][0]) {
//        [tempArray addObject:model.clazzId];
//    }
//    [[NSUserDefaults standardUserDefaults] setObject:@{[self.selectedClassInfo allKeys][0]:tempArray} forKey:SAVE_RELEASEHOMEWORKCLASS];
//    [self reloadGrad];
//
//}
- (void)reloadGrad{
    
    [UIView performWithoutAnimation:^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:ReleaseStyle_ReleaseGrade] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)uploadMp3{
    
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
    for (int i =0;i<[self.selectedVoice count] ;i++) {
        
        
        NSURL * voiceURL = self.selectedVoice[i][@"urlMp3"];
        
        [fileDic setObject:voiceURL  forKey: kMyselfRecordFile];
    }
    
    if ([self.selectedVoice count] >0) {
        [[NetRequestManager sharedInstance] sendUploadRequest:(NSURL *)url parameterDic:@{@"appType":@"Primary",@"busiType":@"voice"} requestMethodType:RequestMethodType_UPLOADAUDIO requestTag:NetRequestType_HomeworkUploadAudio  delegate:self fileDic:fileDic];
    }
    
}

- (void)dealloc{
 
    [self setTableView:nil];
    [self setSelectedBooks:nil] ;
    [self setSelectedVoice:nil ];
    [self setSelectedBookIndex:nil];
    [self setSelectedPhotos:nil];
    [self setSelectedAssets: nil];
    [self setInputContentArrays:nil];
//    [self setSelectedClassInfo:nil];
    [self setSelectedFeedbackModel:nil];
    [self  setMattersCellHeights:nil];
    [self setUplaodImageModel: nil];
    [self setUplaodAudioModel:nil];
    [self clearDelegate];
 
}

// 页面消失时候
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ReleaseVoiceworkCell * voiceworkCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:  ReleaseHomeworkSectionType_voice] ];
    [voiceworkCell stopPlayer];
    
    [self navUIBarBackground:8];
}

- (void)showSubjectsAlert{

    NSString * title = @"您布置的作业属于什么科目？";
    NSArray *  items =@[
                        MMItemMake(@"取消", MMItemTypeHighlight, nil),
                        MMItemMake(@"确定", MMItemTypeHighlight, nil)
                        ];
    AlertView * alertView = [[AlertView alloc]initWithTitle:title withSubjects:@"" items:items];
    
    WEAKSELF
    alertView.subjectsBlock = ^(NSString *subjects) {
        weakSelf.subjects = subjects;
        
        if ([weakSelf.selectedAssets count] >0) {
            [weakSelf uploadImgV];
            
        }else if ([self.selectedAssets count] == 0 && [self.selectedVoice count] >0){
            
            [weakSelf uploadAudio];
        }else if ([self.selectedVoice count] == 0 && [self.selectedAssets count] ==0){
            
            [weakSelf requestReleaseHomework];
        }
    };
    [alertView show];
}


- (void)addHomework:(NSNotification *)notifi{
   [self handleHomeworkDic:notifi.userInfo];
}

- (void)handleHomeworkDic:(NSDictionary *)userInfo{
    self.selectedBooks = [NSMutableArray new];
    NSString * content = userInfo[@"content"];
//    if (!self.bookSubjectName) {
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        self.bookSubjectName = json[@"subjectName"];
//    }
    [self.selectedBooks addObject:content];
//    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.selectedBooks count]-1 inSection:ReleaseHomeworkSectionType_books]]  withRowAnimation:UITableViewRowAnimationBottom];
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.selectedBooks count] inSection:ReleaseHomeworkSectionType_books] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    [self.tableView reloadData];
    
}


- (void)transformCAFToMP3UrlCaf:(NSURL *)recordingUrl  withMp3Url:(NSURL *)mp3Url{
    //    NSURL* mp3FilePath = [NSURL URLWithString:[NSTemporaryDirectory() stringByAppendingString:kMyselfRecordFile]];
    NSURL * mp3FilePath = mp3Url;
    @try {
        int read, write;
        
        FILE *pcm = fopen([[recordingUrl  absoluteString] cStringUsingEncoding:1], "rb");   //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                                   //skip file header
        FILE *mp3 = fopen([[mp3FilePath absoluteString] cStringUsingEncoding:1], "wb"); //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
        [self showAlert:TNOperationState_Fail content:@"上传音频失败,请稍后再试"];
    }
    @finally {
        
        NSLog(@"MP3生成成功: %@",mp3FilePath);
        [self uploadMp3];
    }
}

-(void)registerCell{
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReleaseStyleCell class])  bundle:nil] forCellReuseIdentifier:ReleaseStyleCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReleaseCopyEditorViewCell class])  bundle:nil] forCellReuseIdentifier:ReleaseCopyEditorViewCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReleaseEditContentFooterView class])  bundle:nil]  forHeaderFooterViewReuseIdentifier:ReleaseEditContentFooterViewIdentifier];
    [self.tableView registerClass: [ReleaseEditMattersCell class]  forCellReuseIdentifier:ReleaseEditMattersCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AddReleaseEditMattersCell class])  bundle:nil] forCellReuseIdentifier:AddReleaseEditMattersCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReleaseImageCell  class]) bundle:nil]  forCellReuseIdentifier:ReleaseImageCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReleaseAddBookworkCell class]) bundle:nil] forCellReuseIdentifier:ReleaseAddBookworkCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReleaseBookworkCell class]) bundle:nil]  forCellReuseIdentifier:ReleaseBookworkCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReleaseVoiceworkCell class]) bundle:nil]  forCellReuseIdentifier:ReleaseVoiceworkCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReleaseHeaderView  class])  bundle:nil]  forHeaderFooterViewReuseIdentifier:ReleaseHeaderViewIdentifier];
}
- (void)backViewController
{
    NSString *  clazzIds = [self getChooseClassId];//必传
    NSString *  endTime= self.CompletionTime;//必传
    if (![endTime isEqualToString:@"选择截止时间"]&&![endTime isEqualToString:@""]) {
        NSString *tipStr = @"回到首页会清空当前已选内容 确认返回吗？";
        UIWindow *firstWindow = [UIApplication.sharedApplication.windows firstObject];
        [firstWindow addSubview: self.checkTipView];
        self.checkTipView.titleLabel.text = tipStr;
        [self.checkTipView.querenButton addTarget:self action:@selector(checkTipViewSure) forControlEvents:UIControlEventTouchUpInside];
        return;
    }if ([self.selectedVoice count]!= 0 || [self.selectedAssets count] !=0  || [self.inputContentArrays count]!= 0 ||[self.selectedBooks count]!= 0 || self.selectedFeedbackModel != nil || [clazzIds length] > 0) {
        NSString *tipStr = @"回到首页会清空当前已选内容 确认返回吗？";
        UIWindow *firstWindow = [UIApplication.sharedApplication.windows firstObject];
        [firstWindow addSubview: self.checkTipView];
        self.checkTipView.titleLabel.text = tipStr;
        [self.checkTipView.querenButton addTarget:self action:@selector(checkTipViewSure) forControlEvents:UIControlEventTouchUpInside];
        
        return;
    }
    
    [self checkTipViewSure];
}

- (void)checkTipViewSure{
    
    NSArray *viewControllers = [self.navigationController viewControllers];
    if (1 <= viewControllers.count && 0 < [viewControllers indexOfObject:self])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    if (_checkTipView) {
        [self.checkTipView removeFromSuperview];
    }
}
- (CheckDetialTipsView *)checkTipView {
    if (!_checkTipView) {
        
        _checkTipView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CheckDetialTipsView class]) owner:nil options:nil].firstObject;
        _checkTipView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        _checkTipView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }
    return _checkTipView;
}

#pragma mark 高度计算
- (void)todoAction{
    //事项
    self.isTextView = NO;
    self.contentType = @"01";
    
    if ([self.inputContentArrays count] >0) {
        [self.mattersCellHeights removeAllObjects];
        for (NSString * inputTodoItem in self.inputContentArrays) {
            CGFloat textViewW =  IPHONE_WIDTH - 60;
            CGFloat tempItemHeight =   itemHeight;
            CGFloat tempHeight = [self heightForString:inputTodoItem andWidth: textViewW];
            
            if (tempHeight >itemHeight) {
                tempItemHeight = tempHeight;
            }
            [self.mattersCellHeights addObject:@(tempItemHeight)];
        }
    }
    
    [self.tableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self customTextViewUpdatePost];
    });
}

- (float) heightForString:(NSString *)value andWidth:(float)width{
    
    //    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
    NSDictionary *dic = @{NSFontAttributeName:fontSize_14};
    // 计算文本的大小
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                        attributes:dic        // 文字的属性
                                           context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    return sizeToFit.height + 16.0;
}

#pragma mark - TZImagePickerController 进入图片选择器
- (void)pushImagePickerController {
    if ( MAX_IMAGE_COUNT  <= 0) {
        return;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:MAX_IMAGE_COUNT columnNumber:COLUMN_IMAGE_COUNT delegate:self pushPhotoPickerVc:YES];
    
    imagePickerVc.isSelectOriginalPhoto = NO;
    if (MAX_IMAGE_COUNT > 1) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    }
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    
    imagePickerVc.sortAscendingByModificationDate = NO;
    
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    imagePickerVc.circleCropRadius = 100;
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    [imagePickerVc setNaviBgColor:view_background_color];
    [imagePickerVc setNaviTitleFont:fontSize_17];
    
    [imagePickerVc setDoneBtnTitleStr:@"确定"];
    
    [imagePickerVc setOKButtonTitleColorNormal:[UIColor whiteColor]];
    [imagePickerVc setOKButtonTitleColorDisabled:[UIColor lightGrayColor]];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}



#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    
    [UIView performWithoutAnimation:^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:ReleaseHomeworkSectionType_images] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

//预览图
- (void)lookImageDetail:(NSIndexPath *)indexPath{
    if (_selectedAssets.count == indexPath.row) {
        [self pushImagePickerController];
        return;
    }
    id asset = _selectedAssets[indexPath.row];
    BOOL isVideo = NO;
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
    } else if ([asset isKindOfClass:[ALAsset class]]) {
        ALAsset *alAsset = asset;
        isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
    }
    // preview photos / 预览照片
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
    imagePickerVc.maxImagesCount = [_selectedAssets count];
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.isSelectOriginalPhoto = NO;
    [imagePickerVc setNaviBgColor:view_background_color];
    [imagePickerVc setNaviTitleFont:fontSize_17];
    
    [imagePickerVc setDoneBtnTitleStr:@"确定"];
    
    [imagePickerVc setOKButtonTitleColorNormal:[UIColor whiteColor]];
    [imagePickerVc setOKButtonTitleColorDisabled:[UIColor lightGrayColor]];
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        _selectedPhotos = [NSMutableArray arrayWithArray:photos];
        _selectedAssets = [NSMutableArray arrayWithArray:assets];
        
        [self reloadImages];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
