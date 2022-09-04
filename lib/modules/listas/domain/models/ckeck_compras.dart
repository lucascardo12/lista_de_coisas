class CheckCompras {
  String item;
  bool feito;
  int quant;
  double valor;

  CheckCompras({
    required this.item,
    required this.feito,
    required this.quant,
    required this.valor,
  });

  CheckCompras.fromJson(Map<String, dynamic> xjson)
      : item = xjson['descri'],
        feito = xjson['feito'],
        quant = xjson['quant'],
        valor = xjson['valor'];

  Map<String, dynamic> toJson() => {
        'descri': item,
        'feito': feito,
        'quant': quant,
        'valor': valor,
      };
}
