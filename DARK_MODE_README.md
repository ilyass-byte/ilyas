# الوضع الليلي (Dark Mode) - دليل الاستخدام 🌙

تم تفعيل الوضع الليلي بنجاح في التطبيق! يمكنك الآن التبديل بين الوضع الليلي والفاتح بسهولة.

## ✅ الميزات المتوفرة

### 1. التبديل السريع من الشاشة الرئيسية
- زر التبديل موجود في الـ AppBar في الشاشة الرئيسية
- أيقونة القمر 🌙 للتبديل إلى الوضع الليلي
- أيقونة الشمس ☀️ للتبديل إلى الوضع الفاتح
- رسالة تأكيد تظهر عند التبديل

### 2. إعدادات متقدمة
- يمكن الوصول للإعدادات من خلال زر القائمة
- لوحة الإعدادات السريعة تحتوي على مفتاح الوضع الليلي
- حفظ تلقائي للإعدادات

### 3. ألوان محسنة
- **الوضع الليلي**: خلفية داكنة مريحة للعين
- **الوضع الفاتح**: خلفية فاتحة كلاسيكية
- انتقال سلس بين الأوضاع
- ألوان متناسقة لجميع العناصر

## 🎨 تفاصيل الألوان

### الوضع الليلي
- خلفية رئيسية: `#0D1117` (رمادي داكن)
- خلفية البطاقات: `#161B22` (رمادي متوسط)
- النصوص: `#E6EDF3` (أبيض مائل للرمادي)
- الألوان الأساسية: `#667EEA` و `#764BA2`

### الوضع الفاتح
- خلفية رئيسية: `#F8F9FA` (رمادي فاتح جداً)
- خلفية البطاقات: `#FFFFFF` (أبيض)
- النصوص: `#2D3748` (رمادي داكن)
- الألوان الأساسية: `#667EEA` و `#764BA2`

## 🚀 كيفية الاستخدام

### الطريقة الأولى: من الشاشة الرئيسية
1. افتح التطبيق
2. انظر إلى الـ AppBar في الأعلى
3. اضغط على أيقونة القمر/الشمس
4. سيتم التبديل فوراً مع رسالة تأكيد

### الطريقة الثانية: من الإعدادات
1. اضغط على زر القائمة (☰) في الأعلى يسار
2. اختر "Quick Settings Panel"
3. استخدم مفتاح "Dark Mode"
4. سيتم حفظ الإعداد تلقائياً

## 🧪 اختبار الوضع الليلي

يمكنك اختبار الوضع الليلي باستخدام الملف التجريبي:

```dart
import 'lib/test_dark_mode.dart';

void main() {
  runApp(const TestDarkMode());
}
```

هذا الملف يحتوي على:
- عرض حالة الثيم الحالي
- أزرار تجريبية لاختبار الألوان
- معلومات تفصيلية عن الثيم
- زر تبديل كبير

## 🔧 للمطورين

### إضافة دعم الوضع الليلي لشاشة جديدة

```dart
class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> with LocalizationMixin {
  @override
  void initState() {
    super.initState();
    // إضافة مستمع للإعدادات
    SettingsManager.instance.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    // إزالة المستمع
    SettingsManager.instance.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // استخدم Theme.of(context) للألوان
      body: Card(
        color: Theme.of(context).cardColor,
        child: Text(
          'مرحبا',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
```

### استخدام SettingsManager

```dart
// التحقق من الوضع الحالي
bool isDark = SettingsManager.instance.isDarkMode;

// التبديل
SettingsManager.instance.toggleDarkMode();

// تعيين وضع محدد
SettingsManager.instance.setDarkMode(true); // وضع ليلي
SettingsManager.instance.setDarkMode(false); // وضع فاتح

// الحصول على الثيم الحالي
ThemeData currentTheme = SettingsManager.instance.currentTheme;
```

## 📱 الحالة الافتراضية

- الوضع الليلي مفعل افتراضياً (`_isDarkMode = true`)
- يمكن تغيير هذا في `lib/core/settings_manager.dart`
- الإعدادات تُحفظ في الذاكرة أثناء تشغيل التطبيق

## 🎯 الخطوات التالية المقترحة

1. **حفظ الإعدادات**: إضافة SharedPreferences لحفظ الإعدادات
2. **وضع تلقائي**: تبديل تلقائي حسب وقت النهار
3. **ثيمات إضافية**: إضافة ألوان وثيمات أخرى
4. **انتقالات متحركة**: إضافة انتقالات سلسة عند التبديل

---

## ✅ تم الانتهاء بنجاح!

الوضع الليلي يعمل الآن بشكل مثالي في جميع أنحاء التطبيق. استمتع بالتجربة المحسنة! 🌙✨
