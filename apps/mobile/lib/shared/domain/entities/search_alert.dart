import '../../../core/constants/document_types.dart';

class SearchAlert {
  const SearchAlert({
    required this.id,
    required this.documentType,
    required this.town,
    this.isEnabled = true,
  });

  final String id;
  final DocumentType? documentType;
  final String town;
  final bool isEnabled;

  String get label {
    final String typeStr = documentType?.label ?? 'Any document';
    return '$typeStr · $town';
  }

  SearchAlert copyWith({
    String? id,
    DocumentType? documentType,
    String? town,
    bool? isEnabled,
  }) {
    return SearchAlert(
      id: id ?? this.id,
      documentType: documentType ?? this.documentType,
      town: town ?? this.town,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
