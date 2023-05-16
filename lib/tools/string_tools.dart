import 'package:see_me_now/data/log.dart';

String extractJsonPart(String input) {
  // extract json part from input, remove content before fisrt { and after last }
  if (input.isEmpty) {
    return '';
  }
  int first = input.indexOf('{');
  int last = input.lastIndexOf('}');
  if (first == -1 || last == -1) {
    return '';
  }
  return input.substring(first, last + 1);
}

// compare two List<String> is equal or not
bool compareList(List<String> list1, List<String> list2) {
  if (list1.length != list2.length) {
    return false;
  }
  for (var i = 0; i < list1.length; i++) {
    if (list1[i] != list2[i]) {
      return false;
    }
  }
  return true;
}

int extractInt(String input) {
  // find first number string by regex, return int value
  try {
    if (input.isEmpty) {
      return 0;
    }
    RegExp reg = RegExp(r'\d+');
    Iterable<Match> matches = reg.allMatches(input);
    if (matches.isEmpty) {
      return 0;
    }
    Match m = matches.first;
    String? matchStr = m.group(0);
    return int.parse(matchStr ?? '0');
  } catch (e) {
    Log.log.warning('extractInt: $e');
    return 0;
  }
}
