//
//  Interface.h
//  TeacherPro
//
//  Created by DCQ on 2017/4/24.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#ifndef Interface_h
#define Interface_h

#define     EnvironmentIndex      @"runningEnvironmentIndex" //帮助与反馈
#define     RequestBaseIndex      0 ////0.生产环境 1.150环境 2.181181181测试环境

//********************************* 内网测试环境 ************************************
#if 0

#define     Request_NameSpace_company_internal     @"http://192.168.1.181/TeacherServer/single_api"//内网开发网
#define     Request_Homework_webview_url           @"http://192.168.1.181/ajiau-res/mybook.html"//内网布置书本作业webview 测试
#define     Request_NameSpace_upload_internal      @"http://192.168.1.181/res-upload/resource-upload-req"                       //图片上传
#define     Request_SubmitFeedback_internal        @"http://192.168.1.181/csc/api/xterm/ClientSubmitFeedbackDetails" //提交反馈
#define     Invitation_Student_internal            @"http://192.168.1.181/ajiau-res/teacher_share.html"//邀请学生
#define     Invitation_Student_Cartoon_internal    @"http://192.168.1.181/ajiau-res/student/share_cartoon.html" //绘本配音详情
#define     HEADURL_RECOMMENDED_WEB                @"http://192.168.1.181/ajiau-res/recommend/rec_teacher.html" //推荐好友
#define     is_production      FALSE

#elif 1
//********************************* 外网测试环境 ************************************

#define     Request_Homework_webview_url           @"http://218.76.7.150:8080/ajiau-appweb/mybook.html"//布置作业 webview url测试
#define     Request_NameSpace_company_internal     @"http://218.76.7.150:8080/ajiau-api/TeacherServer/single_api"//  app 接口
#define     Request_SubmitFeedback_internal        @"http://218.76.7.150:8080/csc/api/xterm/ClientSubmitFeedbackDetails"  // 提交反馈
#define     Invitation_Student_internal            @"http://218.76.7.150:8080/ajiau-appweb/teacher_share.html"//邀请学生
#define     Invitation_Student_Cartoon_internal    @"http://218.76.7.150:8080/ajiau-appweb/student/share_cartoon.html"//绘本配音详情

#define     Request_NameSpace_upload_internal      @"https://res.ajia.cn/res-upload/resource-upload-req"          //图片上传
#define     HEADURL_RECOMMENDED_WEB                @"https://api.p.ajia.cn/ajiau-appweb/recommend/rec_teacher.html" //推荐好友
#define     is_production      FALSE










//********************************* 正式环境 ************************************
#else

#define     Request_NameSpace_company_internal     @"https://api.p.ajia.cn/TeacherServer/single_api"   //app 接口
#define     Invitation_Student_internal            @"https://api.p.ajia.cn/ajiau-appweb/teacher_share.html"//邀请学生
#define     Request_Homework_webview_url           @"https://api.p.ajia.cn/ajiau-appweb/mybook.html"//  布置作业 webview url
#define     Invitation_Student_Cartoon_internal    @"https://api.p.ajia.cn/ajiau-appweb/student/share_cartoon.html" //绘本配音详情
#define     HEADURL_RECOMMENDED_WEB                @"https://api.p.ajia.cn/ajiau-appweb/recommend/rec_teacher.html" //推荐好友

#define     Request_NameSpace_upload_internal      @"https://res.ajia.cn/res-upload/resource-upload-req"         //上传资源接口
#define     Request_SubmitFeedback_internal        @"https://csc.ajia.cn/api/xterm/ClientSubmitFeedbackDetails"  //意见反馈接口
#define     is_production      YES
#endif







//********************************* 通用 ************************************

#define     HEADURL_HELP_WEB         @"https://p.ajia.cn/html/help/help.html" //帮助与反馈

#endif /* Interface_h */
