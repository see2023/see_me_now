import 'package:see_me_now/data/models/task.dart';

class AgentPromts {
  static Map<StateKey, String> stateKeyInfo = {
    StateKey.none: '',
    StateKey.appear: 'appear',
    StateKey.upright: 'sitting upright',
    StateKey.smile: 'smile'
  };
  static const String splitString = '------';
  static const String progressActNeedMoreInfo = 'needMoreInfo';
  static const String progressActQuiz = 'quiz';
  static const String progressActNeedSearch = 'needSearch';
  static const String progressActTipsToUser = 'tipsToUser';
  static Map<String, String> progressEvaluationOutputFormatMap = {
    progressActNeedMoreInfo:
        '{"act":"needMoreInfo", "reason":"...", "text":"The information you want from your users"}',
    progressActQuiz:
        '{"act": "quiz", "reason":"...", "question": "...", "answer": "..."}',
    progressActNeedSearch:
        '{ "act": "needSearch","reason":"...","text": "less then 10 words as search key words"}',
    progressActTipsToUser:
        '{"act":"tipsToUser","reason":"...","text":"Tips for user(only when you are sure)"}'
  };
  static String gptPromptPrefixInit = '''
I hope you play the role of an intelligent decision assistant, helping users achieve their goals. 
Each time you will receive a JSON input, analyze the goal and current situation, provide appropriate suggestions, and output the conclusions in the required JSON format. 
''';
  static String gptPromptPrefixJson = gptPromptPrefixInit;
  static String gptPromptPrefix = '';
  static changeGptPromptPrefix(String userNickName, String userDescription) {
    if (userNickName.isNotEmpty && userDescription.isNotEmpty) {
      gptPromptPrefix =
          'You are talking to $userDescription, you can call him/her $userNickName.';
      gptPromptPrefixJson = '''$gptPromptPrefix
 $gptPromptPrefixInit''';
    }
  }

// Refer to the requested format, the output json starting with a curly brace is:
  static String askForJson = """
Refer to the requested format, the entire response in the json is:
""";

// Refer to the requested format, the output json starting with a curly brace and containing reply,style and motions is:
  static String askWithMotion = """

-----
Refer to the requested format, the entire response in the json containing reply,style and motions is:
""";

  static String askWithMotionFewShot = '''

-----
User - 'Good morning!'
Assistant - '{"reply": "Good morning! Have a nice day!", "style":"Oration", "motions":"wave hands in front of chest | nodding as appropriate"}'
-----
User - '今天天气很不错，刚出去骑车了，好开心！'
Assistant - '{"reply": "太好了!运动可有益健康了，坚持下去吧！", "style":"Happy", "motions":"Smiling widely | Jumping up and down | Clapping their hands | Spinning around"}'
-----
User - '摔跤了'
Assistant - '{"reply": "哎呀，要小心啊！希望你赶快康复", "style":"Sad", "motions":"pacing back and forth in the room | looking around nervously"}'
-----
"style" could be one of [Agreement|Angry|Disagreement|Distracted|Flirty|Happy|Laughing|Oration|Neutral|Pensive|Relaxed|Sad|Sarcastic|Scared|Sneaky|Still|Threatening|Tired|Old]
"motions" are the body movements that match the current reply and style.
-----
''';

  static Map<ActionType, String> agentPrompts = {
    ActionType.askGptForCreateTask: """$gptPromptPrefixJson
---Input---
This time, you will obtain the task goal and description from the input JSON: goal, goalDescription, 
and user-inputted tasks as primary reference: userInput,
and yesterday's tasks to achieve the same goal: lastTasks,
as well as the experience summarized from historical tasks for the same goal: experience. 
---Output---
1) Fill in the json field "reason" with the reason why you return these tasks;
2) "tasks" is the list of tasks you created after analysis, including task description and estimated time (in minutes),
 sorted by importance from front to back, and outputted in the required JSON format.
3) "keyword": One of the most important keyword for this task, used to find experience from similar tasks. Each task has its own specific keyword.
""",
    ActionType.askGptForNewExperience: """$gptPromptPrefixJson
---Input---
This time, you will obtain these fields from input JSON:
goalState, having these fields:
  goalName,
  goalDescription, 
  An array of tasks: 
    A description of a just-completed task: taskDescription,
    the estimated time: estimatedTimeInMinutes,
    the time spent: timeSpentInMinutes,
    the score given by the user himself for the completion of this task: score,
    evaluation from user: evaluation,
  An other array of indexes from environment:
    Meaning of status values: stateName,
    the correlation values obtained from the external environment during the completion of the task: valueNow, 
    and the values of the same goal from the previous three days for comparison: valueBefore.
    positive = true here means that the higher score is better, vice versa.
The experiences used to generate these tasks for this goal: experiencesUsed.
conversations between user and AI: conversations,
---Output---
1) Fill in the json field "reason" with the reason why you summarize these experiences;
2) "experiences" is your fine-tuned experience for better results when creating subsequent tasks for the same goal.
The output experience should be in the required json format.
""",
    ActionType.askGptForTaskProgressEvaluation: """$gptPromptPrefixJson
---Input---
This time, you will obtain these fields from input JSON:
  goalName,
  goalDescription, 
  taskDescription,
  the estimated time of this task: estimatedTimeInMinutes,
  the time spent of this task: timeSpentInMinutes,
  the experiences used to generate this task for this goal: experiencesUsed,
  conversations between user and AI: conversations: conversations, you need to avoid repetitive questions based on these conversations and give top-down, logical reminders,
  some other conversations between user and AI: minorConversations, (answer is cut off, no supplement required),
  an array of indexes from environment: envStates, including:
    meaning of status values: stateName,
    the correlation values obtained from the external environment during the completion of the task: valueNow, 
    and the values of the same goal from the previous three days for comparison: valueBefore,
    positive = true here means that the higher score is better, vice versa.
---Output---
0) Fill in the json field "reason" with the reason why you chose this action from a wide selection, to continue step-by-step communication;
1) You can ask the user about his real progress and other information that will help you to judge with: {"act":"needMoreInfo", "reason":"...", "text":"..."};
or 2) Propose a small quiz with answers to help users review and deepen their understanding: {"act":"quiz", "reason":"...", "question":"...", "answer":"..."};
or 3) Your knowledge is only available until September 2021, the current time is 2023, so when you encounter any time-sensitive content(News, IT Technologies ..); 
      perform a search first with {"act":"needSearch","reason":"...","text":"..."};
or 4) If there is enough reason, give reasonable advice to ensure that the task is completed on time with: {"act":"tipsToUser", "reason":"...", "text":"..."};
Please cherish the resources and don't caught in the Q&A cycle.
Always reply in required JSon!
"""
  };
}
