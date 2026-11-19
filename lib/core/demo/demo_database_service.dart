import 'package:fruit_hub_dash_board/core/demo/demo_data.dart';
import 'package:fruit_hub_dash_board/core/services/database_service.dart';
import 'package:fruit_hub_dash_board/core/utils/backend_endpoints.dart';

/// In-memory replacement for Firestore, used only in demo mode.
class DemoDatabaseService implements DatabaseService {
  final Map<String, Map<String, Map<String, dynamic>>> _db = {
    BackEndEndpoints.products: {
      for (final p in demoProducts) p['id'] as String: p,
    },
    BackEndEndpoints.orders: {
      for (final o in demoOrders(DateTime.now())) o['id'] as String: o,
    },
  };

  Future<void> _latency() =>
      Future.delayed(const Duration(milliseconds: 350));

  @override
  Future<void> addData({
    String? documentId,
    required String path,
    required Map<String, dynamic> data,
  }) async {
    await _latency();
    final id = documentId ?? DateTime.now().microsecondsSinceEpoch.toString();
    (_db[path] ??= {})[id] = {...data, 'id': data['id'] ?? id};
  }

  @override
  Future<void> updateData({
    required String path,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    await _latency();
    final doc = _db[path]?[documentId];
    if (doc == null) throw Exception('Document $documentId not found');
    doc.addAll(data);
  }

  @override
  Future<void> deleteData({
    required String path,
    required String documentId,
  }) async {
    await _latency();
    _db[path]?.remove(documentId);
  }

  @override
  Future<List<Map<String, dynamic>>> getCollection({
    required String path,
  }) async {
    await _latency();
    return (_db[path]?.values ?? [])
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }
}
