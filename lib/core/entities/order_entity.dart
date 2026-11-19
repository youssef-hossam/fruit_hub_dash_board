/// Same order shape the client app writes to the `orders` collection, so a
/// status changed here shows up right away in the customer's "My orders".
enum OrderStatus { pending, preparing, onTheWay, delivered, cancelled }

extension OrderStatusX on OrderStatus {
  String get label => switch (this) {
        OrderStatus.pending => 'جديد',
        OrderStatus.preparing => 'جاري التجهيز',
        OrderStatus.onTheWay => 'في الطريق',
        OrderStatus.delivered => 'تم التوصيل',
        OrderStatus.cancelled => 'ملغي',
      };

  /// The next step in the normal flow, or null when the order is closed.
  OrderStatus? get next => switch (this) {
        OrderStatus.pending => OrderStatus.preparing,
        OrderStatus.preparing => OrderStatus.onTheWay,
        OrderStatus.onTheWay => OrderStatus.delivered,
        _ => null,
      };

  bool get isOpen =>
      this != OrderStatus.delivered && this != OrderStatus.cancelled;
}

class OrderItemEntity {
  final String productId;
  final String name;
  final String imageUrl;
  final double price;
  final String unit;
  final int quantity;

  const OrderItemEntity({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.unit,
    required this.quantity,
  });

  double get total => price * quantity;
}

class ShippingAddressEntity {
  final String fullName;
  final String phone;
  final String address;
  final String city;
  final String floor;

  const ShippingAddressEntity({
    required this.fullName,
    required this.phone,
    required this.address,
    required this.city,
    required this.floor,
  });
}

class OrderEntity {
  final String id;
  final String uid;
  final List<OrderItemEntity> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String paymentMethod;
  final OrderStatus status;
  final ShippingAddressEntity address;
  final DateTime createdAt;

  const OrderEntity({
    required this.id,
    required this.uid,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.paymentMethod,
    required this.status,
    required this.address,
    required this.createdAt,
  });

  int get itemsCount => items.fold(0, (sum, e) => sum + e.quantity);

  OrderEntity copyWith({OrderStatus? status}) => OrderEntity(
        id: id,
        uid: uid,
        items: items,
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        total: total,
        paymentMethod: paymentMethod,
        status: status ?? this.status,
        address: address,
        createdAt: createdAt,
      );
}
