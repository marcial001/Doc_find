import '../../../../core/constants/document_types.dart';
import '../../../../shared/data/datasources/mock_seed_data.dart';
import '../../../../shared/domain/entities/search_alert.dart';

class MockAlertsDataSource {
  MockAlertsDataSource() {
    _alerts = List<SearchAlert>.from(MockSeedData.alerts);
  }

  late final List<SearchAlert> _alerts;

  Future<List<SearchAlert>> getAlerts() async {
    await Future<void>.delayed(const Duration(milliseconds: 60));
    return List<SearchAlert>.unmodifiable(_alerts);
  }

  Future<SearchAlert> toggleAlert(String id) async {
    final int index = _alerts.indexWhere((SearchAlert a) => a.id == id);
    if (index == -1) {
      throw Exception('Alert not found');
    }
    final SearchAlert updated = _alerts[index].copyWith(
      isEnabled: !_alerts[index].isEnabled,
    );
    _alerts[index] = updated;
    return updated;
  }

  Future<SearchAlert> saveAlert({
    required DocumentType? documentType,
    required String town,
  }) async {
    final String labelToMatch =
        '${documentType?.label ?? 'Any document'} · $town';
    final int existingIndex = _alerts.indexWhere(
      (SearchAlert a) => a.label == labelToMatch,
    );
    if (existingIndex != -1) {
      _alerts[existingIndex] = _alerts[existingIndex].copyWith(isEnabled: true);
      return _alerts[existingIndex];
    }

    final SearchAlert newAlert = SearchAlert(
      id: 'alert_${DateTime.now().millisecondsSinceEpoch}',
      documentType: documentType,
      town: town,
      isEnabled: true,
    );
    _alerts.insert(0, newAlert);
    return newAlert;
  }

  Future<void> deleteAlert(String id) async {
    _alerts.removeWhere((SearchAlert a) => a.id == id);
  }
}
