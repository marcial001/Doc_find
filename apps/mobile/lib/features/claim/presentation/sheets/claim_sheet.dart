import 'package:flutter/material.dart';
import '../../../../core/constants/document_types.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_sheet.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../shared/domain/entities/listing.dart';

abstract final class ClaimSheet {
  static Future<void> show({
    required BuildContext context,
    required Listing listing,
    required VoidCallback onClaimSuccess,
  }) {
    return AppSheet.show<void>(
      context: context,
      child: _ClaimSheetContent(
        listing: listing,
        onClaimSuccess: onClaimSuccess,
      ),
    );
  }
}

class _ClaimSheetContent extends StatefulWidget {
  const _ClaimSheetContent({
    required this.listing,
    required this.onClaimSuccess,
  });

  final Listing listing;
  final VoidCallback onClaimSuccess;

  @override
  State<_ClaimSheetContent> createState() => _ClaimSheetContentState();
}

class _ClaimSheetContentState extends State<_ClaimSheetContent> {
  final TextEditingController _answerController = TextEditingController();
  bool _hasPhoto = false;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  String _getLocalizedQuestion(BuildContext context, DocumentType type) {
    return switch (type) {
      DocumentType.id => context.l10n.claimQuestionId,
      DocumentType.pass => context.l10n.claimQuestionPassport,
      DocumentType.birth => context.l10n.claimQuestionBirth,
      DocumentType.lic || DocumentType.other => context.l10n.claimQuestionOther,
    };
  }

  void _submit() {
    final String answer = _answerController.text.trim();
    if (!Validators.isValidClaimAnswer(answer)) return;

    Navigator.of(context).pop();
    AppToast.show(context, context.l10n.claimCreatedToast);
    widget.onClaimSuccess();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bool isValid = Validators.isValidClaimAnswer(_answerController.text);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          context.l10n.claimSheetTitle,
          style: AppTypography.displayMedium.copyWith(
            color: theme.colorScheme.onSurface,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          context.l10n.claimSheetSubtitle,
          style: AppTypography.bodySmall.copyWith(
            color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // Question Box
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkGreenTint : AppColors.lightGreenTint,
            borderRadius: AppRadius.sm,
            border: Border.all(
              color: widget.listing.type.color.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Verification question (${widget.listing.type.label}):',
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  color: widget.listing.type.color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _getLocalizedQuestion(context, widget.listing.type),
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        // Answer TextField
        TextField(
          controller: _answerController,
          autofocus: true,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: context.l10n.claimAnswerPlaceholder,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        // Optional Add Photo Button
        OutlinedButton.icon(
          onPressed: () {
            setState(() => _hasPhoto = !_hasPhoto);
            AppToast.show(context, _hasPhoto ? 'Photo added' : 'Photo removed');
          },
          icon: Icon(
            _hasPhoto ? Icons.check_circle_rounded : Icons.add_a_photo_outlined,
            size: 18,
            color: _hasPhoto ? AppColors.lightPrimary : null,
          ),
          label: Text(
            _hasPhoto ? 'Photo attached' : context.l10n.claimAddPhoto,
            style: AppTypography.bodySmall.copyWith(
              color: _hasPhoto ? AppColors.lightPrimary : null,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        // Submit Button
        AppButton(
          label: context.l10n.claimSubmit,
          onPressed: isValid ? _submit : null,
        ),
      ],
    );
  }
}
