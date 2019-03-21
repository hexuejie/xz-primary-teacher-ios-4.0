//
//  NetRequestAPIManager.m
//  TeacherPro
//
//  Created by DCQ on 2017/4/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "NetRequestAPIManager.h"

@implementation NetRequestAPIManager
+ (NSString *)getRequestURLStr:(NetRequestType )requestType
{
    // 与"NetProductRequestType"一一对应
    static NSMutableArray *urlForTypeArray = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        urlForTypeArray = [NSMutableArray arrayWithObjects:
                           
                           /***************************************************************/
                           //教师登录
                           @"TeacherLogin",
                           
                           //教师退出
                           @"TeacherLoginOut",
                           
                           //教师注册
                           @"TeacherRegister",
                           
                           //教师注册验证码
                           @"TeacherSendAuthCode",
                           
                           //教师注册填写个人信息
                           @"TeacherUpdateName",
                           
                           //教师重置密码
                           @"TeacherResetPassword",
                           
                           //教师忘记密码验证码
                           @"TeacherSendAuthCode",
                           
                           //教师解散班级
                           @"TeacherSendAuthCode",
                           //城市的所有学校
                           @"QuerySchoolByCityName",
                           
                           //设置教师的学校
                           @"SetTeacherSchool",
                           
                           //查询省行政区域
                           @"QueryCity",
                           
                           //查询市行政区域
                           @"QueryCity",
                           
                           
                           //查询市所在的省 下的所有市区（市名查询）
                           @"ListCityByName",
                           
                           //通过学校名称搜索学校列表
                           @"ListSchoolByName",
                           
                           //查询教师绑定的班级列表
                           @"QueryTeacherBindClazzs",
                           
                           //教师退出班级
                           @"TeacherQuitClazz",
                           
                           //查询科目
                           @"QueryDictionary",
                           
                           //教师创建一个班级
                           @"TeacherCreateClazz",
                           
                           //查询指定班级的老师
                           @"QueryClazzTeachers",
                           
                           //查询指定班级的学生列表
                           @"ListStudentByClazzId",
                           
                           //教师转让班级
                           @"TeacherTransferClazz",
                           
                           //教师解散自己的班级
                           @"TeacherDisbandClazz",
                           
                           //教师加入指定班级
                           @"TeacherAddToClazz",
                           
                           //教师更新用户信息
                            
                           @"TeacherUpdateClazSubject",
                           
                           //根据手机号码查询教师绑定的班级列表
                           @"QueryTeacherClazzByPhone",
                           
                           //教师转让班级管理员权限
                           @"TeacherTransferAdminTeacher",
                           
                           //教师更换学生班级(仅仅限同一教师下班级的更换)
                           @"TeacherUpdateStudentClazz",
                           
                           //  教师移除自己班级下的学生
                           @"TeacherRemoveStudent"         ,
                           
                           //管理员移除班级下的老师
                           @"TeacherRemoveClazzTeacher",
                           
                           //查询教师绑定的班级列表（按班级进行分组）
                           @"QueryTeacherBindClazzsAndGroup",
                           
                           //查询反馈方式
                           @"QueryHomeworkFeedback",
                           //教师布置作业
                           @"TeacherAssignHomework",
                           //布置作业上传图片(自定义的 随意修改 不影响接口)
                           @"HomeworkUploadImage",
                           //布置作业上传音频(自定义的 随意修改 不影响接口)
                           @"HomeworkUploadAudio",
                           
                           //教师申请加入指定班级(只发出申请，没有实际加入)
                           @"TeacherApplyAddToClazz",
                           //邀请老师加入班级(只发出邀请，没有实际加入)
                           @"InviteTeacherJoinClazz",
                           //教师处理邀请
                           @"TeacherHandleInvite",
                           // 教师给指定班级群发通知
                           @"TeacherSendNotifyToClazz",
                           //老师收到的消息汇总
                           @"TeacherNotifyRecvSummary",
                           
                           //教师绑定clientId
                           @"TeacherBindClientId",
                           
                           //教师处理通知
                           @"TeacherHandleNotify",
                           
                           //老师消息面板-消息汇总
                           @"TeacherNotifySummary",
                           
                           //教师指定联系人发送消息
                           @"TeacherSendNotify",
                           
                           //联系人列表
                           @"ListNofityContacts",
                           
                           //教师通知发送记录
                           @"ListTeacherNotificationSend"                   ,
                           
                           //教师接收到的通知记录
                           @"ListTeacherNotificationRecv"                   ,
                           
                           //删除老师通知
                           @"DeleteTeacherNotify"                           ,
                           
                           //删除发送 消息
                           @"DeleteTeacherSendNotify"                       ,
                           
                           //意见反馈 （随意填写 接口不取值 只是暂用位置）
                           @"ClientSubmitFeedbackDetails"                   ,
                           //查询教师货币流水
                           @"ListTeacherChangeLog"                          ,
                           
                           //查询教师布置的作业记录
                           @"ListTeacherHomeworks"                          ,
                           
                           //老师催缴作业
                           @"TeacherCallHomework"                            ,
                           
                           //查询指定作业内容
                           @"QueryHomeworkContent"                           ,
                           
                           //查询指定作业的学生反馈信息
                           @"QueryHomeworkStudentFeedbacks"                  ,
                           
                           //查询学生指定作业得分详情
                           @"QueryStudentHomeworkScore"                         ,
                           
                           //查询指定作业成绩榜
                           @"ListHomeworkStudentScore"                          ,
                           
                           //教师点评作业
                           @"TeacherRemarkHomework"                             ,
                           
                           //查询学生作业子项试题得分明细
                           @"QueryStudentHomeworkTypeQuestScore"                ,
                           
                           // 查询指定教师的感恩币数量
                           @"QueryTeacherCoin"                                  ,
                           
                           //教师更新密码
                           @"TeacherUpdatePassword"                             ,
                           
                           //教师更新用户名
                           @"TeacherUpdateName"                                 ,
                           
                           //查询学生指定月份的作业日历
                           @"QueryStudentHomeworkCalendar"                      ,
                           
                           //查询老师指定月份的作业回顾
                           @"QueryTeacherHomeworkMonthReview"                   ,
                           
                           
                           //查询教师指定日期的作业记录
                           @"ListTeacherHomeworkByDay"                          ,
                           
                           //教师下发验证码
                           @"TeacherSendAuthCode"                               ,
                           
                           // 验证解绑手机的验证码
                           @"TeacherValidateAuthCode"           ,
                           
                           //修改手机号码绑定发送验证码
                           @"TeacherSendAuthCode" ,
                           
                           // 验证绑定手机的验证码
                           @"TeacherValidateAuthCode",
                           //重置老师手机号码
                           @"ResetTeacherPhone",
                           
                           //查询指定教师是否存在绑定的班级
                           @"QueryTeacherExistsClazz",
                           
                           //查询绘本每页的预览信息
                           @"QueryCartoonPages",
                           
                           //查询班级正在申请加入的教师
                           @"QueryClazzJoiningTeachers",
                           
                           //通过手机号码查询指定教师信息
                           @"QueryTeacherByPhone",
                           
                           // 查询指定教师信息
                           @"QueryTeacherById",
                           
                           // 老师查询申请班级记录
                           @"ListTeacherApplyClazzHistory",
                           //老师向申请的班级发起催促通知
                           @"TeacherCallApplyAddClazz",
                           //老师修改图像
                           @"TeacherUpdateAvatar",
                           //老师上传图片文件（自定义）
                           @"TeacherUploadImage",
                           //   查询教师书架书籍列表
                           @"ListBookFromTeacherBookShelf",
                           //教师从书架删除书籍
                           @"TeacherDeleteBookToBookShelf",
                           //分页查询教材列表
                           @"ListBooks",
                           //查询指定书本信息
                           @"QueryBookById",
                           //教师添加书籍到书架
                           @"TeacherAddBookToBookShelf",
                           
                           // 指定书籍是否存在于书架
                           @"ExistsOnTeacherBookself",
                           
                           //查询指定书本单元列表
                           @"ListBookUnits",
                           //查询指定单元的词汇听说应用类型
                           @"QueryAppTypeByUnit",
                           //教师查询出版社列表
                           @"TeacherListPublisher",
                           //查询搜索热门
                           @"QuerySearchWords",
                           
                           //查询书本的筛选条件字典信息
                           @"QueryBookFilterDic",
                           
                           //查询书本类型列表
                           @"ListBookType",
                           
                           // 查询商城教辅试题信息
                           @"TeacherQueryJFQuestion",
                           
                           //查询商城教辅单元内容
                           @"TeacherQueryJFBookUnitContent",
                           
                           //新增或者修改题目解析
                          @"TeacherAddOrUpdateQuestAnalysis",
                           
                           //教师删除自己定义的题目解析
                           @"TeacherDeleteQuestAnalysis",
                           //老师查询礼品列表
                           @"ListTeacherGifts",
                           
                           //老师查询指定礼品信息
                           @"TeacherFindGiftByGiftId",
                           
                           //查询老师感恩币兑换列表
                           @"ListTeacherGiftExchangeLog",
                           
                           //查询老师地址列表
                           @"QueryTeacherAddressById",
                           
                           //删除老师指定地址信息
                           @"DeleteTeacherAddress",
                           
                           //编辑老师指定地址信息
                           @"UpdateTeacherAddress",
                           
                           //老师新增地址
                           @"AddTeacherAddress",
                           
                           //老师兑换礼品
                           @"TeacherExchangeGift",
                           
                           //查询教辅作业内容
                           @"QueryJFHomeworkContent",
                           
                           //
                           @"ListTeacherAddressCitys",
                           
                           //查询指定题目其它老师共享的自定义解析
                           @"ListJFQuestCustomAnalysis",
                           
                           //给教师自定义解析点赞
                           @"PraiseTeacherCustomAnalysis",
                           
                           //查询学生不会做的教辅题目列表
                           @"ListStudentUnKnowHomeworkJfQuestions",
                           //查询作业教辅试题列表
                           @"QueryHomeworkJfQuestions",
                           
                           //修改指定作业教辅的解析
                           @"UpdateHomeworkJFQuestionAnalysis",
                           //查询语文单元内容
                           @"TeacherQueryYuwenUnitContent",
                           //查询指定单元的课后习题列表
                           @"ListExerciseQuestionByUnit",
                           //查询学生指定书本的课后练习作业
                           @"QueryStudentKhlxHomework",
                           //查询筛选书本的字典信息
                           @"QueryBookFilterDic2",
                           //分页查询指定单元的课后习题列表
                           @"QueryPageExerciseQuestionByUnit",
                           
                           //查询教师端首页预览数据
                           @"QueryTeacherIndexPreview",
                           
                           //资讯接口
                           @"ListNews",
                           //查询指定作业学生总览-作业检查
                           @"ListHomeworkStudents",
                           //查询指定作业子项学生列表-作业检查
                           @"QueryHomeworkTypeStudents",
                           //查询作业报表
                           @"QueryHomeworkReport",
                           //查询指定作业项课后习题列表
                           @"TeacherQueryHomeworkKhlxQuestions",
                           //查询指定作业项计分项得分记录
                           @"ListStudentScoreByHomeworkTypeId",
                           //查看学生教辅题目
                           @"QueryStudentHomeworkJfQuestions",
                           //阅读量
                           @"AddNewsReadCount",
                           nil];
    });
    return urlForTypeArray[requestType];
}
@end
