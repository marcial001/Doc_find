import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../constants/document_types.dart';
import '../theme/app_typography.dart';

/// Renders a simulated official document card with blurred photo portrait,
/// black redaction bars, and document type stamp.
/// Matches the `.doc` element from the wireframes.
class RedactedDoc extends StatelessWidget {
  const RedactedDoc({
    required this.type,
    this.isLarge = false,
    this.width,
    this.height,
    super.key,
  });

  final DocumentType type;
  final bool isLarge;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final double cardWidth = width ?? (isLarge ? 320 : 76);
    final double cardHeight = height ?? (isLarge ? 202 : 48);
    final double borderRadius = isLarge ? 16 : 8;
    final double headerHeight = isLarge ? 22 : 6;
    final double photoWidth = isLarge ? 72 : 18;
    final double photoHeight = isLarge ? 88 : 22;
    final double barHeight = isLarge ? 10 : 3;

    return Semantics(
      label: '${type.label} with redacted personal details',
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: const Color(0xFFD0D7D2),
            width: isLarge ? 1.5 : 1,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: isLarge ? 0.08 : 0.04),
              blurRadius: isLarge ? 12 : 4,
              offset: Offset(0, isLarge ? 6 : 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Colored header stripe
            Container(height: headerHeight, color: type.color),
            // Document body
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(isLarge ? 12 : 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Blurred simulated photo
                    Container(
                      width: photoWidth,
                      height: photoHeight,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC4CDC7),
                        borderRadius: BorderRadius.circular(isLarge ? 8 : 3),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[Color(0xFF8B9B90), Color(0xFF5A6860)],
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: BackdropFilter(
                        filter: ui.ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        child: const SizedBox.expand(),
                      ),
                    ),
                    SizedBox(width: isLarge ? 12 : 4),
                    // Redacted field lines
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _RedactionBar(height: barHeight, widthFactor: 0.95),
                          SizedBox(height: isLarge ? 8 : 2.5),
                          _RedactionBar(height: barHeight, widthFactor: 0.8),
                          SizedBox(height: isLarge ? 8 : 2.5),
                          _RedactionBar(height: barHeight, widthFactor: 0.55),
                          const Spacer(),
                          // Document type badge / stamp in bottom right
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isLarge ? 8 : 3,
                                vertical: isLarge ? 2 : 1,
                              ),
                              decoration: BoxDecoration(
                                color: type.color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: type.color,
                                  width: isLarge ? 1.5 : 1,
                                ),
                              ),
                              child: Text(
                                type.badge,
                                style: TextStyle(
                                  fontFamily: AppTypography.headingFont,
                                  fontSize: isLarge ? 12 : 7,
                                  fontWeight: FontWeight.w800,
                                  color: type.color,
                                  height: 1.1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RedactionBar extends StatelessWidget {
  const _RedactionBar({required this.height, required this.widthFactor});

  final double height;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFF10231A),
          borderRadius: BorderRadius.circular(height / 2),
        ),
      ),
    );
  }
}
