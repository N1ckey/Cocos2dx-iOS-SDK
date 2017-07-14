//
//  ECServiceCocos2dx.m
//  SanguoCOK
//
//  Created by zhangwei on 16/4/12.
//
//

#import "ECServiceCocos2dx.h"
#import <ElvaChatServiceSDK/MessageViewController.h>
#import <ElvaChatServiceSDK/GetServerIP.h>
#import <ElvaChatServiceSDK/ShowWebViewController.h>

static NSString* elvaParseCString(const char *cstring) {
    if (cstring == NULL) {
        return NULL;
    }
    NSString * nsstring = [[NSString alloc] initWithBytes:cstring
                                                   length:strlen(cstring)
                                                 encoding:NSUTF8StringEncoding];
    return [nsstring autorelease];
}

void ECServiceCocos2dx::init(string appId,string appKey,string domain) {
	NSString* NSAppId = elvaParseCString(appId.c_str());
	NSString* NSAppKey = elvaParseCString(appKey.c_str());
    NSString* NSDomain = elvaParseCString(domain.c_str());

	[GetServerIP getServerMsgWithAppId:NSAppId 
								AppKey:NSAppKey
								Domain:NSDomain];
}

void ECServiceCocos2dx::show(string userName,string userIcon,string userId,string appName) {
	NSString* NSuserName = elvaParseCString(userName.c_str());

	NSString* NSuserIcon = elvaParseCString(userIcon.c_str());

	NSString* NSuserId = elvaParseCString(userId.c_str());

	NSString* NSappName = elvaParseCString(appName.c_str());

    [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
    
    //初始化KCMainViewController
    MessageViewController *mainController=[[MessageViewController alloc]init];
    [mainController initParamsWithUserName:NSuserName UserPic:NSuserIcon UserId:NSuserId Title:@"ElvaChatService"];
    //设置自定义控制器的大小和window相同，位置为（0，0）
    mainController.view.frame=[UIApplication sharedApplication].keyWindow.bounds;
    //设置此控制器为window的根控制器
    [UIApplication sharedApplication].keyWindow.rootViewController=mainController;
}

//faq参数为faqID
void ECServiceCocos2dx::showFAQ(string faqId) {
    GetServerIP* faqUrl = [GetServerIP getFaqService];
    NSString *showfaqs = faqUrl.showfaq;
    ShowWebViewController *showWebView = [[ShowWebViewController alloc]init];
    
    NSString* url =[NSString stringWithFormat:@"%@?ID=%@",showfaqs,elvaParseCString(faqId).c_str];
    showWebView.url = [NSURL URLWithString:url];
    showWebView.loadingBarTintColor = [UIColor blueColor];
//   [UIApplication sharedApplication].keyWindow.rootViewController = showWebView;
    [self presentViewController:showWebView animated:YES completion:^{
        nil;
    }];

}

//faqList无参数
void ECServiceCocos2dx::showFAQList() {
    GetServerIP* faqUrl = [GetServerIP getFaqService];
    NSString *showfaqs = faqUrl.showfaqlist;
    NSString *appId = faqUrl.appId;
    
    //获取本地语言
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    
    
    ShowWebViewController *showWebView = [[ShowWebViewController alloc]init];
    NSString* url =[NSString stringWithFormat:@"%@?AppID=%@&l=%@",showfaqs,appId,preferredLang];
    
    showWebView.url = [NSURL URLWithString:url];
    showWebView.loadingBarTintColor = [UIColor blueColor];
//    [UIApplication sharedApplication].keyWindow.rootViewController = showWebView;
    [self presentViewController:showWebView animated:YES completion:^{
        nil;
    }];
}
