class UserP {
  String id;
  String nome;
  String senha;
  String login;

  UserP({String id, String nome, String senha, String login}) {
    this.id = id;
    this.nome = nome;
    this.senha = senha;
    this.login = login;
  }
  UserP.fromJson(Map<String, dynamic> xjson) {
    nome = xjson['nome'];
    senha = xjson['senha'];
    id = xjson['id'];
    login = xjson['login'];
  }

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'senha': senha,
        'id': id,
        'login': login,
      };
  UserP.toMap(Map<String, dynamic> map) {
    map["nome"] = nome;
    map["senha"] = senha;
    map["id"] = id;
    map['login'] = login;
  }
}
