HomeScreen Implementation
Overview
The HomeScreen widget displays a paginated list of products. It uses flutter_bloc for state management, dio for networking, and flutter_screenutil for responsive design.

Dependencies
Add the following to your pubspec.yaml:

yaml
Copy code
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^7.0.0
  dio: ^4.0.0
  flutter_screenutil: ^5.0.0
Key Components
State Variables:

_productBloc: Manages product state and events.
_products: List of fetched products.
_isLoading: Indicates loading state.
_currentPage: Current page number for pagination.
_pageSize: Number of items per page.
_scrollController: Controls scroll behavior.
initState:

Initializes the state, ProductBloc, and ScrollController.
Fetches initial products.
_onScroll:

Detects when the user reaches the bottom of the list.
Triggers loading of the next page if not already loading.
_loadProducts:

Dispatches FetchProducts event to fetch products for the current page.
_loadNextPage:

Increments _currentPage and loads products for the next page.
build Method:

Sets up the BlocProvider and BlocBuilder.
Displays a loading indicator, product grid, or error message based on the state.
dispose:

Closes the ProductBloc and disposes the ScrollController.
ProductItem Class:

Displays individual product details.
