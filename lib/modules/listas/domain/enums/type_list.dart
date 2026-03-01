enum TypeList {
  text('Texto Simples'),
  check('Check-List'),
  checkout('Lista de Compras');

  const TypeList(this.title);

  final String title;

  factory TypeList.fromString(dynamic id) {
    return TypeList.values[int.tryParse(id.toString()) ?? 0];
  }
}
