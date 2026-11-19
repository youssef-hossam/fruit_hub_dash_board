abstract class DatabaseService {
  Future<void> addData({
    String? documentId,
    required String path,
    required Map<String, dynamic> data,
  });

  Future<void> updateData({
    required String path,
    required String documentId,
    required Map<String, dynamic> data,
  });

  Future<void> deleteData({required String path, required String documentId});

  /// Returns every document in [path]; the document id is added as `id`
  /// when the document itself doesn't store one.
  Future<List<Map<String, dynamic>>> getCollection({required String path});
}
