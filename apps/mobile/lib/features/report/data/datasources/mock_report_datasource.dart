import '../../domain/repositories/report_repository.dart';

class MockReportDataSource {
  final List<ReportedDocument> _myReports = <ReportedDocument>[];

  Future<List<ReportedDocument>> getMyReports() async {
    await Future<void>.delayed(const Duration(milliseconds: 60));
    return List<ReportedDocument>.unmodifiable(_myReports);
  }

  Future<ReportedDocument> submitReport(ReportDraft draft) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));

    final ReportedDocument reported = ReportedDocument(
      id: _myReports.length + 1,
      type: draft.type,
      town: draft.town,
      spot: draft.spot,
      note: draft.note,
      submittedAt: DateTime.now(),
      status: 'In review',
    );

    _myReports.insert(0, reported);
    return reported;
  }
}
