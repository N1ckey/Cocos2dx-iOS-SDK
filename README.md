[查看中文接入文档](https://github.com/AI-HELP/Cocos2dx-iOS-SDK/blob/master/README_CN.md)

## AIHelp SDK Integration Guide
### 1. Download The AIHelp Cocos2d-x iOS SDK：
Select "Clone or download" to download the iOS SDK in the github page.

The folder **aihelp-plugin-cocos2dx** contains:

| Subfolder Name | Description |
|:------------- |:---------------|
| **ios/ElvaChatServiceSDK**    | AIHelp Android SDK core files|
| **v3.x/Classes**      | contains the cpp files for Cocos2dx version 3.x|
| **v2.x/Classes**      | contains the cpp files for Cocos2dx version 2.x| 

### 2. Add AIHelp to your Cocos2dx project:
**a.** Copy folder *ElvaChatServiceSDK* to the the root directory of your Cocos2dx Xcode project.

**b.** Copy the cpp files under the folder *Classes* into the Classes folder of your Cocos2dx project, choose files to copy based on the version of your Cocos2dx.

**c.** Add the following frameworks to Link Binary with Libraries

- CoreGraphics
- QuartzCore
- CoreText
- SystemConfiguration
- UIKit
- libsqlite3.0.tbd
- Security
- CoreSpotlight
- GameController(required by cocos2d-x)
- MediaPlayer(required by cocos2d-x)
- Webkit(if using [operation module API](#showElvaOP) )
 
### 3. Initialize AIHelp SDK in your Project

```
Note：
You must use ECServiceCocos2dx::init(...) in your App's Initialization Code, otherwise you can't use AIHelp service properly. 

```

```
ECServiceCocos2dx::init(
			String appKey,
			String domain,
			String appId);
```
	


**About Parameters：**

| Parameters | Description |
|:------------- |:---------------|
| appKey    | Your Unique Developer API Key|
| domain     | Your AIHelp Domain Name. For Example: foo.AIHELP.NET|
| appId     | Unique ID Assigned to your App.| 

Note: Please log into [AIHelp Web Console](https://aihelp.net/elva) with your registered email account to find the __appKey__, __domain__ and __appId__ In the _Application_ page of the _Settings_ Menu. 
If your company does not have an account, you need to register an account at [AIHelp Website](http://aihelp.net/index.html)


**Coding Example：**

```
// Must be called during application/game initialization, otherwise you can't use AIHelp properly

ECServiceCocos2dx::init(
			"YOUR_API_KEY",
			"YOUR_DOMAIN_NAME",
			"YOUR_APP_ID");
```

---

### 4. Start using AIHelp

#### 1. API Summary

| Method Name| Purpose |Prerequisites|
|:------------- |:---------------|:---------------|
| **[showElva](#showElva)**      | Launch AI Conversation Interface| 
| **[showElvaOP](#showElvaOP)** | Launch Operation Interface| Need to configure Operation Sections|
| **[showFAQs](#showFAQs)** | Show all FAQs by Sections|Need to Configure FAQs|
|**[showConversation](#showConversation)**|Launch Manual Conversation Interface | Need to [setUserName](#UserName) and [setUserId](#UserId) |
| **[showSingleFAQ](#showSingleFAQ)** | Show Single FAQ|Need to Configure FAQ|
| **[setName](#setName)** | Set APP/Game Name|Use it after Initialization|
| **[setUserName](#UserName)** | Set User In-App Name|
| **[setUserId](#UserId)** | Set Unique User ID|
| **[setSDKLanguage](#setSDKLanguage)** | Set SDK Language|


**Note：It is not necessary for you to use all the APIs, especially when you only have one user interface for the customer service in your application. Some APIs already contains entry to other APIs, see below for details：**

#### <h4 id="showElva">2. Launch the AI Conversation Interface，use `showElva`</h4>


	ECServiceCocos2dx::showElva(
				string playerName,
				string playerUid,
				int serverId,
				string playerParseId,
				string showConversationFlag);
			
or

	ECServiceCocos2dx::showElva(
				string playerName,
				string playerUid,
				int serverId,
				string playerParseId,
				string showConversationFlag,
				cocos2d::ValueMap& config);

**Coding Example：**

	// Presenting AI Help Converation with your customers
	void GameSettingsScene::menuHelpCallback(CCObject* pSender)
	{						
		ECServiceCocos2dx::showElva (
				"USER_NAME",
				"USER_ID",
				123, 
				"",
				"1",
				{ 
					elva-custom-metadata＝｛
					elva-tags＝'vip, pay1',
					VersionCode＝'3'
					｝
				});
	}

**About Parameters：**

- __playerName__: In-App User Name
- __playerUid__: In-App Unique User ID
- __serverId__: The Server ID
- __playerParseId__: Can be empty string, can NOT be NULL.
- __showConversationFlag__: Should be "0" or "1". If set at "1", the VIP conversation entry will be displayed in the upper right hand side of the AI conversation interface.
- __config__: Optional parameters for custom ValueMap information. You can pass specific Tag information using vector elva-tags, see the above coding example. Please note that you also need to configure the same tag information in the Web console so that each conversation can be correctly tagged.
	
![showElva](https://github.com/AIHELP-NET/Pictures/blob/master/showElva-EN-Android.png "showElva")
	
**Best Practice：**

> 1. Use this method to launch your APP's customer service. Configure specific welcome texts and AI story lines in the AIHelp Web Console to better the customer support experiences.
> 2. Enable VIP Conversation Entry to allow users' to chat with your human support team with the parameters "__showConversationFlag__" setting to "__1__", you may use this method for any user or as a privilege for some users only.

#### <h4 id="showElvaOP">3. Launch The Operation Interface, use `showElvaOP`</h4>

The operation module is useful when you want to present updates, news, articles or any background information about your APP/Game to users. The AI Help

	ECServiceCocos2dx::showElvaOP(
				string playerName,
				string playerUid,
				int serverId,
				string playerParseId,
				string showConversationFlag,
				cocos2d::ValueMap& config);

or

	ECServiceCocos2dx::showElvaOP(
				string playerName,
				string playerUid,
				int serverId,
				string playerParseId,
				string showConversationFlag,
				cocos2d::ValueMap& config,
				int defaultTabIndex);

**Coding Example：**

	// Presenting Operation Info to your customers
	void GameSettingsScene::menuOperationCallback(CCObject* pSender)
	{						
		ECServiceCocos2dx::showElvaOP (
					"USER_NAME",
					"USER_ID",
					123, 
					"",
					"1",
					{ 
						elva-custom-metadata＝｛
						elva-tags＝'vip, pay1',
						VersionCode＝'3'
						｝
					});
	}

**About Parameters：**

- __playerName__: User Name in Game/APP
- __playerUid__: Unique User ID
- __serverId__: The Server ID
- __playerParseId__: Can be empty string, can NOT be NULL.
- __showConversationFlag__: Should be "0" or "1". If set at "1", the VIP conversation entry will be shown in the top right-hand side of the AI conversation interface.
- __config__: Custom ValueMap information. You can pass specific Tag information using vector elva-tags, see the above coding example. Please note that you also need to configure the same tag information in the Web console so that each conversation can be correctly tagged.
- __defaultTabIndex__: Optional. The index of the first tab to be shown when entering the operation interface. Default value is the left-most tab，if you would like to show the AI conversation interface(the right-most side) set it to 999.
	
![showElva](https://github.com/AI-HELP/Docs-Screenshots/blob/master/showElvaOP_Android.png "showElvaOP")

**Best Practice：**
> 1. Use this API to present news, announcements, articles or any useful information to users/players. Configure and publish the information in AIHelp web console. 

#### <h4 id="showFAQs">4. Display FAQs, use `showFAQs `</h4>

	ECServiceCocos2dx::showFAQs();

or

	ECServiceCocos2dx::showFAQs (cocos2d::ValueMap& config)

**Coding Example：**

	// Presenting FAQs to your customers
	void GameSettingsScene::menuFAQCallback(CCObject* pSender)
	{						
		ECServiceCocos2dx::showFAQs (
					{ 
						elva-custom-metadata＝｛
						elva-tags＝'vip,pay1',
						VersionCode＝'3'
						｝
					});
	}

**About Parameters：**

- __config__: Custom ValueMap information. You can pass specific Tag information using vector elva-tags, see the above coding example. Please note that you also need to configure the same tag information in the Web console to make each conversation be correctly tagged.
	
![showElva](https://github.com/AI-HELP/Docs-Screenshots/blob/master/showFAQs-EN-Android.png "showFAQs")

**Best Practice：**
> 1. Use this method to show FAQs about your APP/Game properly. Configure FAQs in AIHelp Web Console. Each FAQ can be categroized into a section. If the FAQs are great in number, you can also add Parent Sections to categorize sections to make things clear and organized. 

#### <h4 id="showSingleFAQ">5. Show A Specific FAQ，use `showSingleFAQ`
</h4>

	ECServiceCocos2dx::showSingleFAQ(string faqId);

or

	ECServiceCocos2dx::showSingleFAQ(
				string faqId,
				cocos2d::ValueMap& config);

**Coding Example：**

	// Presenting FAQs to your customers
	void GameSettingsScene::menuFAQCallback(CCObject* pSender)
	{						
		ECServiceCocos2dx::showSingleFAQ (
					"20",
					{ 
						elva-custom-metadata＝｛
						elva-tags＝'vip,pay1',
						VersionCode＝'3'
						｝
					});
	}

**About Parameters：**

- __faqId__: The PublishID of the FAQ item, you can check it at [AIHelp Web Console](https://aihelp.net/elva): Find the FAQ in the FAQ menu and copy its PublishID.
- __config__: Custom ValueMap information. You can pass specific Tag information using vector elva-tags, see the above coding example. Please note that you also need to configure the same tag information in the Web console to make each conversation be correctly tagged.
	
![showSingleFAQ](https://github.com/AIHELP-NET/Pictures/blob/master/showSingleFAQ-EN-Android.png "showSingleFAQ")

<h4 id="selfservice"></h4>

**Self-Service：**

If you configure the "self-service" link in FAQ's configuration, and set [UserId](#UserId), [UserName](#UserName), [ServerId](#ServerId) in SDK，then the FAQ shows with functional menu in the right-top cornor.


**Best Practice：**
> 1. Use this method when you want to show a specific FAQ in a certain location of your APP/Game.

#### <h4 id="setName">6. Set Your App's name for AIHelp SDK to Display，use `setName`</h4>

	ECServiceCocos2dx::setName(string game_name);

**Coding Example：**

	ECServiceCocos2dx::setName("Your Game");

**About Parameters：**

- __game_name__: APP/Game Name

**Best Practice：**
> 1. Use this method after the SDK initialization.The App's name will be displayed in the title bar of the customer service interface.

#### <h4 id="UserId">7. Set the Unique User ID, use `setUserId`</h4>


	ECServiceCocos2dx::setUserId(string playerUid);

**Coding Example：**

	ECServiceCocos2dx::setUserId("123ABC567DEF");

**About Parameters：**

- __playerUid__:Unique User ID

**Best Practice：**
> 1. Normally you do not need to use this method if you have passed user ID in another method. However, if you want to use the FAQ's [Self-Service](#selfservice), then you must set the User Id first.

#### <h4 id="UserName">8. Set User Name，use `setUserName`</h4>

	ECServiceCocos2dx::setUserName (string playerName);

**Coding Example：**

	ECServiceCocos2dx::setUserName ("PLAYER_NAME");

**About Parameters：**

- __playerName:__ User/Player Name

**Best Practice：**
> 1. Use this method to set the user name, which will be shown in the web console's conversation page for the user. You can address the user with this name during the chat.
> 2. Normally you do not need to use this method if you have passed user name in another method. However, if you want to use the FAQ's [Self-Service](#selfservice), then you must set the User Id first.

#### <h4 id="ServerId">9. Set Unique Server ID，use `setServerId`
</h4>

	ECServiceCocos2dx::setServerId(int serverId);

**Coding Example：**

	ECServiceCocos2dx::setServerId("SERVER_ID");

**About Parameters：**

- __serverId:__ The unique server ID

**Best Practice：**
> 1. Normally you do not need to use this method if you have passed the server ID in another method. However, if you want to use the FAQ's [Self-Service](#selfservice), then you must set the User Id first.

#### <h4 id="showConversation">10. Launch VIP Chat Console, use `showConversation`(need to set [UserName](#UserName))</h4>

	ECServiceCocos2dx::showConversation(
					string playerUid,
					int serverId);

or

	ECServiceCocos2dx::showConversation(
					string playerUid,
					int serverId,
					cocos2d::ValueMap& config);
	
**Coding Example：**

	ECServiceCocos2dx::setUserName ("PLAYER_NAME");
	ECServiceCocos2dx::showConversation(
					"PLAYER_ID",
					123,
					{ 
						elva-custom-metadata＝｛
						elva-tags＝'vip, pay1',
						VersionCode＝'3'
						｝
					});

**About Parameters：**

- __playerUid__:Unique User ID
- __serverId:__ The Unique Server ID
- __config__: Custom ValueMap information. You can pass specific Tag information using vector elva-tags, see the above coding example. Please note that you also need to configure the same tag information in the Web console to make each conversation be correctly tagged.

**Best Practice：**
> 1. Normally you do not need to use this method unless you intend to allow users to enter VIP conversations without engaging with the AI chat. You may use this method as a privilege for some users.

![showConversation](https://github.com/AIHELP-NET/Pictures/blob/master/showConversation-EN-Android.png "showConversation")


#### <h4 id="setSDKLanguage">11. Set SDK Lanague，use `setSDKLanguage`
</h4>
Setting the SDK Language will change the FAQs, Operational information, AI Chat and SDK display language. 

	ECServiceCocos2dx::setSDKLanguage(string language);
	
**Coding Example：**

	ECServiceCocos2dx::setSDKLanguage("en");

**About Parameters：**

- __language:__ Standard Language Alias. For example: en is for English, zh_CN is for Simplified Chinese. More language labels can be viewed through AIHelp Web Console:"Settings"-->"Language"->Alias.

![language](https://github.com/AI-HELP/Docs-Screenshots/blob/master/Language-alias.png "Language Alias")

**Best Practice：**
> 1. Normally AIHelp will use the mobile's lanaguge configuration by default. If you intend to make a different language setting, you need to use this method right after the SDK initialization.
> 2. If your allow users to change the APP language, then you need to use call this method to make AIHelp the same lanague with your APP.

#### 12. Set a Different Greeting Story Line.

If your APP provides multiple entries to AIHelp, and you intend to introduce different AI welcome texts and story lines to users from different entries, you can set config parameters in [showElva](#showElva) or [showElvaOP](#showElvaOP)： 

	map.put("anotherWelcomeText","usersay");

**Coding Example：**

	ArrayList<String> tags = new ArrayList();
	tags.add("vip");
	tags.add("pay1");
	HashMap<String,Object> map = new HashMap();
	map.put("elva-tags",tags);
	
	// note：anotherWelcomeText is key，should be unchanged.
	// you need to change usersay according to the "User Say" in your new 
	// story line
	map.put("anotherWelcomeText","usersay");
	HashMap<String,Object> config = new HashMap();
	config.put("elva-custom-metadata",map);
	

	ECServiceCocos2dx::showElva(
				"elvaTestName",
				"12349303258",
				1, 
				"",
				"1",
				config);
Or

	ECServiceCocos2dx::showElvaOP(
				"elvaTestName",
				"12349303258",
				1, 
				"",
				"1",
				config);


**Best Practice：**
> 1. Introduce different story lines to users from different sources.




