import 'package:intl/intl.dart';

final _money = NumberFormat('#,##0.##', 'en');

/// 1250.5 -> "1,250.5 جنيه"
String formatPrice(num value) => '${_money.format(value)} جنيه';

/// Short, human "time ago" in Arabic for order lists.
String timeAgo(DateTime date, {DateTime? now}) {
  final diff = (now ?? DateTime.now()).difference(date);
  if (diff.inMinutes < 1) return 'الآن';
  if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
  if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
  if (diff.inDays == 1) return 'أمس';
  if (diff.inDays < 7) return 'منذ ${diff.inDays} أيام';
  return DateFormat('d/M/yyyy').format(date);
}

String formatDateTime(DateTime date) =>
    DateFormat('d/M/yyyy – h:mm a', 'en').format(date);

/// Categories used by the client app's filters.
const Map<String, String> kCategories = {
  'fruits': 'فواكه',
  'citrus': 'حمضيات',
  'tropical': 'استوائية',
  'berries': 'توت',
};

String categoryLabel(String key) => kCategories[key] ?? key;
