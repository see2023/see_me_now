import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'askUserForTasks': 'What do you need to do today about @name ?',
          'MathHomework': 'Math homework',
          'EnglishHomework': 'English homework',
          'ChineseHomework': 'Chinese homework',
          'SportAndRelax': 'Sports and relaxation',
          'ReplyLanguage': 'Please reply in English.',
          'ShowAnswer': 'Show answer',
        },
        'zh_CN': {
          'askUserForTasks': '你今天有什么 @name 的计划吗?',
          'MathHomework': '数学作业',
          'EnglishHomework': '英语作业',
          'ChineseHomework': '语文作业',
          'SportAndRelax': '运动与放松',
          'ReplyLanguage': 'Please reply in Chinese.',
          'ShowAnswer': '显示答案',
        },
      };
}
