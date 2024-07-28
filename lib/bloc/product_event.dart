abstract class ProductEvent {}

class FetchProducts extends ProductEvent {
  final int limit;
  final int offset;

  FetchProducts({required this.limit, required this.offset});
}