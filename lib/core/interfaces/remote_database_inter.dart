import 'package:listadecoisa/core/interfaces/model_inter.dart';
import 'package:listadecoisa/modules/auth/domain/models/user.dart';

abstract class IRemoteDataBase {
  Future<void> start();

  Future<List<Map<String, dynamic>>> list({
    required String idUser,
    required String collection,
  });

  Future<void> createUpdate({
    required String idUser,
    required IModel object,
    required String collection,
  });

  Future<void> remove({
    required String idUser,
    required String idDoc,
    required String collection,
  });

  Future<Map<String, dynamic>?> get({
    required String idUser,
    required String collection,
    required String idDoc,
  });

  Future<String> createUser(UserP user);

  Future<UserP?> getUser(String uid);
}
