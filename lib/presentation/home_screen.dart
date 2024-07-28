import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_nana_code_challenge/bloc/product_bloc.dart';
import 'package:flutter_nana_code_challenge/bloc/product_event.dart';
import 'package:flutter_nana_code_challenge/bloc/product_state.dart';
import 'package:flutter_nana_code_challenge/data/product.dart';
import 'package:flutter_nana_code_challenge/data/productRepository.dart';
import 'package:flutter_nana_code_challenge/domain/productRepositoryImpl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ProductBloc _productBloc;
  final List<Product> _products = [];
  bool _isLoading = false;
  int _currentPage = 1;
  final int _pageSize = 20;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final ProductRepository repository = ProductRepositoryImpl();
    _productBloc = ProductBloc(repository);
    _scrollController = ScrollController()..addListener(_onScroll);
    _productBloc.add(FetchProducts(limit: _pageSize, offset: 0));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent && !_isLoading) {
      _loadNextPage();
    }
  }

  Future<void> _loadProducts() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    _productBloc.add(FetchProducts(limit: _pageSize, offset: (_currentPage - 1) * _pageSize));
  }

  void _loadNextPage() {
    setState(() {
      _currentPage++;
    });
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider<ProductBloc>(
        create: (context) => _productBloc,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Product Listing'),
          ),
          body: BlocBuilder<ProductBloc, ProductState>(
            bloc: _productBloc,
            builder: (context, state) {
              if (state is ProductLoading && _products.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProductLoaded) {
                _products.addAll(state.products);
                _isLoading = false;
              } else if (state is ProductError) {
                _isLoading = false;
                return Center(
                  child: Text('Error: ${state.message}'),
                );
              }

              return Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: GridView.builder(
                            controller: _scrollController,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10.0.w,
                              mainAxisSpacing: 10.0.w,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: _products.length,
                            itemBuilder: (context, index) {
                              return ProductItem(product: _products[index]);
                            },
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Recommended Products',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        SizedBox(
                          height: 140.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              final Product randomProduct = Product(
                                id: index,
                                title: _products[index].title,
                                price: _products[index].price,
                                images: _products[index].images!.isEmpty
                                    ? []
                                    : [_products[index].images!.first],
                                description: _products[index].description,
                              );
                              return SizedBox(
                                width: 120.w,
                                child: ProductItem(product: randomProduct),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_isLoading)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        color: Colors.black54,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _productBloc.close();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }
}

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 50.h,
          width: 50.w,
          child: product.images!.isEmpty
              ? const Placeholder(
            fallbackWidth: 50,
            fallbackHeight: 50,
            color: Colors.grey,
          )
              : Image.network(
            product.images![0],
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          product.title ?? "",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
        Text(
          '\$${product.price?.toStringAsFixed(2) ?? ""}',
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12.sp),
        ),
      ],
    );
  }
}
