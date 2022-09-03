abstract class IModel {
  String? idFire;

  late DateTime creatAp;
  late DateTime updatAp;

  IModel.fromJson(Map<String, dynamic> map);

  Map<String, dynamic> toJson();
}
