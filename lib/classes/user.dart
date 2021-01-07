class UserP {
  String id;
  String nome;
  String senha;
  String login;

  UserP({String id, String nome, String login, String senha}) {
    this.id = id;
    this.nome = nome;
    this.login = login;
    this.senha = senha;
  }
  UserP.fromJson(Map<String, dynamic> xjson) {
    nome = xjson['nome'];
    id = xjson['id'];
    login = xjson['login'];
  }

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'id': id,
        'login': login,
      };
  UserP.toMap(Map<String, dynamic> map) {
    map["nome"] = nome;
    map["id"] = id;
    map['login'] = login;
  }
}
