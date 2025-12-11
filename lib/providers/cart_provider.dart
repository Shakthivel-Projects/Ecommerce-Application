import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/cart_items.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};   // KEY UPDATE: CartItem type used

  Map<String, CartItem> get items => _items;

  double get totalAmount =>
      _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);

  void addToCart(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += 1;
    } else {
      _items[product.id] = CartItem(product: product, quantity: 1);
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (_items.containsKey(productId)) {
      _items[productId]!.quantity = quantity;
      if (quantity <= 0) {
        _items.remove(productId);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  // Converts cart into JSON format for Order creation
  List<Map<String, dynamic>> toOrderItemsJson() {
    return _items.values
        .map((e) => {
              'product': e.product.id,
              'title': e.product.title,
              'image': e.product.image,
              'price': e.product.price,
              'qty': e.quantity,
            })
        .toList();
  }
}
