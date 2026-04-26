import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'package:app_template/core/domain/entities/paginated.dart';
import 'package:app_template/core/domain/failures/failure.dart';

class PaginatedState<T> {
  final List<T> items;
  final int currentPage;
  final int totalPages;
  final bool isLoadingMore;
  final String? search;
  final Failure? failure;

  const PaginatedState({
    this.items = const [],
    this.currentPage = 0,
    this.totalPages = 1,
    this.isLoadingMore = false,
    this.search,
    this.failure,
  });

  bool get hasMore => currentPage < totalPages;

  PaginatedState<T> copyWith({
    List<T>? items,
    int? currentPage,
    int? totalPages,
    bool? isLoadingMore,
    String? Function()? search,
    Failure? Function()? failure,
  }) {
    return PaginatedState<T>(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      search: search != null ? search() : this.search,
      failure: failure != null ? failure() : this.failure,
    );
  }
}

/// Base class for paginated list notifiers.
///
/// Subclasses only need to provide [fetchPage].
/// Everything else — build, loadMore, search, refresh — is handled here.
abstract class PaginatedAsyncNotifier<T>
    extends AsyncNotifier<PaginatedState<T>> {
  /// Fetch a single page from the data source.
  Future<Either<Failure, Paginated<T>>> fetchPage(int page, String? search);

  @override
  Future<PaginatedState<T>> build() async {
    return _fetchAndProcess(1);
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    final newState = await _fetchAndProcess(
      current.currentPage + 1,
      search: current.search,
    );

    state = AsyncData(newState);
  }

  Future<void> search(String query) async {
    final trimmed = query.trim();
    final search = trimmed.isEmpty ? null : trimmed;

    state = const AsyncLoading();
    final newState = await _fetchAndProcess(1, search: search);
    state = AsyncData(newState);
  }

  Future<void> refresh() async {
    final current = state.value;
    final newState = await _fetchAndProcess(1, search: current?.search);
    state = AsyncData(newState);
  }

  Future<PaginatedState<T>> _fetchAndProcess(
    int page, {
    String? search,
  }) async {
    final result = await fetchPage(page, search);

    return result.fold(
      (failure) {
        final current = state.value ?? const PaginatedState();
        if (page == 1) {
          return PaginatedState<T>(failure: failure);
        }
        return current.copyWith(
          isLoadingMore: false,
          failure: () => failure,
        );
      },
      (paginated) {
        final current = state.value ?? const PaginatedState();
        final allItems = page == 1
            ? paginated.items
            : [...current.items, ...paginated.items];
        return PaginatedState<T>(
          items: allItems,
          currentPage: paginated.currentPage,
          totalPages: paginated.totalPages,
          search: search,
        );
      },
    );
  }
}
