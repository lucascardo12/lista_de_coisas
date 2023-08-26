enum ListViewType {
  grid(title: 'Grade'),
  list(title: 'Lista');

  final String title;

  const ListViewType({required this.title});

  static ListViewType fromString(String? type) {
    return switch (type) {
      'grid' => ListViewType.grid,
      'list' => ListViewType.list,
      _ => ListViewType.list, //Valor padrão, substitui o default
    };
  }
}
