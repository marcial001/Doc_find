import '../../../../core/constants/document_types.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/data/datasources/mock_seed_data.dart';
import '../../../../shared/domain/entities/listing.dart';

class MockSearchDataSource {
  MockSearchDataSource() {
    _listings.addAll(MockSeedData.listings);
  }

  final List<Listing> _listings = <Listing>[];

  Future<Result<List<Listing>>> searchListings({
    String query = '',
    DocumentType? type,
    String town = 'All towns',
    int? maxDaysAgo,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final String cleanQ = query.trim().toLowerCase();

    final List<Listing> filtered = _listings.where((Listing item) {
      // Type filter
      if (type != null && item.type != type) {
        return false;
      }
      // Town filter
      if (town != 'All towns' &&
          item.town.toLowerCase() != town.toLowerCase()) {
        return false;
      }
      // Date filter
      if (maxDaysAgo != null && item.daysAgo > maxDaysAgo) {
        return false;
      }
      // Query filter (name, town, or spot)
      if (cleanQ.isNotEmpty) {
        final bool nameMatch = item.name.toLowerCase().contains(cleanQ);
        final bool townMatch = item.town.toLowerCase().contains(cleanQ);
        final bool spotMatch = item.spot.toLowerCase().contains(cleanQ);
        if (!nameMatch && !townMatch && !spotMatch) {
          return false;
        }
      }
      return true;
    }).toList();

    return Result.success(filtered);
  }

  Future<Result<Listing?>> getListingById(int id) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final Listing item = _listings.firstWhere(
      (Listing l) => l.id == id,
      orElse: () => const Listing(
        id: -1,
        type: DocumentType.other,
        name: '',
        town: '',
        spot: '',
        daysAgo: 0,
        note: '',
        question: '',
      ),
    );

    if (item.id == -1) {
      return Result.success(null);
    }
    return Result.success(item);
  }
}
