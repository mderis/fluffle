import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiListResponse<T> {
  final List<T> data;
  final ApiMeta meta;

  const ApiListResponse({
    required this.data,
    required this.meta,
  });

  factory ApiListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiListResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiListResponseToJson(this, toJsonT);
}

@JsonSerializable(genericArgumentFactories: true)
class ApiSingleResponse<T> {
  final T data;

  const ApiSingleResponse({required this.data});

  factory ApiSingleResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiSingleResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiSingleResponseToJson(this, toJsonT);
}

@JsonSerializable()
class ApiMeta {
  /// Nullable: some lookup endpoints return `meta: {"include": []}` with no
  /// pagination block. Marking it required would throw at parse time and
  /// silently fail the entire list response.
  final ApiPagination? pagination;

  const ApiMeta({this.pagination});

  factory ApiMeta.fromJson(Map<String, dynamic> json) =>
      _$ApiMetaFromJson(json);

  Map<String, dynamic> toJson() => _$ApiMetaToJson(this);
}

@JsonSerializable()
class ApiPagination {
  final int total;
  final int count;
  @JsonKey(name: 'per_page')
  final int perPage;
  @JsonKey(name: 'current_page')
  final int currentPage;
  @JsonKey(name: 'total_pages')
  final int totalPages;

  const ApiPagination({
    required this.total,
    required this.count,
    required this.perPage,
    required this.currentPage,
    required this.totalPages,
  });

  factory ApiPagination.fromJson(Map<String, dynamic> json) =>
      _$ApiPaginationFromJson(json);

  Map<String, dynamic> toJson() => _$ApiPaginationToJson(this);
}
