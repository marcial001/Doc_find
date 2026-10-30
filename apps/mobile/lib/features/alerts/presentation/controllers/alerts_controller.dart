import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/document_types.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/domain/entities/search_alert.dart';
import '../../data/datasources/mock_alerts_datasource.dart';
import '../../data/repositories/alerts_repository_impl.dart';

final Provider<MockAlertsDataSource> mockAlertsDataSourceProvider =
    Provider<MockAlertsDataSource>((Ref ref) => MockAlertsDataSource());

final Provider<AlertsRepositoryImpl> alertsRepositoryProvider =
    Provider<AlertsRepositoryImpl>((Ref ref) {
      final MockAlertsDataSource ds = ref.watch(mockAlertsDataSourceProvider);
      return AlertsRepositoryImpl(ds);
    });

class AlertsState {
  const AlertsState({
    this.alerts = const <SearchAlert>[],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<SearchAlert> alerts;
  final bool isLoading;
  final String? errorMessage;

  AlertsState copyWith({
    List<SearchAlert>? alerts,
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return AlertsState(
      alerts: alerts ?? this.alerts,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}

class AlertsController extends StateNotifier<AlertsState> {
  AlertsController(this._repository) : super(const AlertsState()) {
    loadAlerts();
  }

  final AlertsRepositoryImpl _repository;

  Future<void> loadAlerts() async {
    state = state.copyWith(isLoading: true, errorMessage: () => null);
    final Result<List<SearchAlert>> result = await _repository.getAlerts();
    result.when(
      success: (List<SearchAlert> alerts) {
        state = state.copyWith(alerts: alerts, isLoading: false);
      },
      failure: (f) {
        state = state.copyWith(isLoading: false, errorMessage: () => f.message);
      },
    );
  }

  Future<void> toggleAlert(String id) async {
    final Result<SearchAlert> result = await _repository.toggleAlert(id);
    if (result.isSuccess) {
      final SearchAlert updated = (result as Success<SearchAlert>).data;
      final List<SearchAlert> list = state.alerts.map((SearchAlert a) {
        return a.id == id ? updated : a;
      }).toList();
      state = state.copyWith(alerts: list);
    }
  }

  Future<SearchAlert?> saveAlert({
    required DocumentType? documentType,
    required String town,
  }) async {
    final Result<SearchAlert> result = await _repository.saveAlert(
      documentType: documentType,
      town: town,
    );
    if (result.isSuccess) {
      final SearchAlert alert = (result as Success<SearchAlert>).data;
      final bool alreadyExists = state.alerts.any(
        (SearchAlert a) => a.id == alert.id,
      );
      final List<SearchAlert> list = alreadyExists
          ? state.alerts
                .map((SearchAlert a) => a.id == alert.id ? alert : a)
                .toList()
          : <SearchAlert>[alert, ...state.alerts];
      state = state.copyWith(alerts: list);
      return alert;
    }
    return null;
  }

  Future<void> deleteAlert(String id) async {
    final Result<void> result = await _repository.deleteAlert(id);
    if (result.isSuccess) {
      state = state.copyWith(
        alerts: state.alerts.where((SearchAlert a) => a.id != id).toList(),
      );
    }
  }
}

final StateNotifierProvider<AlertsController, AlertsState>
alertsControllerProvider = StateNotifierProvider<AlertsController, AlertsState>(
  (Ref ref) {
    final AlertsRepositoryImpl repo = ref.watch(alertsRepositoryProvider);
    return AlertsController(repo);
  },
);
