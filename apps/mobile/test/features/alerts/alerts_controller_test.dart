import 'package:doc_find/core/constants/document_types.dart';
import 'package:doc_find/features/alerts/data/datasources/mock_alerts_datasource.dart';
import 'package:doc_find/features/alerts/data/repositories/alerts_repository_impl.dart';
import 'package:doc_find/features/alerts/presentation/controllers/alerts_controller.dart';
import 'package:doc_find/shared/domain/entities/search_alert.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late MockAlertsDataSource dataSource;
  late AlertsRepositoryImpl repository;
  late AlertsController controller;

  setUp(() {
    dataSource = MockAlertsDataSource();
    repository = AlertsRepositoryImpl(dataSource);
    controller = AlertsController(repository);
  });

  test('AlertsController initializes with seed alerts', () async {
    await controller.loadAlerts();
    expect(controller.state.alerts.length, 2);
    expect(controller.state.alerts.first.label, 'ID card · Douala');
  });

  test('AlertsController toggles alert status', () async {
    await controller.loadAlerts();
    final String id = controller.state.alerts.first.id;
    final bool initial = controller.state.alerts.first.isEnabled;

    await controller.toggleAlert(id);
    expect(
      controller.state.alerts.firstWhere((a) => a.id == id).isEnabled,
      !initial,
    );
  });

  test('AlertsController saves new alert and deletes alert', () async {
    final SearchAlert? alert = await controller.saveAlert(
      documentType: DocumentType.birth,
      town: 'Bafoussam',
    );

    expect(alert, isNotNull);
    expect(alert!.label, 'Birth certificate · Bafoussam');
    expect(controller.state.alerts.any((a) => a.id == alert.id), isTrue);

    await controller.deleteAlert(alert.id);
    expect(controller.state.alerts.any((a) => a.id == alert.id), isFalse);
  });
}
