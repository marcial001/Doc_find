import '../../../../core/constants/document_types.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/domain/entities/search_alert.dart';

abstract class AlertsRepository {
  Future<Result<List<SearchAlert>>> getAlerts();
  Future<Result<SearchAlert>> toggleAlert(String id);
  Future<Result<SearchAlert>> saveAlert({
    required DocumentType? documentType,
    required String town,
  });
  Future<Result<void>> deleteAlert(String id);
}
