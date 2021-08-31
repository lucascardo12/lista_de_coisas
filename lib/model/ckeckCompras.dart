class CheckCompras {
  String? item;
  bool? feito;
  int? quant;
  double? valor;
  CheckCompras({
    this.item,
    this.feito,
    this.quant,
    this.valor,
  });

  CheckCompras.fromJson(Map<String, dynamic> xjson) {
    item = xjson['descri'];
    feito = xjson['feito'];
    quant = xjson['quant'];
    valor = xjson['valor'];
  }

  CheckCompras.toMap(Map<String, dynamic> map) {
    map["descri"] = item;
    map["feito"] = feito;
    map['quant'] = quant;
    map['valor'] = valor;
  }

  Map<String, dynamic> toJson() => {
        'descri': item,
        'feito': feito,
        'quant': quant,
        'valor': valor,
      };
}
