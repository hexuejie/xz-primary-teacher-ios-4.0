//
//  NetRequestAPIManager.h
//  TeacherPro
//
//  Created by DCQ on 2017/4/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger ,NetRequestType ){
    /***********************************************************************************************/
    /*================================*/
    /**教师登录
     */
       NetRequestType_TeacherLogin                      = 0,
    /**
     教师退出登录
     */
      NetRequestType_TeacherLoginOut                        ,
    /**
     教师注册
     */
     NetRequestType_TeacherRegister                         ,
    /**
     教师注册验证码
     */
    NetRequestType_TeacherRegisterSendAuthCode              ,
    
    /**©
     教师注册填写个人信息
     */
    NetRequestType_TeacherRegisterAddInfo                   ,
    
    /**
     教师重置密码
     */
    NetRequestType_TeacherResetPassword                        ,
    /**
     教师忘记密码验证码
     */
    NetRequestType_TeacherForgetPwdSendAuthCode             ,
    
    /**
     教师解散班级验证码
     */
    NetRequestType_TeacherDaisbandClassSendAuthCode             ,
    /**
     获取当前定位的城市所有学校
     */
     NetRequestType_QuerySchoolByCityName               ,
    
    /**
     设置教师的学校
     */
    NetRequestType_SetTeacherSchool                     ,
    /**
     //查询省行政区域
     */
    
    NetRequestType_QueryProvince                        ,
    /**
     查询市行政区域 （行政编码查询）
     */
    
    NetRequestType_QueryCity                            ,
    
    /**
     查询市所在的省 下的所有市区（市名查询）
     */
    
    NetRequestType_CityName                            ,
    
    /**
     通过学校名称搜索学校列表
     */
    NetRequestType_ListSchoolByName                     ,
    
    /**
     查询教师绑定的班级列表
     */
    NetRequestType_QueryTeacherBindClazzs               ,
    
    /**
      教师退出班级
     */
    NetRequestType_TeacherQuitClazz                     ,
    
    /**
     查询科目
     */
    NetRequestType_QueryDictionary                      ,
    /**
     创建班级
     */
    
    NetRequestType_TeacherCreateClazz                     ,
    
    /**
     查询指定班级的老师
     */
    NetRequestType_QueryClazzTeachers                    ,
    
    
    /**
     查询指定班级的学生列表
     */
    NetRequestType_ListStudentByClazzId                    ,
    
    /**
     教师转让班级
     */
  
    NetRequestType_TeacherTransferClazz                    ,
    
    /**
     教师解散自己的班级
     */
    NetRequestType_TeacherDisbandClazz                       ,
    
    /**
     教师加入指定班级
     */
    NetRequestType_TeacherAddToClazz                        ,
    
    /**
     教师更新用户信息
     */
    NetRequestType_TeacherUpdateClazSubject                 ,
    
    /**
     根据手机号码查询教师绑定的班级列表
     */
    
     NetRequestType_QueryTeacherClazzByPhone              ,
    
    /**
     教师转让班级管理员权限
     */
    
    NetRequestType_TeacherTransferAdminTeacher                  ,
    
    /**
     教师更换学生班级(仅仅限同一教师下班级的更换)
     */
   
     NetRequestType_TeacherUpdateStudentClazz                   ,
    
    /**
     教师移除自己班级下的学生
     */
     NetRequestType_TeacherRemoveStudent                         ,
    /**
      //管理员移除班级下的老师
     */
     NetRequestType_TeacherRemoveClazzTeacher                     ,
    
    /**
     查询教师绑定的班级列表（按班级进行分组）
     **/
    NetRequestType_QueryTeacherBindClazzsAndGroup                 ,
    
    /**
     查询反馈方式
     */
     NetRequestType_QueryHomeworkFeedback                         ,
    
    /**
     教师布置作业
     */
    
     NetRequestType_TeacherAssignHomework                          ,
    
    /**
     布置作业上传图片
     */
    
    NetRequestType_HomeworkUploadImage                            ,
    
    /**
     布置作业上传音频
     */
    NetRequestType_HomeworkUploadAudio                             ,
    
    
    /**
     教师申请加入指定班级(只发出申请，没有实际加入)
     */
    NetRequestType_TeacherApplyAddToClazz                                          ,
    
    
    /**
     邀请老师加入班级(只发出邀请，没有实际加入)
     */
    NetRequestType_InviteTeacherJoinClazz                                          ,
    
    
    /**
     教师处理邀请
     */
    NetRequestType_TeacherHandleInvite                                              ,
    
    /**
     教师给指定班级群发通知
     */
    NetRequestType_TeacherSendNotifyToClazz                                         ,
    
    /**
     老师收到的消息汇总
     */
    NetRequestType_TeacherNotifyRecvSummary                                         ,
    
    /**
     教师绑定clientId
     */
     NetRequestType_TeacherBindClientId                                             ,
    
    /**
     教师处理通知
     */
     NetRequestType_TeacherHandleNotify                                              ,
    
    /**
     老师消息面板-消息汇总
     */
    NetRequestType_TeacherNotifySummary                                              ,
    
    /**
     教师指定联系人发送消息
     */
    NetRequestType_TeacherSendNotify                                                  ,
    
    /**
     联系人列表
     */
    NetRequestType_ListNofityContacts                                                ,
    
    /**
     教师通知发送记录
     */
    NetRequestType_ListTeacherNotificationSend                                       ,
    
    /**
    教师接收到的通知记录
     */
    NetRequestType_ListTeacherNotificationRecv                                      ,
    
    /**
     删除老师通知
     */
     NetRequestType_DeleteTeacherNotify                                              ,
    
    /**
     删除发送消息
     */
    NetRequestType_DeleteTeacherSendNotify                              ,
    
    /**
     意见反馈
     */
    NetRequestType_ClientSubmitFeedbackDetails                          ,
    
    /**
     查询教师货币流水
     */
    NetRequestType_ListTeacherChangeLog                                 ,
    
    /**
     查询教师布置的作业记录
     */
    NetRequestType_ListTeacherHomeworks                                 ,
    
    /**
     老师催缴作业
     */
    NetRequestType_TeacherCallHomework                                  ,
    
    /**
     查询指定作业内容
     */
    NetRequestType_QueryHomeworkContent                                  ,
    
    
    /**
     查询指定作业的学生反馈信息
     */
    NetRequestType_QueryHomeworkStudentFeedbacks                         ,
    
    
    /**
     查询学生指定作业得分详情
     */
    NetRequestType_QueryStudentHomeworkScore                                ,
    
    
    /**
     查询指定作业成绩榜
     */
     NetRequestType_ListHomeworkStudentScore                               ,
    
    /**
     教师点评作业
     */
    NetRequestType_TeacherRemarkHomework                                   ,
    
    /**
     查询学生作业子项试题得分明细
     */
   NetRequestType_QueryStudentHomeworkTypeQuestScore                        ,
    
    /**
  
     查询指定教师的感恩币数量
     */
    
    NetRequestType_QueryTeacherCoin                 ,
    
    /*
     教师更新密码
     **/
    
    NetRequestType_TeacherUpdatePassword                    ,
    

    /**
     教师更新用户名
     */
    NetRequestType_TeacherUpdateName                        ,
    
    
    /**
    查询学生指定月份的作业日历
     */
    NetRequestType_QueryStudentHomeworkCalendar               ,
    
    
    /**
     查询老师指定月份的作业回顾
     */
    NetRequestType_QueryTeacherHomeworkMonthReview              ,
    
    /**
     查询教师指定日期的作业记录
     */
    NetRequestType_ListTeacherHomeworkByDay                     ,
    
    /**
      修改手机号码解绑发送验证码
     */
    NetRequestType_UnbindPhoneSendAuthCode                      ,
    
    /**
     验证解绑手机的验证码
     */
     NetRequestType_ValidateUnbindPhoneAuthCode   ,
    
    /**
     
     修改手机号码绑定发送验证码
     */
    NetRequestType_BindPhoneSendAuthCode            ,
    
    
    /**
     验证绑定手机的验证码
     */
    NetRequestType_ValidateBindPhoneAuthCode ,
    
    /*
     重置老师手机号码
     */
    NetRequestType_ResetTeacherPhone        ,
    
    /**
    查询指定教师是否存在绑定的班级
    */
    
    NetRequestType_QueryTeacherExistsClazz ,
    
    /**
     查询绘本每页的预览信息
     */
    NetRequestType_QueryCartoonPages        ,
    
    /**
     查询班级正在申请加入的教师
     */
    NetRequestType_QueryClazzJoiningTeachers ,
    
    /**
     通过手机号码查询指定教师信息
     **/
    
    NetRequestType_QueryTeacherByPhone      ,
    /**
     查询指定教师信息
     **/
    NetRequestType_QueryTeacherById ,
    
    /**
       老师查询申请班级记录
     */
    
    NetRequestType_ListTeacherApplyClazzHistory,
    
    /**
     老师向申请的班级发起催促通知
     */
    NetRequestType_TeacherCallApplyAddClazz,
    
    /**
     老师修改图像
     */
    NetRequestType_TeacherUpdateAvatar,
    /**
     老师图像上传图片文件
     */
    NetRequestType_TeacherUploadImage,
    
    
    /**
     查询教师书架书籍列表
     */
    NetRequestType_ListBookFromTeacherBookShelf,
    /**
     教师从书架删除书籍
     */
    NetRequestType_TeacherDeleteBookToBookShelf,
    
    /**
     分页查询教材列表
     */
    NetRequestType_ListBooks ,
    
    
    /**
     查询指定书本信息
     */
    NetRequestType_QueryBookById,
    
    /**
     教师添加书籍到书架
     */
    NetRequestType_TeacherAddBookToBookShelf,
    
    /**
     指定书籍是否存在于书架
     */
    
    NetRequestType_ExistsOnTeacherBookself,
    
    /**
     查询指定书本单元列表
     */
    NetRequestType_ListBookUnits,
    
    /**
     查询指定单元的词汇听说应用类型
     */
    NetRequestType_QueryAppTypeByUnit ,
    
    /**
     教师查询出版社列表
     */
    NetRequestType_TeacherListPublisher,
    
    /**
     查询搜索热门
     */
    NetRequestType_QuerySearchWords,
    
    /**
    查询书本的筛选条件字典信息
     */
    NetRequestType_QueryBookFilterDic ,
    
    
    /**
     查询书本类型列表
     */
     NetRequestType_ListBookType ,
    
    /**
     查询商城教辅试题信息
     */
    NetRequestType_TeacherQueryJFQuestion,
     /**
      查询商城教辅单元内容
      */
    NetRequestType_TeacherQueryJFBookUnitContent,
    /**
     新增或者修改题目解析
     */
    NetRequestType_TeacherAddOrUpdateQuestAnalysis,
    
    /**
     教师删除自己定义的题目解析
     */
    NetRequestType_TeacherDeleteQuestAnalysis,
    /**
     老师查询礼品列表
     */
    NetRequestType_ListTeacherGifts,
    /**
     老师查询指定礼品信息
     */
     NetRequestType_TeacherFindGiftByGiftId,
    
    /**
      查询老师感恩币兑换列表
     */
     NetRequestType_ListTeacherGiftExchangeLog,
    
    /**
     查询老师地址列表
     */
     NetRequestType_QueryTeacherAddressById,
    
    /**
     删除老师指定地址信息
     */
    NetRequestType_DeleteTeacherAddress,
    
    /**
     编辑老师指定地址信息
     */
     NetRequestType_UpdateTeacherAddress,
    
    /**
     老师新增地址
     */
     NetRequestType_AddTeacherAddress,
    
    /**
     老师兑换礼品
     */
     NetRequestType_TeacherExchangeGift,
    
    /**
     查询教辅作业内容
     */
     NetRequestType_QueryJFHomeworkContent,
    /**
    老师学豆兑换礼品时, 新增地址--》城市列表
     */
     NetRequestType_ListTeacherAddressCitys,
    
    /**
     查询指定题目其它老师共享的自定义解析
     */
     NetRequestType_ListJFQuestCustomAnalysis,
    
    /**
     给教师自定义解析点赞
     */
     NetRequestType_PraiseTeacherCustomAnalysis,
    
    /**
     查询学生不会做的教辅题目列表
     */
    NetRequestType_ListStudentUnKnowHomeworkJfQuestions,
    /**
     查询作业教辅试题列表
     */
    NetRequestType_QueryHomeworkJfQuestions ,
    
    /**
     修改指定作业教辅的解析
     */
    NetRequestType_UpdateHomeworkJFQuestionAnalysis,
    /**
      查询语文单元内容
     */
     NetRequestType_TeacherQueryYuwenUnitContent,
    /**
     查询指定单元的课后习题列表
     */
     NetRequestType_ListExerciseQuestionByUnit,
    
    /**
     查询学生指定书本的课后练习作业
     */
    NetRequestType_QueryStudentKhlxHomework,
    
    /**
     查询筛选书本的字典信息
     */
    NetRequestType_QueryBookFilterDic2,
    /**
     分页查询指定单元的课后习题列表
     */
    NetRequestType_QueryPageExerciseQuestionByUnit,
    
     /**
      查询教师端首页预览数据
      */
    NetRequestType_QueryTeacherIndexPreview,
    
    /**
     资讯
     */
    NetRequestType_QueryListNews,
    /**
     查询指定作业学生总览-作业检查
     */
    NetRequestType_ListHomeworkStudents,
    
    /**
     查询指定作业子项学生列表-作业检查
     */
    NetRequestType_QueryHomeworkTypeStudents,
    
    /**
     查询作业报表
     */
    NetRequestType_QueryHomeworkReport,
    /**
     查询指定作业项课后习题列表
     */
    NetRequestType_TeacherQueryHomeworkKhlxQuestions ,
    
    /**
     查询指定作业项计分项得分记录
     */
     NetRequestType_ListStudentScoreByHomeworkTypeId,
    
    /**
     查看学生教辅题目
     **/
    NetRequestType_QueryStudentHomeworkJfQuestions,
    
    /**
     阅读量
     **/
    
    NetRequestType_AddNewsReadCount,
    
    
    /**
     查询书本的筛选条件字典信息 全部
     */
    NetRequestType_ListBookTypeChildDic ,
    /***********************************************************************************************/
    
    NetRequestType_PersonReport ,
    
    NetRequestType_Personproblem ,
    
    NetRequestType_PortDetialproblem ,
    
};


@interface NetRequestAPIManager : NSObject
/**
 根据请求类型获得地址
 */
+ (NSString *)getRequestURLStr:(NetRequestType )requestType;

@end
