import 'package:listadecoisa/modules/listas/domain/models/coisas.dart';
import 'package:listadecoisa/core/services/banco.dart';

class CoisasRepository {
  final BancoFire remoteDataBase;
  CoisasRepository(this.remoteDataBase);

  String get idCollection => 'coisas';

  Future<void> createUpdate({required Coisas object}) async {
    object.updatAp = DateTime.now();
    await remoteDataBase.createUpdate(object: object, collection: idCollection);
  }

  Future<Coisas> get({required String idDoc}) async {
    final ret = await remoteDataBase.get(
      collection: idCollection,
      idDoc: idDoc,
    );
    if (ret == null) {
      throw Exception('Lista não encontrada');
    }
    return Coisas.fromJson(ret);
  }

  Future<List<Coisas>> list() async {
    final ret = await remoteDataBase.list(collection: idCollection);
    return ret.map((e) => Coisas.fromJson(e)).toList();
  }

  Future<void> remove({required String idDoc}) async {
    await remoteDataBase.remove(idDoc: idDoc, collection: idCollection);
  }
}
