import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nana_code_challenge/data/product.dart';
import 'package:flutter_nana_code_challenge/data/productRepository.dart';
import 'product_event.dart';
import 'product_state.dart';


class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc(this.repository) : super(ProductInitial()) {
  on<FetchProducts>(_fetchProductsEvent);}


  Future<void> _fetchProductsEvent(
  FetchProducts event,
  Emitter<ProductState> emit,
  ) async {
  emit(ProductLoading());
  try {
  List<Product> products = await repository.fetchProducts(event.limit, event.offset);
  emit( ProductLoaded(products: products));
  } catch (e) {
    emit( ProductError(message: e.toString()));
  }
  }

}
