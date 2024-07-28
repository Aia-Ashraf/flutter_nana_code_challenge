import 'package:flutter_nana_code_challenge/data/product.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;

  ProductLoaded({required this.products});
}

class ProductError extends ProductState {
  final String message;

  ProductError({required this.message});
}
