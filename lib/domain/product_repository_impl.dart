import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_nana_code_challenge/data/product.dart';

import 'package:flutter_nana_code_challenge/data/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final String _baseUrl = 'https://api.escuelajs.co/api/v1';
  final Dio _dio = Dio();

  ProductRepositoryImpl();

  @override
  Future<List<Product>> fetchProducts(int limit, int offset) async {
    try {
      final response = await _dio.get('$_baseUrl/products',
          queryParameters: {'limit': limit, 'offset': offset});
      if (response.statusCode == HttpStatus.ok) {
        List<dynamic> jsonList = response.data;
        return jsonList.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }
}
