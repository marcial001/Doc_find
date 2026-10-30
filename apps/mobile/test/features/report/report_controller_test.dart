import 'package:doc_find/core/constants/document_types.dart';
import 'package:doc_find/features/report/data/datasources/mock_report_datasource.dart';
import 'package:doc_find/features/report/data/repositories/report_repository_impl.dart';
import 'package:doc_find/features/report/presentation/controllers/report_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late MockReportDataSource dataSource;
  late ReportRepositoryImpl repository;
  late ReportController controller;

  setUp(() {
    dataSource = MockReportDataSource();
    repository = ReportRepositoryImpl(dataSource);
    controller = ReportController(repository);
  });

  test('ReportController manages flow steps and form state', () {
    expect(controller.state.currentStep, 0);
    expect(controller.state.draft.photoCaptured, isFalse);
    expect(controller.state.draft.canProceedToStep1, isFalse);

    controller.capturePhoto();
    expect(controller.state.draft.photoCaptured, isTrue);
    expect(controller.state.draft.canProceedToStep1, isTrue);

    controller.setStep(1);
    expect(controller.state.currentStep, 1);

    controller.setSpot('Akwa');
    expect(controller.state.draft.spot, 'Akwa');
    expect(controller.state.draft.canProceedToStep2, isTrue);

    controller.setStep(2);
    expect(controller.state.currentStep, 2);
    expect(controller.state.draft.canSubmit, isFalse);

    controller.toggleConsentStorage();
    expect(controller.state.draft.consentStorage, isTrue);
    expect(controller.state.draft.canSubmit, isFalse);

    controller.toggleConsentContact();
    expect(controller.state.draft.consentContact, isTrue);
    expect(controller.state.draft.canSubmit, isTrue);
  });

  test(
    'ReportController submits report and advances to success step 3',
    () async {
      controller.capturePhoto();
      controller.setType(DocumentType.pass);
      controller.setTown('Yaoundé');
      controller.setSpot('Mvan bus park');
      controller.toggleConsentStorage();
      controller.toggleConsentContact();

      final bool success = await controller.submitReport();
      expect(success, isTrue);
      expect(controller.state.currentStep, 3);
      expect(controller.state.myReports.length, 1);
      expect(controller.state.myReports.first.town, 'Yaoundé');
      expect(controller.state.myReports.first.type, DocumentType.pass);
    },
  );
}
