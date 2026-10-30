import '../../../../core/constants/document_types.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/domain/entities/listing.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/mock_search_datasource.dart';

class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl({MockSearchDataSource? dataSource})
    : _dataSource = dataSource ?? MockSearchDataSource();

  final MockSearchDataSource _dataSource;

  @override
  Future<Result<List<Listing>>> searchListings({
    String query = '',
    DocumentType? type,
    String town = 'All towns',
    int? maxDaysAgo,
  }) {
    return _dataSource.searchListings(
      query: query,
      type: type,
      town: town,
      maxDaysAgo: maxDaysAgo,
    );
  }

  @override
  Future<Result<Listing?>> getListingById(int id) {
    return _dataSource.getListingById(id);
  }
}
