# ميزة حفظ بيانات الملف الشخصي

## نظرة عامة
تم إضافة نظام شامل لحفظ وإدارة بيانات الملف الشخصي في التطبيق. الآن عندما يقوم المستخدم بتعديل معلوماته الشخصية في صفحة "Edit Profile"، سيتم حفظ هذه البيانات محلياً على الجهاز واستخدامها في جميع أنحاء التطبيق.

## الملفات المضافة/المحدثة

### 1. الملفات الجديدة:
- `lib/models/user_profile.dart` - نموذج بيانات الملف الشخصي
- `lib/core/profile_manager.dart` - مدير حفظ واسترجاع بيانات الملف الشخصي

### 2. الملفات المحدثة:
- `pubspec.yaml` - إضافة مكتبة `shared_preferences`
- `lib/main.dart` - تهيئة ProfileManager عند بدء التطبيق
- `lib/screens/edit_profile_screen.dart` - تحديث لحفظ البيانات الفعلية
- `lib/screens/user_account_screen.dart` - تحديث لعرض البيانات المحفوظة
- `lib/core/language.dart` - إضافة رسالة خطأ جديدة

## كيفية عمل النظام

### 1. نموذج البيانات (UserProfile)
```dart
class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String bio;
  final String? profileImagePath;
}
```

### 2. مدير الملف الشخصي (ProfileManager)
- **Singleton Pattern**: يضمن وجود نسخة واحدة فقط في التطبيق
- **حفظ محلي**: يستخدم SharedPreferences لحفظ البيانات
- **تحديث تلقائي**: يُحدث واجهة المستخدم عند تغيير البيانات
- **معالجة الأخطاء**: يتعامل مع أخطاء الحفظ والاسترجاع

### 3. الوظائف الرئيسية:

#### أ. تحميل البيانات:
```dart
await ProfileManager.instance.initialize();
UserProfile profile = ProfileManager.instance.currentProfile;
```

#### ب. حفظ البيانات:
```dart
UserProfile newProfile = UserProfile(
  name: "الاسم الجديد",
  email: "email@example.com",
  phone: "+20123456789",
  bio: "نبذة شخصية"
);
bool success = await ProfileManager.instance.saveProfile(newProfile);
```

#### ج. تحديث جزئي:
```dart
bool success = await ProfileManager.instance.updateProfile(
  name: "اسم جديد",
  email: "email@example.com"
);
```

## التحسينات المضافة

### 1. التحقق من صحة البيانات:
- التحقق من صيغة البريد الإلكتروني
- التحقق من رقم الهاتف
- التحقق من الحقول المطلوبة

### 2. معالجة الأخطاء:
- رسائل خطأ واضحة للمستخدم
- معالجة أخطاء الحفظ والاسترجاع
- قيم افتراضية في حالة فشل التحميل

### 3. تجربة المستخدم:
- مؤشر تحميل أثناء الحفظ
- رسائل نجاح وفشل
- تحديث فوري للواجهة

## كيفية الاستخدام

### 1. للمطور:
```dart
// الحصول على البيانات الحالية
final profile = ProfileManager.instance.currentProfile;

// حفظ بيانات جديدة
final success = await ProfileManager.instance.saveProfile(newProfile);

// الاستماع للتغييرات
ProfileManager.instance.addListener(() {
  // تحديث الواجهة
});
```

### 2. للمستخدم:
1. اذهب إلى "User Account" → "Edit Profile"
2. قم بتعديل المعلومات المطلوبة
3. اضغط على "Save"
4. ستظهر رسالة تأكيد النجاح
5. ستجد المعلومات محدثة في صفحة الحساب

## المتطلبات التقنية

### المكتبات المطلوبة:
```yaml
dependencies:
  shared_preferences: ^2.2.2
```

### إعدادات الأذونات:
لا توجد أذونات إضافية مطلوبة - SharedPreferences يعمل بدون أذونات خاصة.

## الميزات المستقبلية المقترحة

1. **رفع الصور الشخصية**: إضافة إمكانية تغيير صورة الملف الشخصي
2. **مزامنة السحابة**: حفظ البيانات على الخادم
3. **نسخ احتياطية**: إنشاء نسخ احتياطية من بيانات الملف الشخصي
4. **تشفير البيانات**: تشفير البيانات الحساسة
5. **تسجيل دخول متعدد**: دعم حسابات متعددة

## استكشاف الأخطاء

### مشاكل شائعة:
1. **عدم حفظ البيانات**: تأكد من تشغيل `flutter pub get`
2. **عدم ظهور البيانات**: تأكد من تهيئة ProfileManager في main.dart
3. **أخطاء التحقق**: تأكد من صحة تنسيق البريد الإلكتروني ورقم الهاتف

### سجلات التطوير:
يمكن تفعيل سجلات التطوير لمراقبة عمليات الحفظ والاسترجاع في وضع Debug.
