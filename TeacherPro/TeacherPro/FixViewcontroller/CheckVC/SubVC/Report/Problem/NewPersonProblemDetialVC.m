//
//  NewPersonProblemDetialVC.m
//  TeacherPro
//
//  Created by 何学杰 on 2019/1/24.
//  Copyright © 2019 ZNXZ. All rights reserved.
//

#import "NewPersonProblemDetialVC.h"
#import "NewProblemDetialView.h"
#import "LXReportSoundBottom.h"

@interface NewPersonProblemDetialVC ()

@property (nonatomic ,strong) NewProblemDetialView *detialView;
@property (nonatomic ,strong) LXReportSoundBottom *bottomView;

@end

@implementation NewPersonProblemDetialVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationItemTitle:@"题目解析"];
    
    _detialView =  [[NewProblemDetialView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,self.view.frame.size.height-46)];
    [self.view addSubview:_detialView];
    _detialView.frame = CGRectMake(0, 0, kScreenWidth,self.view.frame.size.height-46);
    _detialView.backgroundColor = [UIColor redColor];
    
    _bottomView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LXReportSoundBottom class]) owner:nil options:nil].firstObject;
    //   LXReportSoundBottom
    [_bottomView.fontButton addTarget:self action:@selector(fontButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView.nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _bottomView.backgroundColor =HexRGB(0xffffff);
    _bottomView.frame = CGRectMake(0, self.view.frame.size.height-46, kScreenWidth,46);
    [self.view addSubview:_bottomView];
    
     [self requestListHomeworkStudents];
}

#pragma mark - click
- (void)fontButtonClick:(UIButton *)button{
    if (button.selected == YES) {
        return;
    }
    self.currentSelected = self.currentSelected-1;
    [self reloadHeaderBottom];
//    [self requestListHomeworkStudents];
}
- (void)nextButtonClick:(UIButton *)button{
    if (button.selected == YES) {
        return;
    }
    self.currentSelected = self.currentSelected+1;
    [self reloadHeaderBottom];
//    [self requestListHomeworkStudents];
}
#pragma mark - request

- (void)requestListHomeworkStudents{
    if (!_parameterDic) {
        return;
    }
 
    [self  sendHeaderRequest:@"QueryStudentPhonicsCartoonPractices" parameterDic:_parameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_Personproblem];
}

- (void)setNetworkRequestStatusBlocks{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        STRONGSELF
        if (request.tag == NetRequestType_Personproblem) {
            weakSelf.Items = successInfoObj[@"quests"];
            [weakSelf reloadHeaderBottom];
//            if (weakSelf.Items.count>weakSelf.currentSelected) {
//                weakSelf.dataDic = weakSelf.Items[weakSelf.currentSelected];
//            }
        }
    }];
}

- (void)reloadHeaderBottom{
   
    if (self.Items.count>self.currentSelected) {
        self.dataDic = self.Items[self.currentSelected];
    
        _bottomView.pageBottomLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.currentSelected+1,self.Items.count];
        _detialView.dataDic = self.dataDic;
        
        _bottomView.fontButton.selected = NO;
        _bottomView.nextButton.selected = NO;
        if (self.currentSelected == 0) {
            _bottomView.fontButton.selected = YES;
        }else if(self.currentSelected == self.Items.count-1){
            _bottomView.nextButton.selected = YES;
        }
    }
}
@end
