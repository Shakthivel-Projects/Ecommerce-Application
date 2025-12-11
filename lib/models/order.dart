class OrderItem {
  final String productId;
  final String title;
  final String image;
  final double price;
  final int qty;

  OrderItem({
    required this.productId,
    required this.title,
    required this.image,
    required this.price,
    required this.qty,
  });

  Map<String, dynamic> toJson() => {
        'product': productId,
        'title': title,
        'image': image,
        'price': price,
        'qty': qty,
      };

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['product'],
      title: json['title'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
      qty: json['qty'],
    );
  }
}

class ShippingAddress {
  final String fullName;
  final String address;
  final String city;
  final String postalCode;
  final String country;

  ShippingAddress({
    required this.fullName,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.country,
  });

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'address': address,
        'city': city,
        'postalCode': postalCode,
        'country': country,
      };

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      fullName: json['fullName'],
      address: json['address'],
      city: json['city'],
      postalCode: json['postalCode'],
      country: json['country'],
    );
  }
}

class Order {
  final String id;
  final List<OrderItem> items;
  final ShippingAddress shippingAddress;
  final double totalPrice;
  final bool isPaid;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.items,
    required this.shippingAddress,
    required this.totalPrice,
    required this.isPaid,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      items: (json['orderItems'] as List)
          .map((e) => OrderItem.fromJson(e))
          .toList(),
      shippingAddress: ShippingAddress.fromJson(json['shippingAddress']),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      isPaid: json['isPaid'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
