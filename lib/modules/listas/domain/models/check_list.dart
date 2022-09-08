class Checklist {
  String item;
  bool feito;
  Checklist({
    required this.item,
    required this.feito,
  });

  Checklist.fromJson(Map<String, dynamic> xjson)
      : item = xjson['descri'] ?? '',
        feito = xjson['feito'] ?? false;

  Map<String, dynamic> toJson() => {'descri': item, 'feito': feito};
}
