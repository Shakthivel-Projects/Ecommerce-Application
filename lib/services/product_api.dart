import '../models/product.dart';
import 'api_client.dart';

class ProductApi {
  Future<List<Product>> fetchProducts() async {
    final data = await apiClient.get('/products');
    final list = data as List;
    return list.map((e) => Product.fromJson(e)).toList();
  }

  Future<Product> fetchProduct(String id) async {
    final data = await apiClient.get('/products/$id');
    return Product.fromJson(data);
  }

  Future<Product> createProduct({
    required String title,
    required String description,
    required double price,
    required String image,
    required String category,
    String? brand,
    required int stock,
  }) async {
    final body = {
      'title': title,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
      'brand': brand,
      'stock': stock,
    };
    final data = await apiClient.post('/products', body);
    return Product.fromJson(data);
  }

  Future<Product> updateProduct({
    required String id,
    required String title,
    required String description,
    required double price,
    required String image,
    required String category,
    String? brand,
    required int stock,
  }) async {
    final body = {
      'title': title,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
      'brand': brand,
      'stock': stock,
    };
    final data = await apiClient.put('/products/$id', body);
    return Product.fromJson(data);
  }

  Future<void> deleteProduct(String id) async {
    await apiClient.delete('/products/$id');
  }
}
