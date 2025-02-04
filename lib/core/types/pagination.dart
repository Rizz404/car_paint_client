class Pagination {
  final int currentPage;
  final int itemsPerPage;
  final int totalItems;
  final int totalPages;
  final int? previousPage;
  final int? nextPage;
  final bool hasPreviousPage;
  final bool hasNextPage;

  Pagination({
    this.currentPage = 1,
    this.itemsPerPage = 10,
    required this.totalItems,
    required this.totalPages,
    required this.previousPage,
    required this.nextPage,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });
}
