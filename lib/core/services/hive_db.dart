import 'dart:async';
import 'package:hive/hive.dart';
import 'package:listadecoisa/core/interfaces/local_database_inter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class LocalDatabaseHive implements ILocalDatabase<String> {
  final complete = Completer();
  late Box box;

  @override
  void starts() async {
    var appDir = await getApplicationDocumentsDirectory();
    Hive.init(p.join(appDir.path));
    await carregaBoxs();
    complete.complete(true);
  }

  Future<void> carregaBoxs() async {
    await Hive.openBox('global').then((value) => box = value);
  }

  @override
  Future<void> create({
    required dynamic objeto,
    String? id,
  }) async {
    await complete.future;
    await box.put(id, objeto);
  }

  @override
  Future<void> delete({required String id}) async {
    await complete.future;
    box.delete(id);
  }

  @override
  Future<void> deleteAll() async {
    await complete.future;
    box.clear();
  }

  @override
  Future<dynamic> get({required String id}) async {
    await complete.future;
    return box.get(id);
  }

  @override
  Future<List<Map<String, dynamic>>> list({String? where}) async {
    await complete.future;
    return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  @override
  Future<void> update({
    required dynamic objeto,
    required String id,
  }) async {
    await complete.future;
    await box.put(id, objeto);
  }
}
