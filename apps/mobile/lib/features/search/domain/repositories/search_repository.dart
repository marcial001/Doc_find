import '../../../../core/constants/document_types.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/domain/entities/listing.dart';

abstract class SearchRepository {
  Future<Result<List<Listing>>> searchListings({
    String query = '',
    DocumentType? type,
    String town = 'All towns',
    int? maxDaysAgo,
  });

  Future<Result<Listing?>> getListingById(int id);
}
