//
//  ECServiceCocos2dx.h
//  SanguoCOK
//
//  Created by zhangwei on 16/4/12.
//
//

#ifndef ECServiceCocos2dx_h
#define ECServiceCocos2dx_h

#include "cocos2d.h"
#include <string>


using namespace std;

/*! \mainpage Documentation for the Cocos2dx plugin
 *
 * The HelpshiftCocos2dx plugin exposes the C++ Helpshift API for cocos2dx games.
 */

/*! \brief API for the Cocos2dx plugin for Helpshift Cocos2dx SDK
 *
 */

class ECServiceCocos2dx
{
public:
	static void init(string appId,string appKey,string domain);
    static void show(string userName,string userIcon,string userId,string appName,int serverId cocos2d::ValueMap& config,string showConversationFlag);
    
    static void show(string userName,string userIcon,string userId,string appName);
    static void showFAQ(string faqId);
    static void showFAQ(string faqId,cocos2d::ValueMap& config);
    
    static void showFAQList();
    static void showFAQList(cocos2d::ValueMap& config);
    
    static void registerDeviceToken(string deviceToken);
    
    
};
#endif

