import 'package:doc_find/core/constants/document_types.dart';
import 'package:doc_find/features/search/data/datasources/mock_search_datasource.dart';
import 'package:doc_find/features/search/data/repositories/search_repository_impl.dart';
import 'package:doc_find/features/search/presentation/controllers/search_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late MockSearchDataSource dataSource;
  late SearchRepositoryImpl repository;
  late SearchController controller;

  setUp(() {
    dataSource = MockSearchDataSource();
    repository = SearchRepositoryImpl(dataSource: dataSource);
    controller = SearchController(repository);
  });

  tearDown(() {
    controller.dispose();
  });

  group('SearchController', () {
    test('initializes with all 8 seed listings', () async {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect(controller.state.listings.length, 8);
      expect(controller.state.isEmpty, isFalse);
    });

    test('filters listings by DocumentType.id', () async {
      controller.selectType(DocumentType.id);
      await Future<void>.delayed(const Duration(milliseconds: 300));

      expect(controller.state.listings.length, 3);
      for (final l in controller.state.listings) {
        expect(l.type, DocumentType.id);
      }
    });

    test('filters listings by town', () async {
      controller.selectTown('Douala');
      await Future<void>.delayed(const Duration(milliseconds: 300));

      expect(controller.state.listings.length, 2);
      for (final l in controller.state.listings) {
        expect(l.town, 'Douala');
      }
    });

    test('filters listings by search query', () async {
      controller.updateQuery('Akwa');
      await Future<void>.delayed(const Duration(milliseconds: 300));

      expect(controller.state.listings.length, 1);
      expect(controller.state.listings.first.spot, contains('Akwa'));
    });

    test('returns empty state for nonexistent query', () async {
      controller.updateQuery('NonexistentQuery12345');
      await Future<void>.delayed(const Duration(milliseconds: 300));

      expect(controller.state.listings.isEmpty, isTrue);
      expect(controller.state.isEmpty, isTrue);
    });
  });
}
