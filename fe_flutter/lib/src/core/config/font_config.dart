class FontConfig {
  static const Map<String, String> displayNames = {
    'ArchivoExpanded': 'Archivo Expanded',
    'LexendMega': 'Lexend Mega',
    'PublicSans': 'Public Sans',
    'MabryPro': 'Mabry Pro',
  };

  static const List<String> availableFonts = [
    'ArchivoExpanded',
    'LexendMega',
    'PublicSans',
    'MabryPro',
  ];

  static bool isItalic(String fontFamily) => fontFamily == 'ArchivoExpanded';

  static const String defaultFont = 'ArchivoExpanded';
}
