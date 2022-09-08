abstract class ILocalDatabase<T> {
  void starts();

  Future<List> list({T? where});

  Future<dynamic> get({required String id});

  Future<void> create({
    required dynamic objeto,
    String? id,
  });

  Future<void> update({
    required dynamic objeto,
    required String id,
  });

  Future<void> delete({required String id});

  Future<void> deleteAll();
}
