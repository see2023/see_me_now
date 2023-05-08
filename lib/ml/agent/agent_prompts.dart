import 'package:see_me_now/data/models/task.dart';

class AgentPromts {
  static Map<StateKey, String> stateKeyInfo = {
    StateKey.none: '',
    StateKey.appear: 'appear',
    StateKey.upright: 'sitting upright',
    StateKey.smile: 'smile'
  };
  static String gptPromptPrefix = '''
I hope you play the role of an intelligent decision assistant, helping users achieve their goals. 
Each time you will receive a JSON input, analyze the goal and current situation, provide appropriate suggestions, and output the conclusions in the required JSON format. 
''';
  static String askForJson =
      'Please refer to the requested json format, only the json content is returned';
  static Map<ActionType, String> agentPrompts = {
    ActionType.askGptForCreateTask: """$gptPromptPrefix
This time, you will obtain the task goal and description from the input JSON: goal, goalDescription, 
and user-inputted tasks as primary reference: userInput,
and yesterday's tasks to achieve the same goal: lastTasks,
as well as the experience summarized from historical tasks for the same goal: experience. 
Output is the list of tasks you analyzed, including task description(if userInput is Chinese, please reply in Chinese; Otherwise, please use English) and estimated time (in minutes),
 sorted by importance from front to back, and outputted in the required JSON format.
""",
    ActionType.askGptForNewExperience: """$gptPromptPrefix
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

Based on the above information, you need to analyze the validity of the experience used this time, and fine-tune the experience for better results when creating subsequent tasks for the same goal.
The output experience should be in the required json format.
""",
    ActionType.askGptForTaskProgressEvaluation: """$gptPromptPrefix
This time, you will obtain these fields from input JSON:
  goalName,
  goalDescription, 
  taskDescription,
  the estimated time of this task: estimatedTime,
  the time spent of this task: timeSpent,
  the experiences used to generate this task for this goal: experiencesUsed,
  questions asked by users during the task: questions,
  an array of indexes from environment: envStates, including:
    meaning of status values: stateName,
    the correlation values obtained from the external environment during the completion of the task: valueNow, 
    and the values of the same goal from the previous three days for comparison: valueBefore,
    positive = true here means that the higher score is better, vice versa.
Based on the above information, you need to assess the user's status and give reasonable advice to ensure that the task is completed on time; 
if you feel that the information is not enough to assess the current situation, you can also ask the user once for his or her own feedback and then give definitive advice, 
including progress reminders, secondary task discards, reminders of relevant knowledge, etc.
The output should be in the required json format.
"""
  };
}
