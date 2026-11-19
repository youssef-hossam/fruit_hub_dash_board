import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

/// A utility class that provides pre-styled [AwesomeDialog] widgets
/// for Error and Success alert scenarios.
///
/// Usage:
/// ```dart
/// CustomAlertDialog.error(
///   context: context,
///   title: 'Something went wrong',
///   desc: 'Please try again later.',
/// ).show();
///
/// CustomAlertDialog.success(
///   context: context,
///   title: 'Done!',
///   desc: 'Your changes have been saved.',
/// ).show();
/// ```
class CustomAlertDialog {
  // ─── Private constructor — use factory methods ───────────────────────────
  CustomAlertDialog._();

  // ─── Shared defaults ─────────────────────────────────────────────────────
  static const Duration _autoHide = Duration(seconds: 4);
  static const AnimType _animType = AnimType.scale;
  static const bool _headerLoop = false; // plays animation once, feels cleaner

  // ─── Color palette ───────────────────────────────────────────────────────
  static const Color _errorColor = Color(0xFFE53935);   // Material Red 600
  static const Color _successColor = Color(0xFF43A047); // Material Green 600
  static const Color _btnTextColor = Colors.white;

  // ─── ERROR dialog ─────────────────────────────────────────────────────────
  /// Returns a fully configured error [AwesomeDialog].
  /// Call `.show()` on the returned instance to display it.
  ///
  /// [title]           — Bold headline text.
  /// [desc]            — Descriptive body text.
  /// [btnOkText]       — Label for the confirm button (default: "Got it").
  /// [btnOkOnPress]    — Optional callback when the confirm button is tapped.
  /// [onDismissCallback] — Optional callback whenever the dialog closes.
  /// [autoDismiss]     — Whether tapping Ok closes the dialog (default: true).
  static AwesomeDialog error({
    required BuildContext context,
    required String title,
    required String desc,
    String btnOkText = 'Got it',
    VoidCallback? btnOkOnPress,
    void Function(DismissType)? onDismissCallback,
    bool autoDismiss = true,
    bool dismissOnTouchOutside = false,
  }) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: _animType,
      headerAnimationLoop: _headerLoop,

      // ── Content ──────────────────────────────────────────────────────────
      title: title,
      desc: desc,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

      // ── Styling ──────────────────────────────────────────────────────────
      dialogBackgroundColor: Colors.white,
      borderSide: const BorderSide(color: _errorColor, width: 2),
      titleTextStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: _errorColor,
      ),
      descTextStyle: const TextStyle(
        fontSize: 14,
        color: Color(0xFF424242),
        height: 1.5,
      ),

      // ── Buttons ──────────────────────────────────────────────────────────
      btnOkText: btnOkText,
      btnOkIcon: Icons.close_rounded,
      btnOkColor: _errorColor,
      btnOkOnPress: btnOkOnPress ?? () {},
      buttonsTextStyle: const TextStyle(
        color: _btnTextColor,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      buttonsBorderRadius: BorderRadius.circular(10),

      // ── Behaviour ────────────────────────────────────────────────────────
      dismissOnTouchOutside: dismissOnTouchOutside,
      dismissOnBackKeyPress: true,
      autoDismiss: autoDismiss,
      onDismissCallback: onDismissCallback,

      // ── Custom header for a richer look ──────────────────────────────────
      customHeader: _ErrorHeader(),
    );
  }

  // ─── SUCCESS dialog ───────────────────────────────────────────────────────
  /// Returns a fully configured success [AwesomeDialog].
  /// Call `.show()` on the returned instance to display it.
  ///
  /// [title]           — Bold headline text.
  /// [desc]            — Descriptive body text.
  /// [btnOkText]       — Label for the confirm button (default: "Continue").
  /// [btnOkOnPress]    — Optional callback when the confirm button is tapped.
  /// [autoHide]        — Auto-dismiss after a duration (default: 4 s).
  /// [onDismissCallback] — Optional callback whenever the dialog closes.
  static AwesomeDialog success({
    required BuildContext context,
    required String title,
    required String desc,
    String btnOkText = 'Continue',
    VoidCallback? btnOkOnPress,
    Duration autoHide = _autoHide,
    void Function(DismissType)? onDismissCallback,
    bool dismissOnTouchOutside = true,
  }) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: _animType,
      headerAnimationLoop: _headerLoop,

      // ── Content ──────────────────────────────────────────────────────────
      title: title,
      desc: desc,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

      // ── Styling ──────────────────────────────────────────────────────────
      dialogBackgroundColor: Colors.white,
      borderSide: const BorderSide(color: _successColor, width: 2),
      titleTextStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: _successColor,
      ),
      descTextStyle: const TextStyle(
        fontSize: 14,
        color: Color(0xFF424242),
        height: 1.5,
      ),

      // ── Buttons ──────────────────────────────────────────────────────────
      btnOkText: btnOkText,
      btnOkIcon: Icons.check_rounded,
      btnOkColor: _successColor,
      btnOkOnPress: btnOkOnPress ?? () {},
      buttonsTextStyle: const TextStyle(
        color: _btnTextColor,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      buttonsBorderRadius: BorderRadius.circular(10),

      // ── Behaviour ────────────────────────────────────────────────────────
      dismissOnTouchOutside: dismissOnTouchOutside,
      dismissOnBackKeyPress: true,
      autoHide: autoHide,
      onDismissCallback: onDismissCallback,

      // ── Custom header for a richer look ──────────────────────────────────
      customHeader: _SuccessHeader(),
    );
  }
}

// ─── Custom header widgets ────────────────────────────────────────────────────

/// Animated pulsing error icon header.
class _ErrorHeader extends StatefulWidget {
  @override
  State<_ErrorHeader> createState() => _ErrorHeaderState();
}

class _ErrorHeaderState extends State<_ErrorHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _scale = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFFFEBEE), // red[50]
          border: Border.all(color: const Color(0xFFE53935), width: 3),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE53935).withValues(alpha: 0.35),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(
          Icons.error_outline_rounded,
          color: Color(0xFFE53935),
          size: 44,
        ),
      ),
    );
  }
}

/// Animated bounce-in success icon header.
class _SuccessHeader extends StatefulWidget {
  @override
  State<_SuccessHeader> createState() => _SuccessHeaderState();
}

class _SuccessHeaderState extends State<_SuccessHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFE8F5E9), // green[50]
          border: Border.all(color: const Color(0xFF43A047), width: 3),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF43A047).withValues(alpha: 0.35),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(
          Icons.check_circle_outline_rounded,
          color: Color(0xFF43A047),
          size: 44,
        ),
      ),
    );
  }
}

// ─── Quick demo / usage example ──────────────────────────────────────────────
//
// Inside any widget's build or callback:
//
// // Error
// CustomAlertDialog.error(
//   context: context,
//   title: 'Login Failed',
//   desc: 'Invalid credentials. Please check your email and password.',
//   btnOkOnPress: () => print('User acknowledged error'),
// ).show();
//
// // Success
// CustomAlertDialog.success(
//   context: context,
//   title: 'Profile Updated',
//   desc: 'Your information has been saved successfully.',
//   btnOkOnPress: () => Navigator.pop(context),
// ).show();
