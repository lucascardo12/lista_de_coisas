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
      : item = xjson['descri'] ?? '',
        feito = xjson['feito'] ?? false,
        quant = xjson['quant'] ?? 0,
        valor = xjson['valor'] ?? 0.0;

  Map<String, dynamic> toJson() => {
        'descri': item,
        'feito': feito,
        'quant': quant,
        'valor': valor,
      };
}
