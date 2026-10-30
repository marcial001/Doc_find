import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/document_types.dart';
import '../../../../core/utils/result.dart';
import '../../data/datasources/mock_report_datasource.dart';
import '../../data/repositories/report_repository_impl.dart';
import '../../domain/repositories/report_repository.dart';

final Provider<MockReportDataSource> mockReportDataSourceProvider =
    Provider<MockReportDataSource>((Ref ref) => MockReportDataSource());

final Provider<ReportRepositoryImpl> reportRepositoryProvider =
    Provider<ReportRepositoryImpl>((Ref ref) {
      final MockReportDataSource ds = ref.watch(mockReportDataSourceProvider);
      return ReportRepositoryImpl(ds);
    });

class ReportState {
  const ReportState({
    this.myReports = const <ReportedDocument>[],
    this.currentStep = 0,
    this.draft = const ReportDraft(),
    this.isLoading = false,
    this.isSubmitting = false,
    this.errorMessage,
  });

  final List<ReportedDocument> myReports;
  final int currentStep;
  final ReportDraft draft;
  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;

  ReportState copyWith({
    List<ReportedDocument>? myReports,
    int? currentStep,
    ReportDraft? draft,
    bool? isLoading,
    bool? isSubmitting,
    String? Function()? errorMessage,
  }) {
    return ReportState(
      myReports: myReports ?? this.myReports,
      currentStep: currentStep ?? this.currentStep,
      draft: draft ?? this.draft,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}

class ReportController extends StateNotifier<ReportState> {
  ReportController(this._repository) : super(const ReportState()) {
    loadMyReports();
  }

  final ReportRepositoryImpl _repository;

  Future<void> loadMyReports() async {
    state = state.copyWith(isLoading: true, errorMessage: () => null);
    final Result<List<ReportedDocument>> result = await _repository
        .getMyReports();
    result.when(
      success: (List<ReportedDocument> reports) {
        state = state.copyWith(myReports: reports, isLoading: false);
      },
      failure: (f) {
        state = state.copyWith(isLoading: false, errorMessage: () => f.message);
      },
    );
  }

  void startNewReport() {
    state = state.copyWith(
      currentStep: 0,
      draft: const ReportDraft(),
      errorMessage: () => null,
    );
  }

  void setStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void capturePhoto() {
    state = state.copyWith(draft: state.draft.copyWith(photoCaptured: true));
  }

  void setType(DocumentType type) {
    state = state.copyWith(draft: state.draft.copyWith(type: type));
  }

  void setTown(String town) {
    state = state.copyWith(draft: state.draft.copyWith(town: town));
  }

  void setSpot(String spot) {
    state = state.copyWith(draft: state.draft.copyWith(spot: spot));
  }

  void setNote(String note) {
    state = state.copyWith(draft: state.draft.copyWith(note: note));
  }

  void toggleConsentStorage() {
    state = state.copyWith(
      draft: state.draft.copyWith(consentStorage: !state.draft.consentStorage),
    );
  }

  void toggleConsentContact() {
    state = state.copyWith(
      draft: state.draft.copyWith(consentContact: !state.draft.consentContact),
    );
  }

  Future<bool> submitReport() async {
    if (!state.draft.canSubmit) {
      state = state.copyWith(
        errorMessage: () => 'Tick both consent boxes to continue.',
      );
      return false;
    }

    state = state.copyWith(isSubmitting: true, errorMessage: () => null);
    final Result<ReportedDocument> result = await _repository.submitReport(
      state.draft,
    );

    return result.when(
      success: (ReportedDocument reported) {
        state = state.copyWith(
          myReports: <ReportedDocument>[reported, ...state.myReports],
          currentStep: 3,
          isSubmitting: false,
        );
        return true;
      },
      failure: (f) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: () => f.message,
        );
        return false;
      },
    );
  }

  void resetFlow() {
    state = state.copyWith(currentStep: 0, draft: const ReportDraft());
  }
}

final StateNotifierProvider<ReportController, ReportState>
reportControllerProvider = StateNotifierProvider<ReportController, ReportState>(
  (Ref ref) {
    final ReportRepositoryImpl repo = ref.watch(reportRepositoryProvider);
    return ReportController(repo);
  },
);
