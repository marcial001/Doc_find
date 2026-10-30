import '../../../core/constants/document_types.dart';

class Listing {
  const Listing({
    required this.id,
    required this.type,
    required this.name,
    required this.town,
    required this.spot,
    required this.daysAgo,
    required this.note,
    required this.question,
    this.status = 'Held safely by our team',
  });

  final int id;
  final DocumentType type;
  final String name;
  final String town;
  final String spot;
  final int daysAgo;
  final String note;
  final String question;
  final String status;

  Listing copyWith({
    int? id,
    DocumentType? type,
    String? name,
    String? town,
    String? spot,
    int? daysAgo,
    String? note,
    String? question,
    String? status,
  }) {
    return Listing(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      town: town ?? this.town,
      spot: spot ?? this.spot,
      daysAgo: daysAgo ?? this.daysAgo,
      note: note ?? this.note,
      question: question ?? this.question,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Listing &&
          other.id == id &&
          other.type == type &&
          other.name == name &&
          other.town == town &&
          other.spot == spot &&
          other.daysAgo == daysAgo &&
          other.note == note &&
          other.question == question &&
          other.status == status);

  @override
  int get hashCode =>
      Object.hash(id, type, name, town, spot, daysAgo, note, question, status);
}
