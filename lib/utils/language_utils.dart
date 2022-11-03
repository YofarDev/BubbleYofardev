class LanguageUtils {
  static int getColumnIndex(String codeLanguage) {
    switch (codeLanguage) {
      case 'fr':
        return 1;
      case 'en':
        return 2;
      default:
        return 1;
    }
  }
}
