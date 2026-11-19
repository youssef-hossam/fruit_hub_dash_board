import 'package:fruit_hub_dash_board/core/entities/order_entity.dart';

/// Reads the orders the client app writes (see fruit_hup_app OrderModel).
abstract class OrderModel {
  static OrderEntity fromJson(Map<String, dynamic> json) {
    final address = Map<String, dynamic>.from(json['address'] ?? {});
    return OrderEntity(
      id: (json['id'] ?? '') as String,
      uid: (json['uid'] ?? '') as String,
      items: ((json['items'] as List?) ?? []).map((e) {
        final m = Map<String, dynamic>.from(e);
        return OrderItemEntity(
          productId: (m['productId'] ?? '') as String,
          name: (m['name'] ?? '') as String,
          imageUrl: (m['imageUrl'] ?? '') as String,
          price: (m['price'] as num? ?? 0).toDouble(),
          unit: (m['unit'] ?? 'كيلو') as String,
          quantity: (m['quantity'] as num? ?? 1).toInt(),
        );
      }).toList(),
      subtotal: (json['subtotal'] as num? ?? 0).toDouble(),
      deliveryFee: (json['deliveryFee'] as num? ?? 0).toDouble(),
      total: (json['total'] as num? ?? 0).toDouble(),
      paymentMethod: (json['paymentMethod'] ?? 'cash') as String,
      status: OrderStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      address: ShippingAddressEntity(
        fullName: (address['fullName'] ?? '') as String,
        phone: (address['phone'] ?? '') as String,
        address: (address['address'] ?? '') as String,
        city: (address['city'] ?? '') as String,
        floor: (address['floor'] ?? '') as String,
      ),
      createdAt:
          DateTime.tryParse((json['createdAt'] ?? '') as String) ??
          DateTime.now(),
    );
  }
}
