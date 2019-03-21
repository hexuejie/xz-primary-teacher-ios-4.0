//
//  TeachingAssistantsHomeworkListViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/11/3.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//
//大题下的小题
#import "TeachingAssistantsHomeworkListViewController.h"
#import "TeachingAssistantsDetailBottomView.h"
#import "TeachingAssistantsListItemImageContentCell.h"
#import "TeachingAssistantsListItemFooterCell.h"
#import "WrittenParseViewController.h"
 
#import "AssistantsQuestionModel.h"
#import "ZFPlayerView.h"
#import "TeachingAssistantsListItemTitleCell.h"
#import "TeachingAssistantsListItemChooseCell.h"
#import "TeachingAssistantsListBigItemAudioCell.h"
#import "UIViewController+BackButtonHandler.h"
#import "JFHomeworkTopicDetailViewController.h"


NSString * const  TeachingAssistantsListBigAudioSectionCellIdentifer = @"TeachingAssistantsListBigAudioSectionCellIdentifer";


NSString * const  TeachingAssistantsListItemChooseCellIdentifer = @"TeachingAssistantsListItemChooseCellIdentifer";
NSString * const  TeachingAssistantsListItemTitleCellIdentifer = @"TeachingAssistantsListItemTitleCellIdentifer";

NSString * const  TeachingAssistantsListItemImageContentCellIdentifer = @"TeachingAssistantsListItemImageContentCellIdentifer";

NSString * const  TeachingAssistantsListItemFooterCellIdentifer = @"TeachingAssistantsListItemFooterCellIdentifer";

NSString * const TeachingAssistantsListBigItemAudioCellIdentifier = @"TeachingAssistantsListBigItemAudioCellIdentifer";


#define KdefaultImageHeight  120
@interface TeachingAssistantsHomeworkListViewController ()<JFHomeworkTopicParseDelegate,ZFPlayerDelegate>
@property(nonatomic, strong) TeachingAssistantsDetailBottomView * bottomView;
@property(nonatomic, copy) NSString * bookId;
@property(nonatomic, copy) NSString * unitId;
@property(nonatomic, copy) NSString * bookName;
@property(nonatomic, copy) NSString * questionNum;
@property(nonatomic, strong) AssistantsQuestionModel * questionModel;
@property(nonatomic, strong) NSMutableArray * selectedIndexArray;//选中的题目
@property(nonatomic, strong) NSMutableArray * selectedParsingIndexArray;//选择的解析
@property(nonatomic, strong) NSArray * oldSelectedQuestionNumArray;//上一次选择的题号
@property (nonatomic, strong) NSMutableArray * statusArray;
@property (nonatomic, strong) NSMutableArray * imageHegithArray;
@property (nonatomic, strong) ZFPlayerView        *playerView;
@property (nonatomic, assign)  NSInteger      playerCurrentIndex;
@end

@implementation TeachingAssistantsHomeworkListViewController

- (instancetype)initWithBookId:(NSString *)bookId withBookName: (NSString *)bookName withUnitId:(NSString *)unitId withQuestionNum:(NSString *)questionNum withSelectedData:(NSArray *)selectedQuestionNumArray{
    if ( self == [super init]) {
        self.unitId = unitId;
        self.questionNum = questionNum;
        self.bookId = bookId;
        self.bookName = bookName;
        self.oldSelectedQuestionNumArray = selectedQuestionNumArray;
    }
    return self;
}
//折叠状态
-(NSMutableArray *)statusArray
{
   if (!_statusArray) {
        _statusArray = [NSMutableArray array];
    }
    [self initStatusArray];
    return _statusArray;
}
- (void)initStatusArray{
    NSInteger  sections =  1;
    if (self.questionModel.question.children) {
        sections = sections + [self.questionModel.question.children count];
    }else{
        sections = sections + 1;
    }
    
    if (_statusArray.count) {
        if (_statusArray.count > sections) {
            [_statusArray removeObjectsInRange:NSMakeRange(sections - 1, _statusArray.count - sections)];
        }else if (_statusArray.count < sections) {
            for (NSInteger i = sections - _statusArray.count; i <  sections; i++) {
                [_statusArray addObject:[NSNumber numberWithInteger:NO]];
            }
        }
    }else{
        for (NSInteger i = 0; i < sections; i++) {
            [_statusArray addObject:[NSNumber numberWithInteger:NO]];
        }
    }
}


- (NSMutableArray *)imageHegithArray{
    if (!_imageHegithArray) {
        _imageHegithArray = [NSMutableArray array];
        
    }
    [self initImageHegithArray];
    return _imageHegithArray;
}

- (void)initImageHegithArray{
    NSInteger  sections =  1;
    if (self.questionModel.question.children) {
        sections = sections + [self.questionModel.question.children count];
    }else{
        sections = sections + 1;
    }
    
    if (_imageHegithArray.count) {
        if (_imageHegithArray.count > sections) {
            [_imageHegithArray removeObjectsInRange:NSMakeRange(sections - 1, _imageHegithArray.count - sections)];
        }else if (_imageHegithArray.count < sections) {
            for (NSInteger i = sections - _imageHegithArray.count; i <  sections; i++) {
                [_imageHegithArray addObject:[NSNumber numberWithInteger:0]];
            }
        }
    }else{
        for (NSInteger i = 0; i < sections; i++) {
            [_imageHegithArray addObject:[NSNumber numberWithInteger:0]];
        }
    }
}
- (NSMutableArray *)selectedParsingIndexArray{
    if (!_selectedParsingIndexArray) {
        _selectedParsingIndexArray = [NSMutableArray array];
    }
    return _selectedParsingIndexArray;
}
- (NSMutableArray *)selectedIndexArray{
    if (!_selectedIndexArray) {
        _selectedIndexArray = [NSMutableArray array];
    }
    return _selectedIndexArray;
}
- (TeachingAssistantsDetailBottomView *)bottomView{
    
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([TeachingAssistantsDetailBottomView class]) owner:nil options:nil].firstObject;
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,  self.view.frame.size.width, 0.5)];
        lineView.backgroundColor = project_line_gray;
        [_bottomView addSubview:lineView];
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.bookName;
    [self.view addSubview:self.bottomView];
    self.view.backgroundColor = project_background_gray;
    
   id data =  [[NSUserDefaults standardUserDefaults] objectForKey:SAVE_JFHomework_Choose_Topic_Parsing];
    //判断是否有缓存
 
    if (!data) {
        //默认存入第一元素
         [self.selectedParsingIndexArray addObject:@(-1)];
    }else{
        
        NSDictionary * tempDic = data;
        NSArray *parsingIndexArray = tempDic[[self getUnitQuestionNumKey]];
        if (parsingIndexArray) {
            [self.selectedParsingIndexArray addObjectsFromArray:parsingIndexArray];
        }else{
            [self.selectedParsingIndexArray addObject:@(-1)];
        }
        
        
    }

    self.playerCurrentIndex = 0;
    [self configurationBottomView];
    [self requestTeacherQueryJFQuestion];
    [self setupNavigatioBarRight];
    [self configTableView];
    [self registerNotification];
}
- (void)registerNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"UPDATE_OTHER_PARSE" object:nil];
}
- (void)notificationAction:(NSNotification *)notifi{
    
    if (notifi.userInfo) {
        NSIndexPath * indexPath = notifi.userInfo[@"indexPath"];
        NSNumber *number = notifi.userInfo[@"selectedParseIndex"];
        [self chooseItmeIndex:indexPath withParsingIndex:[number integerValue]];
    }
}
- (void)configTableView{
   self.tableView.backgroundColor = [UIColor clearColor];
    // 隐藏UITableViewStyleGrouped上边多余的间隔
    self.view.backgroundColor = project_background_gray;
}

- (void)setupNavigatioBarRight{
    UIButton * editingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editingBtn setTitle:@"全选" forState:UIControlStateNormal];
    [editingBtn setTitle:@"取消" forState:UIControlStateSelected];
    [editingBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [editingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    [editingBtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    [editingBtn setFrame:CGRectMake(0, 5, 40,60)];
    editingBtn.titleLabel.font = fontSize_14;
 
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc]initWithCustomView:editingBtn];
    self.navigationItem.rightBarButtonItem = rightBar;
}
- (void)rightAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        NSInteger sections = self.tableView.numberOfSections;
       for (CGFloat i = 1; i<sections; i++) {
//            NSIndexPath * index = [NSIndexPath indexPathForRow:2 inSection:i];
//            [self.selectedIndexArray addObject:index];
           [self.selectedIndexArray addObject:@(i)];
        }
    }else{
        [self.selectedIndexArray removeAllObjects];
    }
    [self setupChooseItemNumber:[self.selectedIndexArray count]];
    [self updateTableView];
}

- (void)configurationBottomView{
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat bottomHeight = FITSCALE(50);
         CGFloat top = self.view.frame.size.height - bottomHeight;
        make.leading.mas_equalTo(self.view.mas_leading);
        make.trailing.mas_equalTo(self.view.mas_trailing);
        make.top.mas_equalTo(@(top));
        make.height.mas_equalTo(@(bottomHeight));
    }];
    [self.bottomView setupButtonTitle:@"确定"];
    
    if (self.oldSelectedQuestionNumArray) {
          [self setupChooseItemNumber:[self.oldSelectedQuestionNumArray count]];
    }else{
          [self setupChooseItemNumber:0];
    }
  
    WEAKSELF
    self.bottomView.sureBlock = ^{
        [weakSelf  saveChooseItem];
    };
}

- (void)setupChooseItemNumber:(NSInteger )number{
    [self.bottomView setupTitleNumber:[NSString stringWithFormat:@"%ld",number] withType:@"习题"];
}
#pragma mark ----
- (void)requestTeacherQueryJFQuestion{
    
    NSDictionary * parameterDic = nil;
    if (self.unitId && self.questionNum) {
        parameterDic = @{@"unitId":self.unitId,@"questionNum":self.questionNum};
    }
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherQueryJFQuestion] parameterDic:parameterDic requestMethodType:RequestMethodType_POST requestTag: NetRequestType_TeacherQueryJFQuestion];
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        if (request.tag == NetRequestType_TeacherQueryJFQuestion) {
            STRONGSELF
            strongSelf.questionModel =  [[AssistantsQuestionModel alloc]initWithDictionary:successInfoObj error:nil];
            if ([self.oldSelectedQuestionNumArray count] >0) {
                //选择中的题目回填
                [strongSelf setupBackfillIndexArray];
            }else{
                [strongSelf setupDefaultParsingIndexArray];
            }
            [strongSelf updateData];
            [strongSelf updateRightBtn];
           
        }
    }];
}



- (void)updateRightBtn{
     UIButton * btn = self.navigationItem.rightBarButtonItem.customView;
    if (!self.questionModel.question  ) {
        btn.hidden = YES;
    }
    if ([self.selectedIndexArray count] == self.tableView.numberOfSections -1) {
        btn.selected = YES;
    }else{
         btn.selected = NO;
    }
    
}
- (void)setupDefaultParsingIndexArray{
    if (self.questionModel.question.children) {
        NSInteger  i = 0;
        
        for (QuestionModel * model in self.questionModel.question.children) {
            NSInteger selectedParingIndex =  [self getParingIndex:model];
            [self.selectedParsingIndexArray addObject:@(selectedParingIndex)];
        
//                NSIndexPath * tempIndexPath =  [NSIndexPath indexPathForRow:0 inSection:i + 1];
//                [self.selectedIndexArray addObject: tempIndexPath];
            
            i++;
        }
    }else{
        NSInteger selectedParingIndex =  [self getParingIndex:self.questionModel.question];
        [self.selectedParsingIndexArray addObject:@(selectedParingIndex)];
//        NSIndexPath * tempIndexPath =  [NSIndexPath indexPathForRow:0 inSection:  1];
//            [self.selectedIndexArray addObject: tempIndexPath];
    }
    
}
- (void)setupBackfillIndexArray{
    if (self.questionModel.question.children) {
        NSInteger  i = 0;
        for (QuestionModel * model in self.questionModel.question.children) {
//            NSInteger selectedParingIndex =  [self getParingIndex:model];
//            [self.selectedParsingIndexArray addObject:@(selectedParingIndex)];
            if ([self.oldSelectedQuestionNumArray containsObject: model.questionNum ]) {
//                NSIndexPath * tempIndexPath =  [NSIndexPath indexPathForRow:0 inSection:i + 1];
                [self.selectedIndexArray addObject: @(i+1)];
            }
            i++;
        }
    }else{
//        NSInteger selectedParingIndex =  [self getParingIndex:self.questionModel.question];
//        [self.selectedParsingIndexArray addObject:@(selectedParingIndex)];
        if ([self.oldSelectedQuestionNumArray containsObject: self.questionModel.question.questionNum ]) {
//            NSIndexPath * tempIndexPath =  [NSIndexPath indexPathForRow:0 inSection:  1];
            [self.selectedIndexArray addObject: @(1)];
        }
    }
    
}

- (BOOL)validationIsAudio:(QuestionModel *)model{
    BOOL yesOrNo = NO;
    if (model.continuousAudios && [model.continuousAudios count]) {
        yesOrNo = YES;
    }else{
        if (model.singleAudios && [model.singleAudios count]) {
            yesOrNo = YES;
        }
    }
    return yesOrNo;
}
- (QuestionModel *)getQuesionModel:(NSInteger)section{
    
    QuestionModel * model = nil;
    if (self.questionModel.question.children) {
        model =  self.questionModel.question.children[section -1];
        
    }else{
        model =  self.questionModel.question;
    }
    return model;
}

//   优先选择我解析  次 原书解析  再其它老师
- (NSInteger)getParingIndex:(QuestionModel *)model{
    NSInteger selectedParingIndex =  -1;
     if (model.myAnalysis){
        selectedParingIndex = 2;
     }else if (model.analysis) {
         selectedParingIndex = 1;
     }else  if (model.otherAnalysis && [model.otherAnalysis count] > 0){
        selectedParingIndex = 3;
    }else{
        selectedParingIndex = -1;
    }
    return selectedParingIndex;
}
#pragma mark ---

- (UITableViewStyle)getTableViewStyle{
    
    return UITableViewStyleGrouped;
}
- (void)registerCell{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TeachingAssistantsListBigItemAudioCell   class]) bundle:nil] forCellReuseIdentifier:TeachingAssistantsListBigItemAudioCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TeachingAssistantsListItemTitleCell  class]) bundle:nil] forCellReuseIdentifier:TeachingAssistantsListItemTitleCellIdentifer];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TeachingAssistantsListItemImageContentCell  class]) bundle:nil] forCellReuseIdentifier:TeachingAssistantsListItemImageContentCellIdentifer];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TeachingAssistantsListItemFooterCell  class]) bundle:nil] forCellReuseIdentifier:TeachingAssistantsListItemFooterCellIdentifer];
     [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TeachingAssistantsListItemChooseCell   class]) bundle:nil] forCellReuseIdentifier:TeachingAssistantsListItemChooseCellIdentifer]; 
}

- (CGRect)getTableViewFrame{
    
    CGFloat bottomHeight = 0;
    bottomHeight = FITSCALE(50);
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - bottomHeight);
    return frame;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger  section = 0;
    if (self.questionModel) {
        if (self.questionModel.question.children) {
            section = 1 + [self.questionModel.question.children count];
        }else{
            section = 1 + 1;
        }
    }
   
    return section ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger row = 0;
    if (section == 0) {
        if ([self validationIsAudio:self.questionModel.question]) {
            if ([self.questionModel.question.singleAudios count] > 0) {
                row = [self.questionModel.question.singleAudios count];
            }else if ([self.questionModel.question.continuousAudios count] > 0){
                 row = [self.questionModel.question.continuousAudios count];
            }
        }
      
    }else{
        QuestionModel * model = [self getQuesionModel:section];
       row = 2 + [model.imgs count];
    }
    return row;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height =  0;
    if (indexPath.section == 0) {
        height = [self validationIsAudio:self.questionModel.question] ?FITSCALE(50) :FITSCALE(0);
    }else{
      QuestionModel * tempModel = [self getQuesionModel:indexPath.section];
        if (indexPath.row == 0) {
            height = FITSCALE(40);
        }else if (indexPath.row >=1 &&indexPath.row < 1 + [tempModel.imgs count]){
//            height =  [self getImgVHeight:tempModel atIndex:indexPath.row-1];
            height =  KdefaultImageHeight;
        }else{
            height =  FITSCALE(40);
        }
    }
    return height;
}
//获取 图片高
- (CGFloat)getImgVHeight:(QuestionModel *)model atIndex:(NSInteger)index{
    CGFloat imageVH = 0;
    NSString * coord = model.coords[index];
    if([coord containsString:@":"]){
        NSArray * tempArray = [coord componentsSeparatedByString:@":"];
        NSString * tempCoordStr = tempArray[1];
        if([tempCoordStr containsString:@";"]){
           NSArray *xyArray = [tempCoordStr componentsSeparatedByString:@";"];
            NSString *leftPoint = xyArray[0];
            NSString *rightPoint =xyArray[1];
            NSArray * leftPoints = [leftPoint componentsSeparatedByString:@","];
             NSArray * rightPoints = [rightPoint componentsSeparatedByString:@","];
            NSString *leftX = leftPoints[0];
            NSString *lefty = leftPoints[1];
            NSString *rightX = rightPoints[0];
            NSString *rightY = rightPoints[1];
            
            CGFloat imgW =  [rightX floatValue] - [leftX floatValue];
            CGFloat imgH =  [rightY floatValue] - [lefty floatValue];
            imageVH = (imgH/imgW)* self.view.frame.size.width;
            NSLog(@"%f==image",imageVH);
        }
    }
    return imageVH;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGFloat height = 0.00001;
    if (section == 0) {
        height = [self validationIsAudio:self.questionModel.question]?FITSCALE(20):height;
    }else{
      height = FITSCALE(15);
    }
    return height;
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 15)];
    footerView.backgroundColor = [UIColor clearColor];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2)];
    imageView.backgroundColor = [UIColor clearColor];
    [footerView addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"edge_shadow_img"];
   
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = FITSCALE(0.00001);
    if (section == 1) {
        height = [self validationIsAudio:self.questionModel.question]?height:FITSCALE(8);
    }
    return height;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headerView = [UIView new];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =  nil;
    if (indexPath.section == 0) {
        //大题音频标题
       cell = [self confightBigAudioTableView:tableView cellForRowAtIndexPath:indexPath];
        
    }else{
         QuestionModel * tempModel = [self getQuesionModel:indexPath.section];
        //标题
        if (indexPath.row == 0) {
            cell = [self confightItemSectionTableView:tableView cellForRowAtIndexPath:indexPath];
        }
        //图片
        else if ( indexPath.row >=1 &&indexPath.row <  1 + [ tempModel.imgs count]){
             cell = [self confightItemImageContentTableView:tableView cellForRowAtIndexPath:indexPath];
        }else  {
             cell = [self confightItemChooseTableView:tableView cellForRowAtIndexPath:indexPath];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark custom


- (UITableViewCell *)confightBigAudioTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
      TeachingAssistantsListBigItemAudioCell * tempCell = [tableView dequeueReusableCellWithIdentifier:TeachingAssistantsListBigItemAudioCellIdentifier];
      NSArray * tempArry = nil;
    if ( [self.questionModel.question.singleAudios count] >0) {
        tempArry  = self.questionModel.question.singleAudios;
    }else if([self.questionModel.question.continuousAudios count] >0){
         tempArry  = self.questionModel.question.continuousAudios;
    }
    tempCell.indexPath = indexPath;
    QuestionAnalysisAudioModel * model = tempArry [indexPath.row];
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


- (void)playOrPauseCell:(TeachingAssistantsListBigItemAudioCell *)cell withState:(BOOL) playBtnSelected atIndexPath:(NSIndexPath *)cellIndexPath{
    
    self.playerCurrentIndex = cellIndexPath.row;
    if (playBtnSelected) {
        NSIndexPath * playerIndexPath = [self.playerView getCurrentPlayerIndex];
        //当前点击的播放的语音是上次播放的 且为暂停状态
        if (playerIndexPath && [playerIndexPath compare: cellIndexPath] == NSOrderedSame &&self.playerView.isPauseByUser) {
            //暂停后点击播放
            [self.playerView play];
        }else{
            //开始播放
            NSArray * tempArray = [self getAudios];
            QuestionAnalysisAudioModel * model = tempArray[cellIndexPath.row];
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
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}
- (NSArray *)getAudios{
    
    NSArray * tempArry = nil;
    if ( [self.questionModel.question.singleAudios count] >0) {
        tempArry  = self.questionModel.question.singleAudios;
    }else if([self.questionModel.question.continuousAudios count] >0){
        tempArry  = self.questionModel.question.continuousAudios;
    }
    return tempArry;
}

- (UITableViewCell *)confightItemSectionTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    TeachingAssistantsListItemTitleCell  * tempCell = [tableView dequeueReusableCellWithIdentifier:TeachingAssistantsListItemTitleCellIdentifer];
     QuestionModel * tempModel = [self getQuesionModel:indexPath.section];
    
    [tempCell setupModel:tempModel];
    return  tempCell;
    
}


- (UITableViewCell *)confightItemImageContentTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeachingAssistantsListItemImageContentCell * tempCell = [tableView dequeueReusableCellWithIdentifier:TeachingAssistantsListItemImageContentCellIdentifer];
    QuestionModel * tempModel = [self getQuesionModel:indexPath.section];
//    CGFloat height =   [self getImgVHeight:tempModel atIndex:indexPath.row-1];
    CGFloat height = KdefaultImageHeight;
    BOOL state =  NO;
    if ([self.statusArray[indexPath.section] boolValue]) {
//        height = [self.imageHegithArray[indexPath.section] floatValue];
        state = YES;
    }
    tempCell.defaultHeight = height;
    tempCell.indexPath = indexPath;
    [tempCell setupButtonState:state];
    [tempCell setupModel:tempModel withImgHeight:height withIndex:indexPath.row - 1];
    tempCell.detailBlock = ^(NSIndexPath * index, CGFloat height) {
        [self gotoChooseParseVC:index];
    };
    return  tempCell;
    
}
- (UITableViewCell *)confightItemChooseTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    TeachingAssistantsListItemChooseCell * tempCell = [tableView dequeueReusableCellWithIdentifier:TeachingAssistantsListItemChooseCellIdentifer];
    QuestionModel * tempModel = [self getQuesionModel:indexPath.section];
    tempCell.indexPath = indexPath;
    tempCell.chooseBlock = ^(NSIndexPath * indexPath) {
        [self changeSelectedState:indexPath];
        [self updateData];
    };
    BOOL  chooseSate = NO;
    if ([self.selectedIndexArray containsObject:@(indexPath.section)]) {
        chooseSate = YES;
    }
    [tempCell setupModel:tempModel isChoose:chooseSate];
    return  tempCell; 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
      
    }else{
        
        [self gotoChooseParseVC:indexPath];
    }
}

- (NSArray *)getPlayAudioUrls{
    
    NSMutableArray * urlAudioArray = [NSMutableArray array];
    if (self.questionModel.question.continuousAudios) {
        for (QuestionAnalysisAudioModel * audioModel in self.questionModel.question.continuousAudios) {
            [ urlAudioArray addObject: audioModel.voice];
        }
    }else{
        if (self.questionModel.question.singleAudios) {
            for (QuestionAnalysisAudioModel * audioModel in self.questionModel.question.singleAudios) {
                [ urlAudioArray addObject: audioModel.voice];
                
            }
        }
    }
    return urlAudioArray;
}


- (void)resetLoadTableView:(NSIndexPath *)index{
    
    BOOL currentIsOpen = ((NSNumber *)self.statusArray[index.section]).boolValue;
    NSInteger sections  =  self.tableView.numberOfSections;
    for (NSInteger i = 0; i < sections; i++) {
        [_statusArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
    }
    [self.statusArray replaceObjectAtIndex:index.section withObject:[NSNumber numberWithBool:!currentIsOpen]];
    [self.tableView reloadData];
}


- (void)changeSelectedState:(NSIndexPath *)indexPath{
    
    //添加删除 选择
    if ([self.selectedIndexArray containsObject:@(indexPath.section)]) {
        [self.selectedIndexArray removeObject:@(indexPath.section)];
    }else{
        [self.selectedIndexArray addObject:@(indexPath.section)];
    }
    NSInteger selectedParingIndex = -1;
    if (self.selectedParsingIndexArray[indexPath.section]) {
        selectedParingIndex = [self.selectedParsingIndexArray[indexPath.section ] integerValue];
    }else{
        QuestionModel * tempModel = [self getQuesionModel:indexPath.section];
        selectedParingIndex =  [self getParingIndex:tempModel];
    }
    
     [self chooseItmeIndex:indexPath withParsingIndex:selectedParingIndex];
    //是否全选按钮
    [self updateRightBtn];
    
}
- (void)updateData{
    [self setupChooseItemNumber:[self.selectedIndexArray count]];
    [self updateTableView];
}

//完善解析
- (void)gotoWrittenParseVC:(NSIndexPath *)indexPath{
    
    id model = [self getQuesionModel:indexPath.section];
    WrittenParseViewController * writtentParseVC = [[WrittenParseViewController alloc]initWithBookId:self.bookId withBookName:self.bookName withModel:model];
    [self pushViewController:writtentParseVC];
}
//选着解析
- (void)gotoChooseParseVC:(NSIndexPath *)indexPath{
    id model = [self getQuesionModel:indexPath.section];
    NSInteger selectedindex = -1;
    if ([self.selectedParsingIndexArray count] > 0) {
        selectedindex = [self.selectedParsingIndexArray[indexPath.section] integerValue];
    }
 
    JFHomeworkTopicDetailViewController *topicDetailVC = [[JFHomeworkTopicDetailViewController alloc]initWithBookId:self.bookId withBookName:self.bookName withModel:model withSelectedIndex:selectedindex];
    topicDetailVC.delegate = self;
    topicDetailVC.seletedChangePareTopicIndexPath = indexPath;
    [self pushViewController:topicDetailVC];

}


#pragma mark --ChooseParseDelegate-
- (void)chooseItmeIndex:(NSIndexPath *)indexPath withParsingIndex:(NSInteger)selectedIndex{
     [self.selectedParsingIndexArray replaceObjectAtIndex:indexPath.section withObject:@(selectedIndex)];
     NSMutableDictionary * dic =   [NSMutableDictionary dictionary];
    NSDictionary * parsingDic = [[NSUserDefaults standardUserDefaults] objectForKey:SAVE_JFHomework_Choose_Topic_Parsing];
    if (parsingDic) {
          [dic addEntriesFromDictionary: parsingDic];
    }
     [dic setObject:self.selectedParsingIndexArray forKey: [self getUnitQuestionNumKey]];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey: SAVE_JFHomework_Choose_Topic_Parsing];
}
- (NSString *)getUnitQuestionNumKey{
    NSString * key = [self.unitId stringByAppendingString:self.questionNum];
    
    return key;
}
#pragma mark ---
- (void)saveChooseItem{
 
    NSArray * questions = [self getSelectedQuestions];
    NSDictionary * unitHomework = nil;
    if (questions.count > 0) {
        unitHomework = @{@"unitId": self.questionModel.question.unitId,@"questions":questions};
        
    }
    NSString * questionNum = [self getQuestionsNum];
   
    if ([self.delegate respondsToSelector:@selector(chooseAssistantsHomewrok: withAllQuestions:withQuestionNum:)]) {
        [self.delegate chooseAssistantsHomewrok: unitHomework withAllQuestions:[self.selectedIndexArray count] withQuestionNum:questionNum];
    }
    [super backViewController];
}


- (void)backViewController{
     [self saveChooseItem];
//    [super backViewController];
//    if ([self.selectedIndexArray count]==0) {
//        [self clearSelectedData];
//        return;
//    }
//    WEAKSELF
//    NSArray * items = @[MMItemMake(@"否", MMItemTypeNormal, ^(NSInteger index) {
//        [weakSelf clearSelectedData];
//    }),
//                        MMItemMake(@"是", MMItemTypeNormal, ^(NSInteger index) {
//                            [weakSelf saveChooseItem];
//                        })];
//    [self showNormalAlertTitle:@"温馨提示" content:@"是否保留选择的题" items:items block:nil];

}

- (void)clearSelectedData{
    [self.selectedIndexArray removeAllObjects];
//    [self resetSelectedIndexPath];
    [self saveChooseItem];
}
//重置选择的题
- (void)resetSelectedIndexPath{
    if (self.questionModel.question.children) {
        for (int i = 0;i< [self.questionModel.question.children count] ;i++) {
//            NSIndexPath * tempIndexPath =  [NSIndexPath indexPathForRow:2 inSection:i+1];
            QuestionModel * model = self.questionModel.question.children[i];
            if ([self.oldSelectedQuestionNumArray containsObject: model.questionNum]) {
                [self.selectedIndexArray addObject:@(i+1)];
            }
        }
    }else{
        if ([self.oldSelectedQuestionNumArray containsObject:self.questionModel.question.questionNum]) {
//            NSIndexPath * index = [NSIndexPath indexPathForRow:2 inSection:1];
            [self.selectedIndexArray addObject: @(1)];
        }
    }
}
- (NSString *)getQuestionsNum{
    NSString * questionNum = @"";
    if (self.questionModel.question.children && self.questionModel.question.children.count > 0) {
        QuestionModel * model = self.questionModel.question.children.firstObject;
        if ([model.questionNum containsString:@"."]) {
            questionNum =  [model.questionNum componentsSeparatedByString:@"."][0];
        }
    }else{
        questionNum =  self.questionModel.question.questionNum;
    }
    return questionNum;
}
- (NSArray *)getSelectedQuestions{
    
    NSMutableArray *questions = [NSMutableArray array];
    if (self.questionModel.question.children) {
        for (int i = 0;i< [self.questionModel.question.children count] ;i++) {
//            NSIndexPath * tempIndexPath =  [NSIndexPath indexPathForRow:2 inSection:i+1];
            if ([self.selectedIndexArray containsObject:@(i+1)]) {
                QuestionModel * model = self.questionModel.question.children[i];
                NSDictionary * tempDic =[ NSJSONSerialization  JSONObjectWithData:[model toJSONData] options:NSJSONReadingAllowFragments error:nil] ;
                [questions addObject: [self setupQuestionsItem:tempDic  withModel:model atIndex:i+1]];
            }
        }
    }else{
        if (self.selectedIndexArray.count > 0) {
            NSDictionary * tempDic =[ NSJSONSerialization  JSONObjectWithData:[self.questionModel.question toJSONData] options:NSJSONReadingAllowFragments error:nil] ;
            [questions addObject: [self setupQuestionsItem:tempDic  withModel:self.questionModel.question  atIndex:1]];
        }
        
    }
    return questions;
    
}
// tempDic 操作的数据json对象取出题号  model解析对象 用于取解析文字和解析图片    index 要取得解析的下标
-(NSDictionary  *)setupQuestionsItem:(NSDictionary *)tempDic withModel:(QuestionModel *)model atIndex:(NSInteger)index{
    
    NSMutableDictionary *questionDic = [NSMutableDictionary dictionary];
    [questionDic addEntriesFromDictionary: @{@"questionNum":tempDic[@"questionNum"]}];
    
    if (self.selectedParsingIndexArray.count >1) {
        NSInteger parsingSelectedIndex = [self.selectedParsingIndexArray[index] integerValue];
        NSDictionary * analysisDic = nil;
        NSDictionary * analysisPicDic = nil;
        NSDictionary * analysisTypeDic = nil;
        NSDictionary * analysisProviderIdDic = nil;
        if (parsingSelectedIndex == -1) {
            //无解析
        }else if(parsingSelectedIndex == 1){
            //原书解析
//            analysisDic = [self getAnalysisDic:model.analysis];
//            analysisPicDic = [self getAnalysisPicDic:model.analysis];
//            analysisDic = @{@"analysis":model.analysis};
            analysisTypeDic = @{@"analysisType":@"bookAnalysis"};
        }else if(parsingSelectedIndex == 2){
            //我的解析
            analysisDic = [self getAnalysisDic:model.myAnalysis];
            analysisPicDic = [self getAnalysisPicDic:model.myAnalysis];
             analysisTypeDic = @{@"analysisType":@"myAnalysis"};
        }else{
            //其它
            if (model.otherAnalysis.count > 0) {
                analysisDic = [self getAnalysisDic:model.otherAnalysis[parsingSelectedIndex -3]];
                analysisPicDic = [self getAnalysisPicDic:model.otherAnalysis[parsingSelectedIndex -3]];
                 analysisTypeDic = @{@"analysisType":@"otherAnalysis"};
                analysisProviderIdDic = [self getAnalysisProviderId:model.otherAnalysis[parsingSelectedIndex -3]];
            }
           
        }
        
        if (analysisDic) {
            [questionDic addEntriesFromDictionary:  analysisDic];
        }
        if (analysisPicDic) {
            [questionDic addEntriesFromDictionary: analysisPicDic];
        }
        if (analysisTypeDic) {
            [questionDic addEntriesFromDictionary:analysisTypeDic];
        }
        if (analysisProviderIdDic) {
            [questionDic addEntriesFromDictionary:analysisProviderIdDic];
        }
    }
    
    
    return questionDic;
}
- (NSDictionary *)getAnalysisDic:(QuestionAnalysisModel *)model{
    NSDictionary * analysisDic = nil ;
    NSString * analysis  =  model.analysis;
    
    if (analysis) {
        analysisDic = @{@"analysis":analysis};
    }
    return analysisDic;
    
}
- (NSDictionary *)getAnalysisPicDic:(QuestionAnalysisModel *)model{
    NSDictionary * analysisPicDic = nil ;
    NSString * analysisPic  =  model.analysisPic;
    
    if (analysisPic) {
        analysisPicDic = @{@"analysisPic":analysisPic};
    }
    return analysisPicDic;
    
}
- (NSDictionary *)getAnalysisProviderId:(QuestionAnalysisModel*)model{
    NSDictionary * analysisPicDic = nil ;
    NSString * analysisProviderId  =  model.teacherId;
    
    if (analysisProviderId) {
        analysisPicDic = @{@"analysisProviderId":analysisProviderId};
    }
    return analysisPicDic;
    
}
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
// 页面消失时候
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playerView resetPlayer];
}

#pragma mark -delegate
- (void)saveSelectedImageIndex:(NSIndexPath *)index withImageHeight:(CGFloat)height{
    
    [self.imageHegithArray replaceObjectAtIndex:index.section withObject:@(height)];
}

- (void)updateListData{ 
    [self requestTeacherQueryJFQuestion];
}
#pragma mark --

/**
 * 协议中的方法，获取返回按钮的点击事件
 */
- (BOOL)navigationShouldPopOnBackButton
{
    return NO;
    
}
@end

