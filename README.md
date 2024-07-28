# flutter_nana_code_challenge

A new Flutter project.

Documentation for HomeScreen Implementation
Overview
The HomeScreen widget displays a list of products with pagination using the flutter_bloc for state management, dio for networking, and flutter_screenutil for responsive design.

Import Statements
flutter/material.dart: Core Flutter components.
flutter_bloc/flutter_bloc.dart: BLoC pattern components.
dio/dio.dart: HTTP requests.
flutter_screenutil/flutter_screenutil.dart: Responsive design.
Various product-related BLoC and repository classes.
HomeScreen Class
StatefulWidget: Maintains state across rebuilds.
State Variables
ProductBloc _productBloc: Manages product state and events.
List<Product> _products: Stores fetched products.
bool _isLoading: Tracks loading state.
int _currentPage: Current page for pagination.
int _pageSize: Number of items per page.
ScrollController _scrollController: Controls scroll behavior.
initState Method
Initializes the state, ProductBloc, and ScrollController.
Fetches initial products by dispatching a FetchProducts event.
_onScroll Method
Detects when the user reaches the bottom of the list.
Calls _loadNextPage to fetch more products if not loading.
_loadProducts Method
Dispatches FetchProducts event with the current page and size.
Sets _isLoading to true to prevent duplicate loads.
_loadNextPage Method
Increments _currentPage and calls _loadProducts.
build Method
Sets up the BlocProvider and BlocBuilder.
Displays a loading indicator, product grid, and error message as appropriate.
Listens for ProductLoaded and ProductError states to update the UI.
dispose Method
Closes the ProductBloc and disposes of the ScrollController.
ProductItem Class
Stateless widget to display individual product details.





