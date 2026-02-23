import 'package:listadecoisa/modules/home/domain/models/compartilha.dart';
import 'package:listadecoisa/modules/home/domain/repositories/compartilha_repository_inter.dart';

class CompartilhaRepository extends ICompartilhaRepository {
  CompartilhaRepository(super.remoteDataBase);

  @override
  String get idCollection => 'compartilha';

  @override
  Future<void> createUpdate({
    required String idUser,
    required Compartilha object,
  }) async {
    object.updatAp = DateTime.now();
    await remoteDataBase.createUpdate(
      idUser: idUser,
      object: object,
      collection: idCollection,
    );
  }

  @override
  Future<Compartilha?> get({
    required String idUser,
    required String idDoc,
  }) async {
    final ret = await remoteDataBase.get(
      idUser: idUser,
      collection: idCollection,
      idDoc: idDoc,
    );
    if (ret == null) {
      return null;
    }
    return Compartilha.fromJson(ret);
  }

  @override
  Future<List<Compartilha>> list({required String idUser}) async {
    final ret =
        await remoteDataBase.list(idUser: idUser, collection: idCollection);
    return ret.map((e) => Compartilha.fromJson(e)).toList();
  }

  @override
  Future<void> remove({required String idUser, required String idDoc}) async {
    await remoteDataBase.remove(
      idUser: idUser,
      idDoc: idDoc,
      collection: idCollection,
    );
  }
}
