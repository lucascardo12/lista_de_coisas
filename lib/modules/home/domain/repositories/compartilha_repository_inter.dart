import 'package:listadecoisa/core/interfaces/remote_database_inter.dart';
import 'package:listadecoisa/modules/home/domain/models/compartilha.dart';

abstract class ICompartilhaRepository {
  String get idCollection;
  final IRemoteDataBase remoteDataBase;

  ICompartilhaRepository(this.remoteDataBase);

  Future<List<Compartilha>> list({
    required String idUser,
  });

  Future<void> createUpdate({
    required String idUser,
    required Compartilha object,
  });

  Future<void> remove({
    required String idUser,
    required String idDoc,
  });

  Future<Compartilha?> get({
    required String idUser,
    required String idDoc,
  });
}
