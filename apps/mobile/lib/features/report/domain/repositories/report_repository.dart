import '../../../../core/constants/document_types.dart';
import '../../../../core/utils/result.dart';

class ReportDraft {
  const ReportDraft({
    this.photoCaptured = false,
    this.type = DocumentType.id,
    this.town = 'Douala',
    this.spot = '',
    this.note = '',
    this.consentStorage = false,
    this.consentContact = false,
  });

  final bool photoCaptured;
  final DocumentType type;
  final String town;
  final String spot;
  final String note;
  final bool consentStorage;
  final bool consentContact;

  bool get canProceedToStep1 => photoCaptured;
  bool get canProceedToStep2 => spot.trim().length >= 3;
  bool get canSubmit => consentStorage && consentContact;

  ReportDraft copyWith({
    bool? photoCaptured,
    DocumentType? type,
    String? town,
    String? spot,
    String? note,
    bool? consentStorage,
    bool? consentContact,
  }) {
    return ReportDraft(
      photoCaptured: photoCaptured ?? this.photoCaptured,
      type: type ?? this.type,
      town: town ?? this.town,
      spot: spot ?? this.spot,
      note: note ?? this.note,
      consentStorage: consentStorage ?? this.consentStorage,
      consentContact: consentContact ?? this.consentContact,
    );
  }
}

class ReportedDocument {
  const ReportedDocument({
    required this.id,
    required this.type,
    required this.town,
    required this.spot,
    required this.note,
    required this.submittedAt,
    this.status = 'In review',
  });

  final int id;
  final DocumentType type;
  final String town;
  final String spot;
  final String note;
  final DateTime submittedAt;
  final String status;
}

abstract class ReportRepository {
  Future<Result<List<ReportedDocument>>> getMyReports();
  Future<Result<ReportedDocument>> submitReport(ReportDraft draft);
}
