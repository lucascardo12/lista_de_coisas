enum ThemeEnum {
  original('Original', false),
  dark('Dark', true),
  blue('Azul', false),
  purple('Roxo', false);

  final String title;
  final bool isDark;

  const ThemeEnum(this.title, this.isDark);
}
