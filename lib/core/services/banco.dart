import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listadecoisa/core/interfaces/model_inter.dart';
import 'package:listadecoisa/core/interfaces/remote_database_inter.dart';
import 'package:listadecoisa/modules/auth/domain/models/user.dart';
import 'package:firebase_core/firebase_core.dart';

class BancoFire implements IRemoteDataBase {
  late FirebaseFirestore db;

  @override
  Future<void> start() async {
    await Firebase.initializeApp();
    db = FirebaseFirestore.instance;
  }

  @override
  Future<void> createUpdate({
    required String idUser,
    required IModel object,
    required String collection,
  }) async {
    object.idFire ??=
        db.collection('user').doc(idUser).collection(collection).doc().id;
    db
        .collection('user')
        .doc(idUser)
        .collection(collection)
        .doc(object.idFire)
        .set(object.toJson());
  }

  @override
  Future<String> createUser(UserP user) async {
    final DocumentSnapshot result =
        await db.collection('user').doc(user.id).get();
    return result.id;
  }

  @override
  Future<Map<String, dynamic>?> get({
    required String idUser,
    required String collection,
    required String idDoc,
  }) async {
    final result = await db
        .collection('user')
        .doc(idUser)
        .collection(collection)
        .doc(idDoc)
        .get();
    return result.data();
  }

  @override
  Future<List<Map<String, dynamic>>> list({
    required String idUser,
    required String collection,
  }) async {
    final result =
        await db.collection('user').doc(idUser).collection(collection).get();
    return result.docs.map((e) => Map<String, dynamic>.from(e.data())).toList();
  }

  @override
  Future<void> remove({
    required String idUser,
    required String idDoc,
    required String collection,
  }) async {
    await db
        .collection('user')
        .doc(idUser)
        .collection(collection)
        .doc(idDoc)
        .delete();
  }

  @override
  Future<UserP?> getUser(String uid) async {
    final DocumentSnapshot result = await db.collection('user').doc(uid).get();
    if (result.exists) {
      return UserP.fromJson(result.data());
    }
    return null;
  }
}
