// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Pagination {
  final int currentPage;
  final int itemsPerPage;
  final int totalItems;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;

  Pagination({
    this.currentPage = 1,
    this.itemsPerPage = 10,
    required this.totalItems,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  Pagination copyWith({
    int? currentPage,
    int? itemsPerPage,
    int? totalItems,
    int? totalPages,
    bool? hasPreviousPage,
    bool? hasNextPage,
  }) {
    return Pagination(
      currentPage: currentPage ?? this.currentPage,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      totalItems: totalItems ?? this.totalItems,
      totalPages: totalPages ?? this.totalPages,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'currentPage': currentPage,
      'itemsPerPage': itemsPerPage,
      'totalItems': totalItems,
      'totalPages': totalPages,
      'hasPreviousPage': hasPreviousPage,
      'hasNextPage': hasNextPage,
    };
  }

  factory Pagination.fromMap(Map<String, dynamic> map) {
    return Pagination(
      currentPage: map['currentPage'] as int,
      itemsPerPage: map['itemsPerPage'] as int,
      totalItems: map['totalItems'] as int,
      totalPages: map['totalPages'] as int,
      hasPreviousPage: map['hasPreviousPage'] as bool,
      hasNextPage: map['hasNextPage'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Pagination.fromJson(String source) =>
      Pagination.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Pagination(currentPage: $currentPage, itemsPerPage: $itemsPerPage, totalItems: $totalItems, totalPages: $totalPages, hasPreviousPage: $hasPreviousPage, hasNextPage: $hasNextPage)';
  }

  @override
  bool operator ==(covariant Pagination other) {
    if (identical(this, other)) return true;

    return other.currentPage == currentPage &&
        other.itemsPerPage == itemsPerPage &&
        other.totalItems == totalItems &&
        other.totalPages == totalPages &&
        other.hasPreviousPage == hasPreviousPage &&
        other.hasNextPage == hasNextPage;
  }

  @override
  int get hashCode {
    return currentPage.hashCode ^
        itemsPerPage.hashCode ^
        totalItems.hashCode ^
        totalPages.hashCode ^
        hasPreviousPage.hashCode ^
        hasNextPage.hashCode;
  }
}
