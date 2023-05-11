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
