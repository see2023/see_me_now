# See
[En](./README.md)
## 简介 
- 创建这个助手应用的目的是提高孩子的学习效率，特别是那些有注意力缺陷的孩子。 
	- 当他们分心时，App通过适当的提醒来帮助他们集中注意力。 
	- 也可以作为常规的AI助手或ChatGPT客户端。 
- 该应用程序是使用Flutter开发的，屏蔽掉一些功能后可能也适用于桌面和web平台，但重点是移动平台(Android/IOS)。 
	- 使用的组件里，Google ML Kit只适用于Android/iOS。 
- 请参考下面的用例。
	- Video Demo
		- https://youtu.be/wBN7qTzh0UM
		- https://www.bilibili.com/video/BV1gs4y127An
	- Image preview

<img src="./doc/info.jpeg"  height="480">




## 用法

### 1 Install server

参考：
https://github.com/see2023/see_proxy

### 2 Install App

* Compile
`
cp ./lib/data/constants.dart.example ./lib/data/constants.dart
`
* 或者下载[release版本 ](https://github.com/see2023/see_me_now/releases)


### Tips
- Camera Observer
	- 坐姿(目前主要是头部角度)和微笑指数从前置摄像头获取(没有存储图片)来判断他们目前的学习状态
	- AI Reply
		- Enabled: 将上述数据发送到ChatGPT或类似界面，并让它提醒镜头前的人。
		- Disabled: 使用固定策略提醒
- Voice Reply
	- Auto Play
		- Enabled: AI应答完成后，自动播放语音
	- Tap to play
		- Enabled: 单击或双击消息，播放Azure TTS语音，并显示3d头像动画。
- See Proxy:
	- 您自己的服务器地址以代理chatgpt和azure tts
	- Key: 服务器中(Redis)设置的密钥
		- 您可以与家人或朋友共享
		- 可以按key设置使用量
- Prompts setting:
	- 在当前对话框中选择或编辑您自己的提示
	- 第一个作为后台提醒使用


## TODO
- AI委托策略
	- 将分析后的标签数据发给ChatGPT，获取并播放返回信息
		- 有点类似Auto-GPT, 但是我没有chatgpt4 API 权限, gpt-3.5-turbo用下来让人抓狂 -_-
- 固定策略
	- 策略优化
		- 分析更多来自摄像头的信息，目前只获取了头部角度和微笑指数
	- 声音分析
		- 听取孩子的声音，分析其中反映的状态
			- 例如，如果他们在说话时微笑，那么他们可能是在玩游戏，而不是在学习
			- 我自己找到最好的让孩子专注的方法，就是让他在写作业时大声读出来了
- Avatar
	- 将模型与动画分离
		- 我在blender里尝试了，但是分离出来的动画变形了
	- 支持在线链接(readyplayer.me 或其他平台)
		- 饰品和贴图设置
		- Avatar和声音的匹配
- 动画
	- 预先内置更多更好的动画
	- 实时生成的动画，来自：
		- 从摄像头获取的信息
		- AI的语音回复
- 交互优化
	- 更好的语音输入方法
- 其他平台的支持
	- Tested on Android: Kirin 990, HarmonyOS 2.0(Android 10.0), 8G RAM
- 减少ChatGPT token的使用
	- 当前的server是node写的，换成Python的话可以方便的使用LangChain的各种buffer
- 能耗优化
	- google ml kit大部分组件是CPU运行的...

## Thanks
作为传统行业的后端开发人员，这是我第一次尝试开发移动应用，还涉及到很多AI和3D相关的知识。 
感谢New Bing及以下支持:
- Flutter related
	- get
		- Saved a little from a pile of shit -_-
	- flutter_chat_ui
	- isar & hive
	- many more in [dependencies](./pubspec.yaml)
- AI related
	- openai
	- azure tts
	- google ml kit
	- https://prompts.chat/
- Avatar related
	- https://github.com/BabylonJS/Babylon.js
	- https://readyplayer.me/
	- https://www.mixamo.com/
	- https://www.blender.org/


## DISCUSSION
[讨论](https://github.com/see2023/see_me_now/discussions)

## LICENSE
Copy from the components used [license](./LICENSE)
