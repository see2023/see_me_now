import 'package:see_me_now/data/models/task.dart';

class AgentPromts {
  static Map<StateKey, String> stateKeyInfo = {
    StateKey.none: '',
    StateKey.appear: 'appear',
    StateKey.upright: 'sitting upright',
    StateKey.smile: 'smile'
  };
  static const String splitString = '------';
  static const String progressKeyNeedMoreInfo = 'needMoreInfo';
  static const String progressKeyQuiz = 'quiz';
  static const String progressKeyNeedSearch = 'needSearch';
  static const String progressKeyTipsToUser = 'tipsToUser';
  static Map<String, String> progressEvaluationMap = {
    progressKeyNeedMoreInfo: 'What do you need to know from user',
    progressKeyQuiz: 'Quiz for user',
    progressKeyNeedSearch: 'Search key words',
    progressKeyTipsToUser: 'Tips for user(only when you are sure)'
  };
  static String gptPromptPrefix = '''
I hope you play the role of an intelligent decision assistant, helping users achieve their goals. 
Each time you will receive a JSON input, analyze the goal and current situation, provide appropriate suggestions, and output the conclusions in the required JSON format. 
''';
  static String askForJson =
      'Please refer to the requested json format, only the json content is returned';
  static Map<ActionType, String> agentPrompts = {
    ActionType.askGptForCreateTask: """$gptPromptPrefix
---Input---
This time, you will obtain the task goal and description from the input JSON: goal, goalDescription, 
and user-inputted tasks as primary reference: userInput,
and yesterday's tasks to achieve the same goal: lastTasks,
as well as the experience summarized from historical tasks for the same goal: experience. 
---Output---
Output is the list of tasks you analyzed, including task description(if userInput is Chinese, please reply in Chinese; Otherwise, please use English) and estimated time (in minutes),
 sorted by importance from front to back, and outputted in the required JSON format.
""",
    ActionType.askGptForNewExperience: """$gptPromptPrefix
---Input---
This time, you will obtain the global state from the input JSON: goalState, having these fields:
  goalName,
  goalDescription, 
  An array of tasks: 
    A description of a just-completed task: taskDescription,
    the estimated time: estimatedTime,
    the time spent: timeSpent,
    the score given by the user himself for the completion of this task: score,
  An other array of indexes from environment:
    Meaning of status values: stateName,
    the correlation values obtained from the external environment during the completion of the task: valueNow, 
    and the values of the same goal from the previous three days for comparison: valueBefore.
    positive = true here means that the higher score is better, vice versa.
The experiences used to generate these tasks for this goal: experiencesUsed.
---Output---
Based on the above information, you need to analyze the validity of the experience used this time, and fine-tune the experience for better results when creating subsequent tasks for the same goal.
The output experience should be in the required json format.
""",
    ActionType.askGptForTaskProgressEvaluation: """$gptPromptPrefix
---Input---
This time, you will obtain these fields from input JSON:
  goalName,
  goalDescription, 
  taskDescription,
  the estimated time of this task: estimatedTime,
  the time spent of this task: timeSpent,
  the experiences used to generate this task for this goal: experiencesUsed,
  conversations between user and AI: conversations,
  other conversations between user and AI: minorConversations, (answer is cut off, no supplement required),
  an array of indexes from environment: envStates, including:
    meaning of status values: stateName,
    the correlation values obtained from the external environment during the completion of the task: valueNow, 
    and the values of the same goal from the previous three days for comparison: valueBefore,
    positive = true here means that the higher score is better, vice versa.
---Output---
1) You can ask the user about his real progress and other information that will help you to judge with: {"type"="needMoreInfo", "text"={questions you want to ask}};
or 2) Propose a small quiz with answers to help users review and deepen their understanding: {"type"="quiz", "question"="...", "answer"="..."};
or 3) Your knowledge is only available until September 2021, the current time is 2023, so when you encounter any time-sensitive content(News, IT Technologies ..); 
      perform a search first with {"type"="needSearch", "text"={less then 10 words as search key words}};
or 4) If there is enough reason, give reasonable advice to ensure that the task is completed on time with: {"type="tipsToUser", "text"={infomation shown to user}};
Please cherish the resources and don't caught in the Q&A cycle.
The output should be in the required json format.
"""
  };
}
