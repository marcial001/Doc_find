import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/document_types.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/domain/entities/listing.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../../domain/repositories/search_repository.dart';

final searchRepositoryProvider = Provider<SearchRepository>((Ref ref) {
  return SearchRepositoryImpl();
});

class SearchFilterState {
  const SearchFilterState({
    this.query = '',
    this.selectedType,
    this.selectedTown = 'All towns',
    this.selectedDateRange = 'Any date',
  });

  final String query;
  final DocumentType? selectedType;
  final String selectedTown;
  final String selectedDateRange;

  int? get maxDaysAgo {
    return switch (selectedDateRange) {
      'Last 7 days' => 7,
      'Last 30 days' => 30,
      _ => null,
    };
  }

  SearchFilterState copyWith({
    String? query,
    DocumentType? selectedType,
    bool clearType = false,
    String? selectedTown,
    String? selectedDateRange,
  }) {
    return SearchFilterState(
      query: query ?? this.query,
      selectedType: clearType ? null : (selectedType ?? this.selectedType),
      selectedTown: selectedTown ?? this.selectedTown,
      selectedDateRange: selectedDateRange ?? this.selectedDateRange,
    );
  }
}

class SearchFeedState {
  const SearchFeedState({
    this.listings = const <Listing>[],
    this.isLoading = false,
    this.errorMessage,
    this.filters = const SearchFilterState(),
  });

  final List<Listing> listings;
  final bool isLoading;
  final String? errorMessage;
  final SearchFilterState filters;

  bool get isEmpty => !isLoading && listings.isEmpty;

  SearchFeedState copyWith({
    List<Listing>? listings,
    bool? isLoading,
    String? errorMessage,
    SearchFilterState? filters,
  }) {
    return SearchFeedState(
      listings: listings ?? this.listings,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      filters: filters ?? this.filters,
    );
  }
}

class SearchController extends StateNotifier<SearchFeedState> {
  SearchController(this._repository) : super(const SearchFeedState()) {
    performSearch();
  }

  final SearchRepository _repository;

  Future<void> performSearch() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final Result<List<Listing>> result = await _repository.searchListings(
      query: state.filters.query,
      type: state.filters.selectedType,
      town: state.filters.selectedTown,
      maxDaysAgo: state.filters.maxDaysAgo,
    );

    result.when(
      success: (List<Listing> items) {
        state = state.copyWith(listings: items, isLoading: false);
      },
      failure: (Failure failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
    );
  }

  void updateQuery(String newQuery) {
    if (state.filters.query != newQuery) {
      state = state.copyWith(filters: state.filters.copyWith(query: newQuery));
      performSearch();
    }
  }

  void selectType(DocumentType? type) {
    state = state.copyWith(
      filters: state.filters.copyWith(
        selectedType: type,
        clearType: type == null,
      ),
    );
    performSearch();
  }

  void selectTown(String town) {
    state = state.copyWith(filters: state.filters.copyWith(selectedTown: town));
    performSearch();
  }

  void selectDateRange(String dateRange) {
    state = state.copyWith(
      filters: state.filters.copyWith(selectedDateRange: dateRange),
    );
    performSearch();
  }
}

final searchControllerProvider =
    StateNotifierProvider<SearchController, SearchFeedState>((Ref ref) {
      final SearchRepository repository = ref.watch(searchRepositoryProvider);
      return SearchController(repository);
    });
