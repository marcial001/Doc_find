import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/document_types.dart';
import '../../../../core/constants/towns.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/redacted_doc.dart';
import '../controllers/report_controller.dart';

class ReportFlowScreen extends ConsumerStatefulWidget {
  const ReportFlowScreen({super.key});

  @override
  ConsumerState<ReportFlowScreen> createState() => _ReportFlowScreenState();
}

class _ReportFlowScreenState extends ConsumerState<ReportFlowScreen> {
  late final TextEditingController _spotController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(reportControllerProvider).draft;
    _spotController = TextEditingController(text: draft.spot);
    _noteController = TextEditingController(text: draft.note);
  }

  @override
  void dispose() {
    _spotController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onBack() {
    final int currentStep = ref.read(reportControllerProvider).currentStep;
    if (currentStep > 0 && currentStep < 3) {
      ref.read(reportControllerProvider.notifier).setStep(currentStep - 1);
    } else {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }
  }

  String _getTitle(int step) {
    switch (step) {
      case 0:
        return 'Photograph it';
      case 1:
        return 'Where and what';
      case 2:
        return 'Your consent';
      case 3:
      default:
        return 'Report sent';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final ReportState state = ref.watch(reportControllerProvider);
    final Color primary = isDark
        ? AppColors.darkPrimary
        : AppColors.lightPrimary;

    return PopScope(
      canPop: state.currentStep == 0 || state.currentStep == 3,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (!didPop) {
          _onBack();
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: isDark
              ? AppColors.darkSurface
              : AppColors.lightSurface,
          elevation: 0.5,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
            onPressed: _onBack,
          ),
          title: Text(
            _getTitle(state.currentStep),
            style: AppTypography.heading1.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          bottom: state.currentStep == 3
              ? null
              : PreferredSize(
                  preferredSize: const Size.fromHeight(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.xs,
                    ),
                    child: Row(
                      children: List<Widget>.generate(3, (int i) {
                        final bool active = i <= state.currentStep;
                        return Expanded(
                          child: Container(
                            height: 4,
                            margin: EdgeInsets.only(
                              right: i < 2 ? AppSpacing.xs : 0,
                            ),
                            decoration: BoxDecoration(
                              color: active
                                  ? primary
                                  : (isDark
                                        ? AppColors.darkLine
                                        : AppColors.lightLine),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: switch (state.currentStep) {
                  0 => _Step0Photograph(
                    isPhotoCaptured: state.draft.photoCaptured,
                    selectedType: state.draft.type,
                    onSnap: () => ref
                        .read(reportControllerProvider.notifier)
                        .capturePhoto(),
                  ),
                  1 => _Step1WhereAndWhat(
                    selectedType: state.draft.type,
                    selectedTown: state.draft.town,
                    spotController: _spotController,
                    noteController: _noteController,
                    onTypeChanged: (DocumentType t) =>
                        ref.read(reportControllerProvider.notifier).setType(t),
                    onTownChanged: (String t) =>
                        ref.read(reportControllerProvider.notifier).setTown(t),
                    onSpotChanged: (String s) =>
                        ref.read(reportControllerProvider.notifier).setSpot(s),
                    onNoteChanged: (String n) =>
                        ref.read(reportControllerProvider.notifier).setNote(n),
                  ),
                  2 => _Step2Consent(
                    consentStorage: state.draft.consentStorage,
                    consentContact: state.draft.consentContact,
                    errorMessage: state.errorMessage,
                    onToggleStorage: () => ref
                        .read(reportControllerProvider.notifier)
                        .toggleConsentStorage(),
                    onToggleContact: () => ref
                        .read(reportControllerProvider.notifier)
                        .toggleConsentContact(),
                  ),
                  3 => const _Step3SuccessTimeline(),
                  _ => const SizedBox.shrink(),
                },
              ),
            ),
            // Sticky Action Button Footer
            Container(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.md + MediaQuery.of(context).padding.bottom,
              ),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.darkLine : AppColors.lightLine,
                    width: 1,
                  ),
                ),
              ),
              child: switch (state.currentStep) {
                0 => AppButton(
                  label: 'Continue',
                  onPressed: state.draft.canProceedToStep1
                      ? () => ref
                            .read(reportControllerProvider.notifier)
                            .setStep(1)
                      : null,
                ),
                1 => AppButton(
                  label: 'Continue',
                  onPressed: state.draft.canProceedToStep2
                      ? () => ref
                            .read(reportControllerProvider.notifier)
                            .setStep(2)
                      : null,
                ),
                2 => AppButton(
                  label: 'Submit for review',
                  isLoading: state.isSubmitting,
                  onPressed: (state.draft.canSubmit && !state.isSubmitting)
                      ? () => ref
                            .read(reportControllerProvider.notifier)
                            .submitReport()
                      : null,
                ),
                3 => AppButton(
                  label: 'Done',
                  onPressed: () {
                    ref.read(reportControllerProvider.notifier).resetFlow();
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                _ => const SizedBox.shrink(),
              },
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// Step 0: Photograph it
// -------------------------------------------------------------
class _Step0Photograph extends StatefulWidget {
  const _Step0Photograph({
    required this.isPhotoCaptured,
    required this.selectedType,
    required this.onSnap,
  });

  final bool isPhotoCaptured;
  final DocumentType selectedType;
  final VoidCallback onSnap;

  @override
  State<_Step0Photograph> createState() => _Step0PhotographState();
}

class _Step0PhotographState extends State<_Step0Photograph>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scanController;
  bool _flashing = false;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  void _triggerSnap() {
    setState(() => _flashing = true);
    Future<void>.delayed(const Duration(milliseconds: 260), () {
      if (mounted) {
        setState(() => _flashing = false);
        widget.onSnap();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: <Widget>[
        // Viewfinder Frame
        Container(
          height: 280,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF14201A),
            borderRadius: AppRadius.card,
            border: Border.all(color: const Color(0xFF26372E)),
          ),
          child: Stack(
            children: <Widget>[
              if (!widget.isPhotoCaptured) ...<Widget>[
                // Corner brackets in Cameroon Yellow (#F5B700)
                ..._buildCornerBrackets(),
                // Animated laser line
                AnimatedBuilder(
                  animation: _scanController,
                  builder: (BuildContext context, Widget? child) {
                    return Align(
                      alignment: Alignment(0, _scanController.value * 2 - 1),
                      child: Container(
                        height: 2,
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: AppColors.lightSun,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: AppColors.lightSun.withValues(alpha: 0.6),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                // Center Helper text
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Place the document flat and fit it inside the frame',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
              ] else ...<Widget>[
                // Redacted Preview
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: RedactedDoc(
                      type: widget.selectedType,
                      isLarge: true,
                    ),
                  ),
                ),
              ],
              // Flash overlay
              if (_flashing)
                Container(color: Colors.white.withValues(alpha: 0.9)),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (widget.isPhotoCaptured) ...<Widget>[
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: AppRadius.card,
              border: Border.all(
                color: isDark ? AppColors.darkLine : AppColors.lightLine,
              ),
            ),
            child: Row(
              children: <Widget>[
                const Text('✨', style: TextStyle(fontSize: 18)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Preview of the public listing. The photo is blurred and the ID number and name are hidden.',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.darkMuted
                          : AppColors.lightMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton.icon(
            onPressed: widget.onSnap,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Retake photo'),
          ),
        ] else ...<Widget>[
          // Shutter Button
          Center(
            child: GestureDetector(
              key: const ValueKey('shutter_button'),
              onTap: _triggerSnap,
              child: Container(
                width: 72,
                height: 72,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkPrimary
                        : AppColors.lightPrimary,
                    width: 4,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkPrimary
                        : AppColors.lightPrimary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  List<Widget> _buildCornerBrackets() {
    const double size = 20;
    const double border = 3;
    const Color color = AppColors.lightSun;

    return <Widget>[
      // Top Left
      Positioned(
        top: 16,
        left: 16,
        child: Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: color, width: border),
              left: BorderSide(color: color, width: border),
            ),
          ),
        ),
      ),
      // Top Right
      Positioned(
        top: 16,
        right: 16,
        child: Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: color, width: border),
              right: BorderSide(color: color, width: border),
            ),
          ),
        ),
      ),
      // Bottom Left
      Positioned(
        bottom: 16,
        left: 16,
        child: Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: color, width: border),
              left: BorderSide(color: color, width: border),
            ),
          ),
        ),
      ),
      // Bottom Right
      Positioned(
        bottom: 16,
        right: 16,
        child: Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: color, width: border),
              right: BorderSide(color: color, width: border),
            ),
          ),
        ),
      ),
    ];
  }
}

// -------------------------------------------------------------
// Step 1: Where and what
// -------------------------------------------------------------
class _Step1WhereAndWhat extends StatelessWidget {
  const _Step1WhereAndWhat({
    required this.selectedType,
    required this.selectedTown,
    required this.spotController,
    required this.noteController,
    required this.onTypeChanged,
    required this.onTownChanged,
    required this.onSpotChanged,
    required this.onNoteChanged,
  });

  final DocumentType selectedType;
  final String selectedTown;
  final TextEditingController spotController;
  final TextEditingController noteController;
  final ValueChanged<DocumentType> onTypeChanged;
  final ValueChanged<String> onTownChanged;
  final ValueChanged<String> onSpotChanged;
  final ValueChanged<String> onNoteChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Document type',
          style: AppTypography.heading2.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: DocumentType.values.map((DocumentType type) {
            final bool selected = selectedType == type;
            return AppChip(
              label: type.label,
              isSelected: selected,
              onTap: () => onTypeChanged(type),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Town where you found it',
          style: AppTypography.heading2.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<String>(
          initialValue: AppTowns.reportTowns.contains(selectedTown)
              ? selectedTown
              : AppTowns.reportTowns.first,
          items: AppTowns.reportTowns.map((String t) {
            return DropdownMenuItem<String>(value: t, child: Text(t));
          }).toList(),
          onChanged: (String? val) {
            if (val != null) onTownChanged(val);
          },
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Exact place',
          style: AppTypography.heading2.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: spotController,
          onChanged: onSpotChanged,
          decoration: const InputDecoration(
            hintText: 'e.g. Marché Mokolo, near the bank',
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Note (optional)',
          style: AppTypography.heading2.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: noteController,
          onChanged: onNoteChanged,
          decoration: const InputDecoration(hintText: 'Anything that helps'),
        ),
      ],
    );
  }
}

// -------------------------------------------------------------
// Step 2: Consent (Cameroon Law No. 2024/017)
// -------------------------------------------------------------
class _Step2Consent extends StatelessWidget {
  const _Step2Consent({
    required this.consentStorage,
    required this.consentContact,
    required this.onToggleStorage,
    required this.onToggleContact,
    this.errorMessage,
  });

  final bool consentStorage;
  final bool consentContact;
  final VoidCallback onToggleStorage;
  final VoidCallback onToggleContact;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Nothing is selected for you. Tick each box to agree.',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _ConsentCheckboxTile(
          isChecked: consentStorage,
          title: 'Photo and location',
          subtitle:
              'Doc-Find may store this photo and where I found it, to help the owner.',
          onTap: onToggleStorage,
        ),
        const SizedBox(height: AppSpacing.md),
        _ConsentCheckboxTile(
          isChecked: consentContact,
          title: 'Phone number for handoff',
          subtitle:
              'The team may call me to arrange handing the document over. Owners never see my number.',
          onTap: onToggleContact,
        ),
        const SizedBox(height: AppSpacing.lg),
        // Cameroon legal notice
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: AppRadius.card,
            border: Border.all(
              color: isDark ? AppColors.darkLine : AppColors.lightLine,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('🇨🇲', style: TextStyle(fontSize: 20)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Your data is handled under Cameroon’s Law No. 2024/017 on personal data protection. You can withdraw consent anytime.',
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (errorMessage != null) ...<Widget>[
          const SizedBox(height: AppSpacing.md),
          Text(
            errorMessage!,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkRed : AppColors.lightRed,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

class _ConsentCheckboxTile extends StatelessWidget {
  const _ConsentCheckboxTile({
    required this.isChecked,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final bool isChecked;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color primary = isDark
        ? AppColors.darkPrimary
        : AppColors.lightPrimary;

    return Material(
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      borderRadius: AppRadius.card,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.card,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: AppRadius.card,
            border: Border.all(
              color: isChecked
                  ? primary
                  : (isDark ? AppColors.darkLine : AppColors.lightLine),
              width: isChecked ? 2 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: isChecked ? primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isChecked
                        ? primary
                        : (isDark ? AppColors.darkLine : AppColors.lightLine),
                    width: 2,
                  ),
                ),
                child: isChecked
                    ? Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: isDark
                            ? AppColors.darkOnPrimary
                            : AppColors.lightOnPrimary,
                      )
                    : null,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: AppTypography.heading2.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.darkMuted
                            : AppColors.lightMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// Step 3: Success Timeline
// -------------------------------------------------------------
class _Step3SuccessTimeline extends StatelessWidget {
  const _Step3SuccessTimeline();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color primary = isDark
        ? AppColors.darkPrimary
        : AppColors.lightPrimary;

    return Column(
      children: <Widget>[
        const SizedBox(height: AppSpacing.lg),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkGreenTint : AppColors.lightGreenTint,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(Icons.check_rounded, size: 40, color: primary),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Thank you',
          style: AppTypography.displayLarge.copyWith(
            color: theme.colorScheme.onSurface,
            fontSize: 26,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Someone is going to be very relieved.',
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        // 4-stage timeline
        const _TimelineItem(
          title: 'Report received',
          subtitle: 'Just now',
          isDone: true,
          isActive: false,
          isLast: false,
        ),
        const _TimelineItem(
          title: 'Team review',
          subtitle: 'Usually within a few hours',
          isDone: false,
          isActive: true,
          isLast: false,
        ),
        const _TimelineItem(
          title: 'Posted with redaction',
          subtitle: 'Safe preview for owner identification',
          isDone: false,
          isActive: false,
          isLast: false,
        ),
        const _TimelineItem(
          title: 'Handoff with the owner',
          subtitle: 'Coordinated at official Doc-Find point',
          isDone: false,
          isActive: false,
          isLast: true,
        ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.title,
    required this.subtitle,
    required this.isDone,
    required this.isActive,
    required this.isLast,
  });

  final String title;
  final String subtitle;
  final bool isDone;
  final bool isActive;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color primary = isDark
        ? AppColors.darkPrimary
        : AppColors.lightPrimary;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isDone
                      ? primary
                      : (isActive
                            ? (isDark
                                  ? AppColors.darkGreenTint
                                  : AppColors.lightGreenTint)
                            : (isDark
                                  ? AppColors.darkSurface
                                  : AppColors.lightSurface)),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: (isDone || isActive)
                        ? primary
                        : (isDark ? AppColors.darkLine : AppColors.lightLine),
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: isDone
                    ? Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: isDark
                            ? AppColors.darkOnPrimary
                            : AppColors.lightOnPrimary,
                      )
                    : (isActive
                          ? Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: primary,
                                shape: BoxShape.circle,
                              ),
                            )
                          : null),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isDone
                        ? primary
                        : (isDark ? AppColors.darkLine : AppColors.lightLine),
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: AppTypography.heading2.copyWith(
                      color: (isDone || isActive)
                          ? theme.colorScheme.onSurface
                          : (isDark
                                ? AppColors.darkMuted
                                : AppColors.lightMuted),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.darkMuted
                          : AppColors.lightMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
