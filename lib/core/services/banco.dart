import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listadecoisa/core/interfaces/model_inter.dart';
import 'package:firebase_core/firebase_core.dart';

class BancoFire {
  late FirebaseFirestore db;

  Future<void> start() async {
    await Firebase.initializeApp();
    db = FirebaseFirestore.instance;
  }

  Future<void> createUpdate({
    required String idUser,
    required IModel object,
    required String collection,
  }) async {
    object.idFire ??= db
        .collection('user')
        .doc(idUser)
        .collection(collection)
        .doc()
        .id;
    db
        .collection('user')
        .doc(idUser)
        .collection(collection)
        .doc(object.idFire)
        .set(object.toJson());
  }

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

  Future<List<Map<String, dynamic>>> list({
    required String idUser,
    required String collection,
  }) async {
    final result = await db
        .collection('user')
        .doc(idUser)
        .collection(collection)
        .get();
    return result.docs.map((e) => Map<String, dynamic>.from(e.data())).toList();
  }

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
}
