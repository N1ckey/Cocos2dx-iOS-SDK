//
//  ECServiceCocos2dx.mm
//  AIHelp Cocos2dx iOS SDK
//
//

#import "ECServiceCocos2dx.h"
#import <ElvaChatServiceSDK/ECServiceSdk.h>

#pragma mark Utility methods.
static void elvaAddObjectToNSArray(const cocos2d::Value& value, NSMutableArray *array);
static void elvaAddObjectToNSDict(const std::string& key, const cocos2d::Value& value, NSMutableDictionary *dict);
static NSString* elvaParseCString(const char *cstring) {
    if (cstring == NULL) {
        return NULL;
    }
    NSString * nsstring = [[NSString alloc] initWithBytes:cstring
                                                   length:strlen(cstring)
                                                 encoding:NSUTF8StringEncoding];
    return [nsstring autorelease];
}

static void elvaAddObjectToNSArray(const cocos2d::Value& value, NSMutableArray *array){
    if(value.isNull()) {
        return;
    }


    
    // add string into array
    if (value.getType() == cocos2d::Value::Type::STRING) {
        NSString *element = [NSString stringWithCString:value.asString().c_str() encoding:NSUTF8StringEncoding];
        [array addObject:element];
    } else if (value.getType() == cocos2d::Value::Type::FLOAT) {
        NSNumber *number = [NSNumber numberWithFloat:value.asFloat()];
        [array addObject:number];
    } else if (value.getType() == cocos2d::Value::Type::DOUBLE) {
        NSNumber *number = [NSNumber numberWithDouble:value.asDouble()];
        [array addObject:number];
    } else if (value.getType() == cocos2d::Value::Type::BOOLEAN) {
        NSNumber *element = [NSNumber numberWithBool:value.asBool()];
        [array addObject:element];
    } else if (value.getType() == cocos2d::Value::Type::INTEGER) {
        NSNumber *element = [NSNumber numberWithInt:value.asInt()];
        [array addObject:element];
    } else if (value.getType() == cocos2d::Value::Type::VECTOR) {
        NSMutableArray *element = [[NSMutableArray alloc] init];
        cocos2d::ValueVector valueArray = value.asValueVector();
        for (const auto &e : valueArray) {
            elvaAddObjectToNSArray(e, element);
        }
        [array addObject:element];
    } else if (value.getType() == cocos2d::Value::Type::MAP) {
        NSMutableDictionary *element = [NSMutableDictionary dictionary];
        auto valueDict = value.asValueMap();
        for (auto iter = valueDict.begin(); iter != valueDict.end(); ++iter) {
            elvaAddObjectToNSDict(iter->first, iter->second, element);
        }
        [array addObject:element];
    }
}

static void elvaAddObjectToNSDict(const std::string& key, const cocos2d::Value& value, NSMutableDictionary *dict)
{
    if(value.isNull() || key.empty()) {
        return;
    }
    NSString *keyStr = [NSString stringWithCString:key.c_str() encoding:NSUTF8StringEncoding];
    if (value.getType() == cocos2d::Value::Type::MAP) {
        NSMutableDictionary *dictElement = [[NSMutableDictionary alloc] init];
        cocos2d::ValueMap subDict = value.asValueMap();
        for (auto iter = subDict.begin(); iter != subDict.end(); ++iter) {
            elvaAddObjectToNSDict(iter->first, iter->second, dictElement);
        }

        [dict setObject:dictElement forKey:keyStr];
    } else if (value.getType() == cocos2d::Value::Type::FLOAT) {
        NSNumber *number = [NSNumber numberWithFloat:value.asFloat()];
        [dict setObject:number forKey:keyStr];
    } else if (value.getType() == cocos2d::Value::Type::DOUBLE) {
        NSNumber *number = [NSNumber numberWithDouble:value.asDouble()];
        [dict setObject:number forKey:keyStr];
    } else if (value.getType() == cocos2d::Value::Type::BOOLEAN) {
        NSNumber *element = [NSNumber numberWithBool:value.asBool()];
        [dict setObject:element forKey:keyStr];
    } else if (value.getType() == cocos2d::Value::Type::INTEGER) {
        NSNumber *element = [NSNumber numberWithInt:value.asInt()];
        [dict setObject:element forKey:keyStr];
    } else if (value.getType() == cocos2d::Value::Type::STRING) {
        NSString *strElement = [NSString stringWithCString:value.asString().c_str() encoding:NSUTF8StringEncoding];
        [dict setObject:strElement forKey:keyStr];
    } else if (value.getType() == cocos2d::Value::Type::VECTOR) {
        NSMutableArray *arrElement = [NSMutableArray array];
        cocos2d::ValueVector array = value.asValueVector();
        for(const auto& v : array) {
            elvaAddObjectToNSArray(v, arrElement);
        }
        [dict setObject:arrElement forKey:keyStr];
    }
}

static NSMutableDictionary *elvaValueMapToNSDictionary(cocos2d::ValueMap& dict) {
    NSMutableDictionary *nsDict = [NSMutableDictionary dictionary];
    for (auto iter = dict.begin(); iter != dict.end(); ++iter)
    {
        elvaAddObjectToNSDict(iter->first, iter->second, nsDict);
    }
    return nsDict;
}

static NSArray *elvaVectorOfMapsToNSArray(cocos2d::ValueVector& data) {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (const auto &map : data) {
        NSDictionary *dictionary = elvaValueMapToNSDictionary((cocos2d::ValueMap&) map.asValueMap());
        [array addObject:dictionary];
    }
    return array;
}

#pragma mark - 初始化init
void ECServiceCocos2dx::init(string appKey,string domain,string appId) {
    NSString* NSAppId = elvaParseCString(appId.c_str());
    NSString* NSAppSecret = elvaParseCString(appKey.c_str());
    NSString* NSDomain = elvaParseCString(domain.c_str());
    [ECServiceSdk init:NSAppSecret Domain:NSDomain AppId:NSAppId];
}
#pragma mark - show 不带参数config
void ECServiceCocos2dx::showElva(string playerName,string playerUid,int serverId,string playerParseId,string showConversationFlag){
    NSString* NSuserName = elvaParseCString(playerName.c_str());
    
    NSString* NSuserId = elvaParseCString(playerUid.c_str());
    
    NSString* parseId = elvaParseCString(playerParseId.c_str());
    
    NSString *conversationFlag =elvaParseCString(showConversationFlag.c_str());
    
    NSString* serverIdStr = [NSString stringWithFormat:@"%d",serverId];
    [ECServiceSdk showElva:NSuserName PlayerUid:NSuserId ServerId:serverIdStr PlayerParseId:parseId PlayershowConversationFlag:conversationFlag];
    
    
}

#pragma mark - show 带参数config
void ECServiceCocos2dx::showElva(string playerName,string playerUid,int serverId,string playerParseId,string showConversationFlag,cocos2d::ValueMap& config) {
    
    NSString* NSuserName = elvaParseCString(playerName.c_str());
    
    NSString* NSuserId = elvaParseCString(playerUid.c_str());
    
    NSString* parseId = elvaParseCString(playerParseId.c_str());
    
    NSString *conversationFlag =elvaParseCString(showConversationFlag.c_str());
    
    
    NSMutableDictionary *customData = elvaValueMapToNSDictionary(config);
    NSString* serverIdStr = [NSString stringWithFormat:@"%d",serverId];

    [ECServiceSdk showElva:NSuserName PlayerUid:NSuserId ServerId:serverIdStr PlayerParseId:parseId PlayershowConversationFlag:conversationFlag Config :customData];
}



#pragma mark - faq参数为faqID
void ECServiceCocos2dx::showSingleFAQ(string faqId) {
    NSString *faqid = elvaParseCString(faqId.c_str());
    [ECServiceSdk showSingleFAQ:faqid];
}

#pragma mark - faq参数为faqID 带config
void ECServiceCocos2dx::showSingleFAQ(string faqId,cocos2d::ValueMap& config) {
    NSString *faqid = elvaParseCString(faqId.c_str());
    NSMutableDictionary *customData = elvaValueMapToNSDictionary(config);
    [ECServiceSdk showSingleFAQ:faqid Config:customData];
    
}

#pragma mark - showFAQSection
void ECServiceCocos2dx::showFAQSection(string sectionPublishId){
    NSString *sectionId = elvaParseCString(sectionPublishId.c_str());
    [ECServiceSdk showFAQSection:sectionId];
}

#pragma mark - showFAQSection(带config)
void ECServiceCocos2dx::showFAQSection(string sectionPublishId,cocos2d::ValueMap& config){
    NSString *sectionId = elvaParseCString(sectionPublishId.c_str());
    NSMutableDictionary *customData = elvaValueMapToNSDictionary(config);
    [ECServiceSdk showFAQSection:sectionId Config:customData];
}


#pragma mark - faqList无参数
void ECServiceCocos2dx::showFAQs() {
    [ECServiceSdk showFAQs];
}

#pragma mark - showFAQs 带参数config
void ECServiceCocos2dx::showFAQs(cocos2d::ValueMap& config) {
    NSMutableDictionary *customData = elvaValueMapToNSDictionary(config);
    [ECServiceSdk showFAQs:customData];
}

#pragma mark - 设置游戏名称
void ECServiceCocos2dx::setName(string game_name){
    NSString* gameName  = elvaParseCString(game_name.c_str());
    [ECServiceSdk setName:gameName];
    
}

#pragma mark - 设置deviceToken
void ECServiceCocos2dx::registerDeviceToken(string deviceToken) {
    NSString* token = elvaParseCString(deviceToken.c_str());
    [ECServiceSdk registerDeviceToken:token];
    
}
#pragma mark - 设置UserId
void ECServiceCocos2dx::setUserId(string playerUid){
    NSString* userId = elvaParseCString(playerUid.c_str());
    [ECServiceSdk setUserId:userId];
}
#pragma mark - 设置ServerId
void ECServiceCocos2dx::setServerId(int serverId){
    NSString* serverIdStr = [NSString stringWithFormat:@"%d",serverId];
    [ECServiceSdk setServerId:serverIdStr];
}

#pragma mark - 设置userName
void ECServiceCocos2dx::setUserName(string playerName){
    NSString* userName = elvaParseCString(playerName.c_str());
    [ECServiceSdk setUserName:userName];
}
#pragma mark - 设置showConversation
void ECServiceCocos2dx::showConversation(string playerUid,int serverId){
    NSString* userId = elvaParseCString(playerUid.c_str());
    NSString* serverIdStr = [NSString stringWithFormat:@"%d",serverId];
    [ECServiceSdk showConversation:userId ServerId:serverIdStr];
}
#pragma mark - 设置showConversation带config
void ECServiceCocos2dx::showConversation(string playerUid,int serverId,cocos2d::ValueMap& config){
    NSString* userId = elvaParseCString(playerUid.c_str());
    NSMutableDictionary *customData = elvaValueMapToNSDictionary(config);
    NSString* serverIdStr = [NSString stringWithFormat:@"%d",serverId];
    [ECServiceSdk showConversation:userId ServerId:serverIdStr Config:customData];
    
}
bool ECServiceCocos2dx::setSDKLanguage(const char *locale) {
    if(locale == NULL || strlen(locale) == 0) {
        return false;
    }
    NSString* language = elvaParseCString(locale);
    return [ECServiceSdk setSDKLanguage:language];
}
void ECServiceCocos2dx::useDevice() {
    [ECServiceSdk setUseDevice];
}
void ECServiceCocos2dx::setEvaluateStar(int star){
    [ECServiceSdk setEvaluateStar:star];
}

void ECServiceCocos2dx::showElvaOP(string playerName,string playerUid,int serverId,string playerParseId,string showConversationFlag,cocos2d::ValueMap& config){
    
    
    NSString* NSuserName = elvaParseCString(playerName.c_str());
    
    NSString* NSuserId = elvaParseCString(playerUid.c_str());
    NSString* serverIdStr = [NSString stringWithFormat:@"%d",serverId];
    
    NSString* parseId = elvaParseCString(playerParseId.c_str());
    
    NSString *conversationFlag =elvaParseCString(showConversationFlag.c_str());
    
    
    NSMutableDictionary *customData = elvaValueMapToNSDictionary(config);

    
    [ECServiceSdk showElvaOP:NSuserName PlayerUid:NSuserId ServerId:serverIdStr PlayerParseId:parseId PlayershowConversationFlag:conversationFlag Config :customData];

}

void ECServiceCocos2dx::showElvaOP(string playerName,string playerUid,int serverId,string playerParseId,string showConversationFlag,cocos2d::ValueMap& config,int defaultTabIndex){
    
    NSString* NSuserName = elvaParseCString(playerName.c_str());
    
    NSString* NSuserId = elvaParseCString(playerUid.c_str());
    NSString* serverIdStr = [NSString stringWithFormat:@"%d",serverId];
    
    NSString* parseId = elvaParseCString(playerParseId.c_str());
    
    NSString *conversationFlag =elvaParseCString(showConversationFlag.c_str());
    
    
    NSMutableDictionary *customData = elvaValueMapToNSDictionary(config);
    
    
    [ECServiceSdk showElvaOP:NSuserName PlayerUid:NSuserId ServerId:serverIdStr PlayerParseId:parseId PlayershowConversationFlag:conversationFlag Config :customData defaultTabIndex:defaultTabIndex];

}
