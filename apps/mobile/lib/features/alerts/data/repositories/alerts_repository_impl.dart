import '../../../../core/constants/document_types.dart';
import '../../../../core/utils/failure.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/domain/entities/search_alert.dart';
import '../../domain/repositories/alerts_repository.dart';
import '../datasources/mock_alerts_datasource.dart';

class AlertsRepositoryImpl implements AlertsRepository {
  AlertsRepositoryImpl(this._dataSource);

  final MockAlertsDataSource _dataSource;

  @override
  Future<Result<List<SearchAlert>>> getAlerts() async {
    try {
      final List<SearchAlert> alerts = await _dataSource.getAlerts();
      return Result.success(alerts);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<SearchAlert>> toggleAlert(String id) async {
    try {
      final SearchAlert alert = await _dataSource.toggleAlert(id);
      return Result.success(alert);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<SearchAlert>> saveAlert({
    required DocumentType? documentType,
    required String town,
  }) async {
    try {
      final SearchAlert alert = await _dataSource.saveAlert(
        documentType: documentType,
        town: town,
      );
      return Result.success(alert);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteAlert(String id) async {
    try {
      await _dataSource.deleteAlert(id);
      return Result.success(null);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }
}
