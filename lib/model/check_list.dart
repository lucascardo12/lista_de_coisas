class Checklist {
  String? item;
  bool? feito;
  Checklist({
    this.item,
    this.feito,
  });

  Checklist.fromJson(Map<String, dynamic> xjson) {
    item = xjson['descri'];
    feito = xjson['feito'];
  }

  Checklist.toMap(Map<String, dynamic> map) {
    map["descri"] = item;
    map["feito"] = feito;
  }

  Map<String, dynamic> toJson() => {'descri': item, 'feito': feito};
}
