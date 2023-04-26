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
