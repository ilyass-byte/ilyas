import 'package:flutter/material.dart';
import 'core/language.dart';
import 'core/settings_manager.dart';
import 'screens/dashboard_screen.dart';

/// Widget رئيسي يستمع لتغييرات اللغة ويعيد بناء التطبيق
class LocalizedApp extends StatefulWidget {
  const LocalizedApp({Key? key}) : super(key: key);

  @override
  State<LocalizedApp> createState() => _LocalizedAppState();
}

class _LocalizedAppState extends State<LocalizedApp> {
  @override
  void initState() {
    super.initState();
    // الاستماع لتغييرات اللغة والإعدادات
    AppLocalizations.instance.addListener(_onLanguageChanged);
    SettingsManager.instance.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    // إزالة المستمع عند التخلص من الـ widget
    AppLocalizations.instance.removeListener(_onLanguageChanged);
    SettingsManager.instance.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    // إعادة بناء التطبيق عند تغيير اللغة
    setState(() {});
  }

  void _onSettingsChanged() {
    // إعادة بناء التطبيق عند تغيير الإعدادات
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppLocalizations.translate('app_title'),
      theme: SettingsManager.instance.currentTheme,
      home: const DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Widget مساعد لتطبيق الترجمة على أي widget
class LocalizedWidget extends StatefulWidget {
  final Widget Function(BuildContext context) builder;

  const LocalizedWidget({Key? key, required this.builder}) : super(key: key);

  @override
  State<LocalizedWidget> createState() => _LocalizedWidgetState();
}

class _LocalizedWidgetState extends State<LocalizedWidget> {
  @override
  void initState() {
    super.initState();
    AppLocalizations.instance.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    AppLocalizations.instance.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}

/// Mixin لإضافة دعم الترجمة لأي StatefulWidget
mixin LocalizationMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    AppLocalizations.instance.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    AppLocalizations.instance.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) {
      setState(() {});
    }
  }
}

/// Extension لتسهيل استخدام الترجمة
extension LocalizationExtension on String {
  String get tr => AppLocalizations.translate(this);
}

/// Widget لعرض اللغة الحالية (الإنجليزية فقط)
class LanguageSelector extends StatelessWidget {
  final bool showFlag;
  final TextStyle? textStyle;

  const LanguageSelector({super.key, this.showFlag = true, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showFlag) const Text('🇺🇸 '),
        Text('English', style: textStyle),
        const SizedBox(width: 8),
        const Icon(Icons.language),
      ],
    );
  }
}

/// Widget لعرض النص المترجم
class TranslatedText extends StatelessWidget {
  final String translationKey;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TranslatedText(
    this.translationKey, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return LocalizedWidget(
      builder:
          (context) => Text(
            AppLocalizations.translate(translationKey),
            style: style,
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow,
          ),
    );
  }
}

/// Widget لعرض AppBar مترجم
class LocalizedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleKey;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;

  const LocalizedAppBar({
    Key? key,
    required this.titleKey,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LocalizedWidget(
      builder:
          (context) => AppBar(
            title: Text(AppLocalizations.translate(titleKey)),
            actions: actions,
            leading: leading,
            automaticallyImplyLeading: automaticallyImplyLeading,
            backgroundColor: backgroundColor,
          ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
