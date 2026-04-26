import 'package:app_template/core/api/base_response.dart';

class Paginated<T> {
  final List<T> items;
  final int total;
  final int currentPage;
  final int totalPages;

  const Paginated({
    required this.items,
    required this.total,
    required this.currentPage,
    required this.totalPages,
  });

  bool get hasMore => currentPage < totalPages;

  bool get isEmpty => items.isEmpty;

  int get count => items.length;
}

extension ApiPaginationMapper on ApiPagination {
  Paginated<T> toPaginated<T>(List<T> items) => Paginated(
    items: items,
    total: total,
    currentPage: currentPage,
    totalPages: totalPages,
  );
}
