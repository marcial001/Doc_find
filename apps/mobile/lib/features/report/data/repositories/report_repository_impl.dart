import '../../../../core/utils/failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/mock_report_datasource.dart';

class ReportRepositoryImpl implements ReportRepository {
  ReportRepositoryImpl(this._dataSource);

  final MockReportDataSource _dataSource;

  @override
  Future<Result<List<ReportedDocument>>> getMyReports() async {
    try {
      final List<ReportedDocument> reports = await _dataSource.getMyReports();
      return Result.success(reports);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<ReportedDocument>> submitReport(ReportDraft draft) async {
    try {
      if (!draft.canSubmit) {
        return Result.failure(
          const ValidationFailure(
            'Both consents are required by Law No. 2024/017',
          ),
        );
      }
      final ReportedDocument reported = await _dataSource.submitReport(draft);
      return Result.success(reported);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }
}
