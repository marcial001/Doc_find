import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum DocumentType {
  id('id', 'ID card', 'ID', AppColors.docId),
  pass('pass', 'Passport', 'PP', AppColors.docPassport),
  birth('birth', 'Birth certificate', 'BC', AppColors.docBirth),
  lic('lic', 'Driver\'s licence', 'DL', AppColors.docLicence),
  other('other', 'Other', '•', AppColors.docOther);

  const DocumentType(this.code, this.label, this.badge, this.color);

  final String code;
  final String label;
  final String badge;
  final Color color;

  static DocumentType fromCode(String code) {
    return DocumentType.values.firstWhere(
      (DocumentType t) => t.code == code,
      orElse: () => DocumentType.other,
    );
  }

  String getProofQuestion() {
    return switch (this) {
      DocumentType.id => 'Which town issued your card?',
      DocumentType.pass => 'What is your date of birth?',
      DocumentType.birth => 'What is your mother\'s first name?',
      DocumentType.lic ||
      DocumentType.other => 'Which date is printed as the issue date?',
    };
  }
}
