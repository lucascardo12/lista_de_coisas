import 'package:listadecoisa/modules/listas/domain/models/coisas.dart';
import 'package:listadecoisa/modules/listas/domain/repositories/coisas_repository_inter.dart';

class CoisasRepository extends ICoisasRepository {
  CoisasRepository(super.remoteDataBase);

  @override
  String get idCollection => 'coisas';

  @override
  Future<void> createUpdate({required String idUser, required Coisas object}) async {
    object.updatAp = DateTime.now();
    await remoteDataBase.createUpdate(idUser: idUser, object: object, collection: idCollection);
  }

  @override
  Future<Coisas?> get({required String idUser, required String idDoc}) async {
    var ret = await remoteDataBase.get(idUser: idUser, collection: idCollection, idDoc: idDoc);
    if (ret == null) {
      return null;
    }
    return Coisas.fromJson(ret);
  }

  @override
  Future<List<Coisas>> list({required String idUser}) async {
    var ret = await remoteDataBase.list(idUser: idUser, collection: idCollection);
    return ret.map((e) => Coisas.fromJson(e)).toList();
  }

  @override
  Future<void> remove({required String idUser, required String idDoc}) async {
    await remoteDataBase.remove(idUser: idUser, idDoc: idDoc, collection: idCollection);
  }
}
