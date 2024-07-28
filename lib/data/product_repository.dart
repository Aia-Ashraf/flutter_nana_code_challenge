
import 'product.dart';

abstract class ProductRepository {
  Future<List<Product>> fetchProducts(int limit, int offset);
}
