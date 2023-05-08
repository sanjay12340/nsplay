class RemoveDuplicate {
  static String removeDuplicateCharacters(String text) {
    Set<String> characters = Set();
    String result = '';
    for (int i = 0; i < text.length; i++) {
      if (!characters.contains(text[i])) {
        characters.add(text[i]);
        result += text[i];
      }
    }
    return result;
  }
}
