import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/product_api.dart';

class ProductProvider extends ChangeNotifier {
  final ProductApi _api = ProductApi();

  List<Product> _products = [];
  bool _loading = false;
  String? _error;

  List<Product> get products => _products;
  bool get isLoading => _loading;
  String? get error => _error;

  Future<void> loadProducts() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _products = await _api.fetchProducts();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }
}
