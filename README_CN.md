## 接入说明
### 1. 下载AIHelp Cocos2d-x iOS SDK：
点击页面右上角的“Clone or download”按钮下载iOS SDK，下载完成后解压文件。
aihelp-plugin-cocos2dx文件包含：

| 文件夹 | 说明 |
|:------------- |:---------------|
| **ios/ElvaChatServiceSDK**    | AIHelp iOS SDK文件|
| **v3.x/Classes**      | Cocos2dx 版本3.x 所需cpp接口文件|
| **v2.x/Classes**      | Cocos2dx 版本2.x 所需cpp接口文件| 
### 2. 把AIHelp SDK 放入你的Cocos2dx 工程：
**a. 把ios/ElvaChatServiceSDK文件夹拷贝到你的Cocos2d-x Xcode工程根目录**

**b. 把Classes文件夹下面的cpp接入文件拷贝到您的Cocos2d-x工程的Classes文件夹, 根据你的Cocos2dx版本来选择不同的文件**

**c. 把所需要的frameworks加入你的Cocos2d-x Xcode工程（Link Frameworks and Libraries)：**

- CoreGraphics
- QuartzCore
- CoreText
- SystemConfiguration
- UIKit
- libsqlite3.0.dylib
- Security
- CoreSpotlight
- GameController(required by cocos2d-x)
- MediaPlayer(required by cocos2d-x)
- Webkit(if [operation module](#showElvaOP) is used )

```
注意：
在Xcode工程的Build Settings，在'Other linker flags'中加入'-ObjC'. 如下图：

```

![Linker](https://github.com/AI-HELP/Docs-Screenshots/blob/master/integration-linker-flag.png "Add '-ObjC' Flag")


### 3. 在你的工程中初始化AIHelp SDK

```
注意：
在你的游戏初始化时调用 ECServiceCocos2dx::init(...)，传入必要的参数。
```

```
ECServiceCocos2dx::init(
			String appKey,
			String domain,
			String appId);
```
	


* 参数说明：

| 参数 | 说明 |
|:------------- |:---------------|
| appKey    | app唯一密钥，从AIHelp Web管理系统获取|
| domain     | 您的AIHelp域名，从Web管理系统获取,例如foo.AIHELP.NET|
| appId     | app唯一标识，从Web管理系统获取| 


注：请使用注册邮箱登录 [AIHelp 后台](https://aihelp.net/elva)。在Settings菜单Applications页面查看appId, appKey和domain。初次使用，需登录[AIHelp 官网](http://aihelp.net/index.html)自助注册。


**初始化代码示例：**

```
// 一定要在应用启动时进行初始化init操作，不然会无法进入AIHelp智能客服系统。
ECServiceCocos2dx::init(
			"YOUR_API_KEY",
			"YOUR_DOMAIN_NAME",
			"YOUR_APP_ID");
```

---

### 4. 使用AIHelp 接口


#### 1. 接口说明

| 接口名 | 作用 |备注|
|:------------- |:---------------|:---------------|
| **[showElva](#showElva)**      | 启动机器人客服聊天界面| 
| **[showElvaOP](#showElvaOP)** | 启动运营界面| 需配置运营模块|
| **[showFAQs](#showFAQs)** | 展示全部FAQ菜单|需配置FAQ|
|**[showConversation](#showConversation)**|启动人工客服聊天界面| 需调用setUserName 和setUserId|
| **[showSingleFAQ](#showSingleFAQ)** | 展示单条FAQ|需配置FAQ|
| **[setName](#setName)** | 设置游戏名称|在初始化之后调用|
| **[setUserName](#UserName)** | 设置玩家(用户)名称|
| **[setUserId](#UserId)** | 设置玩家(用户)ID|
| **[setSDKLanguage](#setSDKLanguage)** | 设置SDK语言|


**注：您并不需要调用以上所有接口，尤其当您的游戏/应用只设置一个客服入口时, 有的接口所展示的界面包含了其他接口，详情见下：**

#### <h4 id="showElva">2. 智能客服主界面启动，调用`showElva`接口，启动机器人客服聊天界面</h4>


	ECServiceCocos2dx::showElva(
				string playerName,
				string playerUid,
				int serverId,
				string playerParseId,
				string showConversationFlag);
			

或

	ECServiceCocos2dx::showElva(
				string playerName,
				string playerUid,
				int serverId,
				string playerParseId,
				string showConversationFlag,
				cocos2d::ValueMap& config);

**代码示例：**

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
					hs-custom-metadata＝｛
					hs-tags＝'军队,充值',
					VersionCode＝'3'
					｝
				});
	}

**参数说明：**

- playerName:游戏中用户名称。 
- playerUid:用户在游戏里的唯一标识。 
- serverId:用户所在的服务器编号。 
- playerParseId:设置为空字符串（不可为NULL)
- showConversationFlag(0或1):是否开启人工入口。此处为1时，将在机器人的聊天界面右上角，提供人工聊天的入口。如下图。
- config:可选，自定义ValueMap信息。可以在此处设置特定的Tag信息。说明：hs-tags对应的值为vector类型，此处传入自定义的Tag，需要在Web管理配置同名称的Tag才能生效。
	
![showElva](https://github.com/AI-HELP/Docs-Screenshots/blob/master/showElva-CN-Android.png "showElva")
	
**最佳实践：**

> 1. 在您应用的客服主入口触发这个接口的调用。
在AIHelp 配置个性化的机器人欢迎语，以及更多机器人对话故事线，引导用户反馈并得到回答。
> 2. 打开人工客服入口，用户可以在机器人客服界面右上角进入人工客服进行聊天, 你也可以设置条件只让一部分用户看到这个入口

#### <h4 id="showElvaOP">3. 智能客服运营模块主界面启动，调用`showElvaOP`方法，启动运营模块界面</h4>

	ECServiceCocos2dx::showElvaOP(
				string playerName,
				string playerUid,
				int serverId,
				string playerParseId,
				string showConversationFlag,
				cocos2d::ValueMap& config);

或

	ECServiceCocos2dx::showElvaOP(
				string playerName,
				string playerUid,
				int serverId,
				string playerParseId,
				string showConversationFlag,
				cocos2d::ValueMap& config,
				int defaultTabIndex);

**代码示例：**

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
						hs-custom-metadata＝｛
						hs-tags＝'军队,充值',
						VersionCode＝'3'
						｝
					});
	}

**参数说明：**

- playerName:游戏中用户名称。 
- playerUid:用户在游戏里的唯一标识。 
- serverId:用户所在的服务器编号。 
- playerParseId:设置为空字符串（不可为NULL)
- showConversationFlag(0或1):是否开启人工入口。此处为1时，将在机器人的聊天界面右上角，提供人工聊天的入口。如下图。
- config: 自定义ValueMap信息。可以在此处设置特定的Tag信息。说明：hs-tags对应的值为vector类型，此处传入自定义的Tag，需要在Web管理配置同名称的Tag才能生效。
- defaultTabIndex: 首次进入运营界面时候展示的tab的编号，默认为第一个tab，若需默认展示客服界面tab，设置值为999
	
![showElva](https://github.com/AI-HELP/Docs-Screenshots/blob/master/showElvaOP_Android.png "showElvaOP")

**最佳实践：**
> 1. 在您应用的运营入口触发这个接口的调用。
在AIHelp 后台配置运营分页（tab)并且发布跟应用相关的运营公告内容。就通过AIHelp展示这些内容给用户。运营界面的最后一个分页总是机器人客服聊天界面。
> 2. 通过参数打开人工客服入口，用户可以在机器人客服分页的右上角进入人工客服进行聊天, 你也可以设置条件只让一部分用户看到这个入口

#### <h4 id="showFAQs">4. 展示FAQ列表, 调用`showFAQs `方法</h4>

	ECServiceCocos2dx::showFAQs();

或

	ECServiceCocos2dx::showFAQs (cocos2d::ValueMap& config)

**代码示例：**

	// Presenting FAQs to your customers
	void GameSettingsScene::menuFAQCallback(CCObject* pSender)
	{						
		ECServiceCocos2dx::showFAQs (
					{ 
						hs-custom-metadata＝｛
						hs-tags＝'军队,充值',
						VersionCode＝'3'
						｝
					});
	}

**参数说明：**

- config:可选，自定义ValueMap信息。可以在此处设置特定的Tag信息。说明：hs-tags对应的值为vector类型，此处传入自定义的Tag，需要在Web管理配置同名称的Tag才能生效。
	
![showElva](https://github.com/AI-HELP/Docs-Screenshots/blob/master/showFAQs-CN-Android.png "showFAQs")

**最佳实践：**
> 1. 在您应用的FAQ主入口触发这个接口的调用。在AIHelp 后台页面配置并分类FAQ，如果您的FAQ较多，可以增加一个父级分类。

#### <h4 id="showSingleFAQ">5. 展示单条FAQ，调用`showSingleFAQ`方法
</h4>

	ECServiceCocos2dx::showSingleFAQ(string faqId);

或

	ECServiceCocos2dx::showSingleFAQ(
				string faqId,
				cocos2d::ValueMap& config);

**代码示例：**

	// Presenting FAQs to your customers
	void GameSettingsScene::menuFAQCallback(CCObject* pSender)
	{						
		ECServiceCocos2dx::showSingleFAQ (
					"20",
					{ 
						hs-custom-metadata＝｛
						hs-tags＝'军队,充值',
						VersionCode＝'3'
						｝
					});
	}

**参数说明：**

- faqId:FAQ的PublishID,可以在[AIHelp 后台](https://aihelp.net/elva)中，从FAQs菜单下找到指定FAQ，查看PublishID。
- config:可选，自定义ValueMap信息。可以在此处设置特定的Tag信息。说明：hs-tags对应的值为vector类型，此处传入自定义的Tag，需要在Web管理配置同名称的Tag才能生效。
	
![showSingleFAQ](https://github.com/CS30-NET/Pictures/blob/master/showSingleFAQ-CN-Android.png "showSingleFAQ")

<h4 id="selfservice"></h4>

自助服务：
如果在web管理后台配置了FAQ的自助服务链接，并且SDK设置了[UserId](#UserId), [UserName](#UserName), [ServerId](#ServerId)，将在显示FAQ的同时，右上角提供功能菜单，可以对相关的自助服务进行调用。


**最佳实践：**
> 1. 在您应用的特定功能入口触发这个接口的调用，可以方便用户了解具体功能相关的FAQ。


#### <h4 id="setName">6. 设置游戏名称信息，调用`setName`方法(建议游戏刚进入，调用init之后就默认调用)</h4>

	ECServiceCocos2dx::setName(string game_name);

**代码示例：**

	ECServiceCocos2dx::setName("Your Game");

**参数说明：**

- game_name:游戏名称

**最佳实践：**
> 1. 在初始化后调用该接口设置游戏名称，将显示在AIHelp相关界面标题栏。

#### <h4 id="UserId">7. 设置用户唯一ID信息，调用`setUserId`方法</h4>


	ECServiceCocos2dx::setUserId(string playerUid);

**代码示例：**

	ECServiceCocos2dx::setUserId("123ABC567DEF");

**参数说明：**

- playerUid:用户唯一ID

**最佳实践：**
> 1. 通常你可以用在其他接口传入用户Id，无需调用该接口，但是若要使用[自助服务](#selfservice)，则必须调用。

#### <h4 id="UserName">8. 设置用户名称信息，调用`setUserName`方法</h4>

	ECServiceCocos2dx::setUserName (string playerName);

**代码示例：**

	ECServiceCocos2dx::setUserName ("PLAYER_NAME");

**参数说明：**

- playerName:用户名称

**最佳实践：**
> 1. 传入你的App的用户名称，这样在后台客户服务页面会展示用户的应用内名称，便于客服在服务用户时个性化称呼对方。
> 2. 通常你无需调用该接口，可以用其他接口传入用户名称，但是若要使用[自助服务](#selfservice)，则必须调用。

#### <h4 id="ServerId">9. 设置服务器唯一ID信息，调用`setServerId`方法
</h4>

	ECServiceCocos2dx::setServerId(int serverId);

**代码示例：**

	ECServiceCocos2dx::setServerId("SERVER_ID");

**参数说明：**

- serverId:服务器ID

**最佳实践：**
> 1. 通常你无需调用该接口，可以用其他接口传入服务器ID，但是若要使用[自助服务](#selfservice)，则必须调用。


#### <h4 id="showConversation">10. 直接进入人工客服聊天，调用`showConversation`方法(要求设置[UserName](#UserName))</h4>

	ECServiceCocos2dx::showConversation(
					string playerUid,
					int serverId);
或

	ECServiceCocos2dx::showConversation(
					string playerUid,
					int serverId,
					cocos2d::ValueMap& config);
	
**代码示例：**

	ECServiceCocos2dx::setUserName ("PLAYER_NAME");
	ECServiceCocos2dx::showConversation(
					"PLAYER_ID",
					123,
					{ 
						hs-custom-metadata＝｛
						hs-tags＝'军队,充值',
						VersionCode＝'3'
						｝
					});

**参数说明：**

- playerUid:用户在游戏里的唯一标识
- serverId:用户所在的服务器编号
- config:可选参数，自定义ValueMap信息。可以在此处设置特定的Tag信息。说明：hs-tags对应的值为vector类型，此处传入自定义的Tag，需要在Web管理配置同名称的Tag才能生效。

**最佳实践：**
> 1. 通常你不需要调用这个接口，除非你想在应用里设置触发点，让用户有机会直接进入人工客服聊天界面。

![showConversation](https://github.com/CS30-NET/Pictures/blob/master/showConversation-CN-Android.png "showConversation")


#### <h4 id="setSDKLanguage">11. 设置语言，调用`setSDKLanguage`方法
</h4>

	ECServiceCocos2dx::setSDKLanguage(string language);
	
**代码示例：**

	ECServiceCocos2dx:: setSDKLanguage("en");

**参数说明：**

- language:语言名称。如英语为en,简体中文为zh_CN。更多语言简称参见AIHelp后台，"设置"-->"语言"的Alias列。

![language](https://github.com/AI-HELP/Docs-Screenshots/blob/master/Language-alias.png "语言Alias列")

**最佳实践：**
> 1. 通常SDK会使用手机的默认语言设置，如果你的应用使用跟手机设置不一样的语言，那么你需要在AIHelp SDK初始化之后调用此接口修改默认语言。
> 2. 如果你的应用允许用户更改语言，那么每次更改语言之后，也需要调用此接口重新设置SDK的语言。


#### 12. 设置另一个欢迎语。

如果你设置了进入AI客服的不同入口，希望用户从不同的入口进入AI客服时显示不同的欢迎语，进入不同故事线，可以通过设置config参数来实现： 

	map.put("anotherWelcomeText","usersay");

	
**代码示例：**

	ArrayList<String> tags = new ArrayList();
	tags.add("军队");
	tags.add("充值");
	HashMap<String,Object> map = new HashMap();
	map.put("hs-tags",tags);
	
	//调用不同故事线功能，使用指定的提示语句，调出相应的机器人欢迎语
	//注：anotherWelcomeText是key，不能改变。
	//需要改变的是usersay，保持和故事线中配置的User Say内容一样
	map.put("anotherWelcomeText","usersay");
	HashMap<String,Object> config = new HashMap();
	config.put("hs-custom-metadata",map);
	
	//如果是在智能客服主界面中	
	ECServiceCocos2dx::showElva(
				"elvaTestName",
				"12349303258",
				1, 
				"",
				"1",
				config);
或

	//如果是在智能客服运营主界面中
	ECServiceCocos2dx::showElvaOP(
				"elvaTestName",
				"12349303258",
				1, 
				"",
				"1",
				config);


**最佳实践：**
> 1. 引导玩家从不同入口看到不同的服务





