import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listadecoisa/core/interfaces/model_inter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:developer';

import 'package:listadecoisa/modules/auth/domain/services/auth_service.dart';

class BancoFire {
  late FirebaseFirestore db;
  final AuthService authService;

  BancoFire(this.authService);

  Future<void> start() async {
    log('Iniciando configuração do Firebase');
    try {
      await Firebase.initializeApp();
      db = FirebaseFirestore.instance;
      log('Firebase inicializado com sucesso');
    } catch (e, s) {
      log('Erro ao inicializar Firebase: $e', stackTrace: s);
      rethrow;
    }
  }

  String get userId => authService.currentUser!.uid;

  Future<void> createUpdate({
    required IModel object,
    required String collection,
  }) async {
    log(
      'Iniciando operação create/update - Usuário: $userId, Coleção: $collection',
    );
    try {
      object.idFire ??= db
          .collection('user')
          .doc(userId)
          .collection(collection)
          .doc()
          .id;

      log('ID do documento: ${object.idFire}');

      await db
          .collection('user')
          .doc(userId)
          .collection(collection)
          .doc(object.idFire)
          .set(object.toJson());

      log('Operação create/update concluída com sucesso');
    } catch (e, s) {
      log('Erro na operação create/update: $e', stackTrace: s);
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> get({
    required String collection,
    required String idDoc,
  }) async {
    log(
      'Buscando documento - Usuário: $userId, Coleção: $collection, ID: $idDoc',
    );
    try {
      final result = await db
          .collection('user')
          .doc(userId)
          .collection(collection)
          .doc(idDoc)
          .get();

      final data = result.data();
      log(
        data != null
            ? 'Documento encontrado com sucesso'
            : 'Documento não encontrado',
      );
      return data;
    } catch (e, s) {
      log('Erro ao buscar documento: $e', stackTrace: s);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> list({required String collection}) async {
    log('Listando documentos - Usuário: $userId, Coleção: $collection');
    try {
      final result = await db
          .collection('user')
          .doc(userId)
          .collection(collection)
          .get();

      final documents = result.docs
          .map((e) => Map<String, dynamic>.from(e.data()))
          .toList();
      log('Listagem concluída: ${documents.length} documentos encontrados');
      return documents;
    } catch (e, s) {
      log('Erro na listagem de documentos: $e', stackTrace: s);
      rethrow;
    }
  }

  Future<void> remove({
    required String idDoc,
    required String collection,
  }) async {
    log(
      'Removendo documento - Usuário: $userId, Coleção: $collection, ID: $idDoc',
    );
    try {
      await db
          .collection('user')
          .doc(userId)
          .collection(collection)
          .doc(idDoc)
          .delete();

      log('Documento removido com sucesso');
    } catch (e, s) {
      log('Erro ao remover documento: $e', stackTrace: s);
      rethrow;
    }
  }
}
