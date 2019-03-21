
//
//  WriteViewController.m
//  TeacherPro
//
//  Created by DCQ on 2017/6/25.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "WriteMessageViewController.h"
#import "RecipientViewController.h"
#import "WriteMessageRecipientCell.h"
#import "ReceuvedMessageModel.h"
#import "SessionModel.h"
#import "SessionHelper.h"
#import "UploadFileModel.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "TZImagePickerController.h"
#import "IQKeyboardManager.h"

NSString * const WriteMessageRecipientCellIdentifier =  @"WriteMessageRecipientCellIdentifier";

@interface WriteMessageViewController ()

//  @{@"student":students,@"teacher":teachers};
@property(nonatomic, strong) NSDictionary * recipientDic;
@property(nonatomic, strong) NSDictionary * selectedIndexDic;
@end

@implementation WriteMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItemTitle:@"写消息"];
    [self setupNavigationRightbar];
    
    [self navUIBarBackground:0];
}
- (void)registerCell{

    [super registerCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WriteMessageRecipientCell class]) bundle:nil] forCellReuseIdentifier:WriteMessageRecipientCellIdentifier];
}
- (void)setupNavigationRightbar{
    UIButton * releaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [releaseBtn setTitle:@"发送" forState:UIControlStateNormal];
    [releaseBtn setTitleColor:HexRGB(0x4d4d4d) forState:UIControlStateNormal ];
    [releaseBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [releaseBtn setFrame:CGRectMake(0, 5, 40,60)];
    [releaseBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
     releaseBtn.titleLabel.font = fontSize_14;
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc]initWithCustomView:releaseBtn];
    self.navigationItem.rightBarButtonItem = rightBar;
    
}

- (void)sendAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    sender.enabled = NO;
    if (sender.selected) {
         [self sendMessage];
    }
   
    
}


- (void)gotoRecipientVC{

   
    RecipientViewController * recipientVC = [[RecipientViewController alloc]initWithSelectedIndexDic:self.selectedIndexDic];
    WEAKSELF
    recipientVC.recipientBlock = ^(NSDictionary *recipientInfo,NSDictionary * indexDic) {
        STRONGSELF
        strongSelf.recipientDic = recipientInfo;
        strongSelf.selectedIndexDic = indexDic;
        [strongSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:ReleaseHomeworkSectionType_complete] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self pushViewController:recipientVC];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell;
    
    if (indexPath.section == ReleaseHomeworkSectionType_complete) {
        
        WriteMessageRecipientCell * tempCell = [tableView dequeueReusableCellWithIdentifier:WriteMessageRecipientCellIdentifier];
        tempCell.selectionStyle =  UITableViewCellSelectionStyleNone;
        tempCell.addRecipinetBlock = ^{
            [self gotoRecipientVC];
        };
        NSArray * students = self.recipientDic[@"student"];
        NSArray * teachers = self.recipientDic[@"teacher"];
        NSString * teacherName = @"";
        for (ReceuvedTeacherContacts * teacher  in teachers) {
            if (teacherName.length >0) {
                teacherName = [teacherName stringByAppendingFormat:@",%@",teacher.teacherName];
            }else{
            
                teacherName = teacher.teacherName;
            }
        }
        NSString * studentName = @"";
        for (StudentsModel * stu  in students) {
            if (studentName.length >0) {
                studentName = [studentName stringByAppendingFormat:@",%@",stu.studentName];
            }else{
                
                studentName = stu.studentName;
            }
        }
        
        NSString * contentStr = @"";
        if (teacherName.length >0) {
            if (studentName.length >0) {
                contentStr = [NSString stringWithFormat:@"老师(%@),学生(%@)",teacherName,studentName];
            }else{
               contentStr = [NSString stringWithFormat:@"老师(%@)",teacherName];
            }
            
        }else{
            if (studentName.length > 0) {
               contentStr = [NSString stringWithFormat:@"学生(%@)",studentName];
            }else{
            
               contentStr = [NSString stringWithFormat:@"请选择收件人"];
            }
            
        }
        
        [tempCell setupContent:contentStr];
        cell = tempCell;
        
    }else{
    
        cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger row = 0;
    if (section ==  ReleaseHomeworkSectionType_complete) {
        row = 1 ;
    }else{
    
        row = [super tableView:tableView numberOfRowsInSection:section];
    }
    return row;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == ReleaseHomeworkSectionType_complete) {
         [self gotoRecipientVC];
    }else{
    
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
 
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    //从选中中取消
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
- (NSString *)getTeacherContactIds{

    NSString * teacherIds = @"";
    for (ReceuvedTeacherContacts * teacher in self.recipientDic[@"teacher"]) {
        if (teacherIds.length == 0) {
            teacherIds = [teacherIds stringByAppendingString:teacher.teacherId];
        }else{
            teacherIds = [teacherIds stringByAppendingString:[NSString stringWithFormat:@",%@",teacher.teacherId]];
        }
        
    }
    return teacherIds;
}

- (NSString *) getStudentContactsIds{

    NSString * stuIds = @"";
    for (StudentsModel * stu in self.recipientDic[@"student"]) {
        if (stuIds.length == 0) {
            stuIds = [stuIds stringByAppendingString:stu.studentId];
        }else{
            stuIds = [stuIds stringByAppendingString:[NSString stringWithFormat:@",%@",stu.studentId]];
        }
        
    }
    return stuIds;
}
#pragma mark --

- (void)sendMessage{

    [[IQKeyboardManager sharedManager] resignFirstResponder];
    //清空上次选择的上传成功后的数据
    self.uplaodImageModel = nil;
    self.uplaodAudioModel = nil;
    
  
    NSString *  teacherContactIds = [self getTeacherContactIds];
    NSString *  studentContactIds = [self getStudentContactsIds];
    
    if ([teacherContactIds length] == 0 && [studentContactIds length] == 0) {
        NSString * title = @"温馨提示";
        NSString * content = @"请您选择收件人";
        NSArray *items =
        @[MMItemMake(@"确定", MMItemTypeHighlight, nil
                     )];
        [self showNormalAlertTitle:title content:content items:items block:nil];
        [self enabldSenderBtn];
        return;
    }
 
    
    if ([self.selectedAssets count] >0) {
        [self uploadImgV];
    }else if ([self.selectedAssets count] == 0 && [self.selectedVoice count] >0){
        
        [self uploadAudio];
    }else if ([self.selectedVoice count] == 0 && [self.selectedAssets count] ==0){
        
        [self requestSendInfo];
    }
}
- (void)enabldSenderBtn{
    
    UIButton * releaseBtn = self.navigationItem.rightBarButtonItem.customView;
    releaseBtn.selected = NO;
    releaseBtn.enabled = YES;
}

- (void)requestSendInfo{

    NSMutableDictionary  *requestParameterDic = [NSMutableDictionary dictionary];
    NSString *  teacherContactIds = [self getTeacherContactIds];
    NSString *  studentContactIds = [self getStudentContactsIds];
    
    if (teacherContactIds.length >0) {
        [requestParameterDic addEntriesFromDictionary:@{@"teacherContacts":teacherContactIds}];
        
    }
    if (studentContactIds.length >0) {
        [requestParameterDic addEntriesFromDictionary:@{@"studentContacts":studentContactIds}];
        
    }
    NSString * text = @"";
    NSString * voice = @"";
    NSString * totalLength = @"";
    NSString * images = @"";
    
  
    if (!self.uplaodAudioModel && !self.uplaodImageModel && [self.inputContentArrays count] == 0) {
        
        NSString * title = @"温馨提示";
        NSString * content = @"请您填写消息内容";
        NSArray *items =
        @[MMItemMake(@"确定", MMItemTypeHighlight, nil
                     )];
        [self showNormalAlertTitle:title content:content items:items block:nil];
        [self enabldSenderBtn];
        return;

    }
    //用户没输入文字添加默认文字
    if ([self.inputContentArrays count] ==0 ) {
        if ([self.selectedVoice count] > 0 && [ self.selectedPhotos count] >0) {
            text = @"您发送了一条语音,图片消息";
        }else if ([self.selectedVoice count] > 0&& [ self.selectedPhotos count] == 0){
            text = @"您发送了一条语音消息";
        }else if ([self.selectedVoice count] == 0 && [ self.selectedPhotos count] >0){
            text = @"您发送了一条图片消息";
        }
        [requestParameterDic addEntriesFromDictionary:@{@"content":text}];
    }else {
        
        if ([self.contentType  isEqualToString:@"00"]) {
            text = [self.inputContentArrays componentsJoinedByString:@"\n"];
          
        }else if ([self.contentType isEqualToString:@"01"]){
            
            for (int i = 0; i<[self.inputContentArrays count]; i++) {
                NSString * newline = @"\n";
                if (i ==0) {
                    newline = @"";
                }
                text = [text stringByAppendingString:[NSString stringWithFormat:@"%@%zd: %@",newline,i+1,self.inputContentArrays[i]]] ;
                
            }
            
        }
          [requestParameterDic addEntriesFromDictionary:@{@"content":text}];
    }

    if (self.uplaodAudioModel) {
        voice = [self.uplaodAudioModel.visitUrls allValues][0];
        [requestParameterDic addEntriesFromDictionary:@{@"voice": voice}];
    }
    if (self.totalLength > 0) {
        totalLength = [NSString stringWithFormat:@"%zd",self.totalLength];
        [requestParameterDic addEntriesFromDictionary:@{@"voiceDuration":totalLength}];
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
            
            if ([images length] <=0) {
                images = [self.uplaodImageModel.visitUrls objectForKey:fileName];
            }else{
                images = [NSString stringWithFormat:@"%@,%@",images,[self.uplaodImageModel.visitUrls objectForKey:fileName]];
            }
            
        }
        
        [requestParameterDic addEntriesFromDictionary:@{@"images":images}];
    }
  
    [self sendHeaderRequest:[NetRequestAPIManager getRequestURLStr:NetRequestType_TeacherSendNotify] parameterDic:requestParameterDic requestMethodType:RequestMethodType_POST requestTag:NetRequestType_TeacherSendNotify];
    
}
- (void)setNetworkRequestStatusBlocks{

    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
       STRONGSELF
        if (request.tag == NetRequestType_TeacherSendNotify) {
           
            [strongSelf showAlert:TNOperationState_OK content:@"发送成功" block:^(NSInteger index) {
                if (strongSelf.sucessSendBlock) {
                    strongSelf.sucessSendBlock();
                }
                [strongSelf backbackAction];
            }];
        }
       
    }];
}

- (void)backbackAction{
    NSArray *viewControllers = [self.navigationController viewControllers];
    
    // 根据viewControllers的个数来判断此控制器是被present的还是被push的
    if (1 <= viewControllers.count && 0 < [viewControllers indexOfObject:self])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
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
            
            [self requestSendInfo];
         
        }
        
    }else if (request.tag == NetRequestType_HomeworkUploadAudio){
        self.uplaodAudioModel = [[UploadFileModel alloc]initWithDictionary:infoObj error:nil];
         [super hideHUD];
        [self requestSendInfo];
        
    }else if (request.tag == NetRequestType_TeacherSendNotify){
        
        [super netRequest:request successWithInfoObj:infoObj];
    }
}


//- (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error
//{
//    
////    if (request.tag == NetRequestType_HomeworkUploadImage) {
////        
////        
////        if ([self.selectedVoice count]> 0) {
////            [self uploadAudio];
////        }else{
////            [self requestSendInfo];
////            
////        }
////        
////    }else if (request.tag == NetRequestType_HomeworkUploadAudio){
////        
////        [self requestSendInfo];
////        
////    }else if (request.tag == NetRequestType_TeacherSendNotify){
////        
//        [super netRequest:request failedWithError:error];
////    }
//    
//}
@end
