// Sample catalogue shared with the FruitHub client app (same documents),
// used to run the dashboard in demo mode (`--dart-define=DEMO=true`).

const String _imagesBase =
    'https://raw.githubusercontent.com/youssef-hossam/fruit_hup_app/main/assets/products';

String _img(String name) => '$_imagesBase/$name.jpg';

const List<Map<String, dynamic>> _reviewers = [
  {'name': 'أحمد علي', 'image': ''},
  {'name': 'سارة محمد', 'image': ''},
  {'name': 'محمود حسن', 'image': ''},
  {'name': 'منة الله إبراهيم', 'image': ''},
  {'name': 'يوسف خالد', 'image': ''},
  {'name': 'نور أحمد', 'image': ''},
];

const List<String> _reviewTexts = [
  'طازجة جدًا وطعمها رائع، وصلت في معادها بالظبط 👌',
  'جودة ممتازة وسعر مناسب، أكيد هطلب تاني.',
  'التغليف كان ممتاز والفاكهة سليمة تمامًا.',
  'حلوة جدًا بس الكمية كانت أقل شوية من المتوقع.',
  'من أحسن الفواكه اللي جربتها أونلاين، أنصح بيها.',
  'الطعم طبيعي ومش مخزنة، تجربة ممتازة.',
];

List<Map<String, dynamic>> _reviewsFor(int seed, int count) {
  return List.generate(count, (i) {
    final reviewer = _reviewers[(seed + i) % _reviewers.length];
    final day = ((seed * 3 + i * 5) % 27) + 1;
    return {
      'name': reviewer['name'],
      'image': reviewer['image'],
      'rating': 5 - ((seed + i) % 3 == 0 ? 1 : 0),
      'date': '2026-10-${day.toString().padLeft(2, '0')}',
      'reviewDescription': _reviewTexts[(seed + i * 2) % _reviewTexts.length],
    };
  });
}

Map<String, dynamic> _product({
  required int index,
  required String id,
  required String name,
  required String nameEn,
  required String description,
  required String descriptionEn,
  required double price,
  double? oldPrice,
  String unit = 'كيلو',
  String unitEn = 'kg',
  required String category,
  bool isFeatured = false,
  bool isOrganic = false,
  required int expirationMonths,
  required int calories,
  required double rating,
  required int ratingCount,
  required int sellingCount,
}) {
  return {
    'id': id,
    'name': name,
    'nameEn': nameEn,
    'code': 'FH-${(100 + index).toString()}',
    'description': description,
    'descriptionEn': descriptionEn,
    'price': price,
    'oldPrice': ?oldPrice,
    'unit': unit,
    'unitEn': unitEn,
    'imageUrl': _img(id),
    'category': category,
    'isFeatured': isFeatured,
    'isOrganic': isOrganic,
    'expirationMonths': expirationMonths,
    'numberOfCalories': calories,
    'avgRating': rating,
    'ratingCount': ratingCount,
    'sellingCount': sellingCount,
    // Stock left: a few items run low so the dashboard can warn about them.
    'quantity': index % 6 == 0 ? 6 + index % 5 : 40 + (index * 17) % 90,
    'reviews': _reviewsFor(index, 3),
  };
}

final List<Map<String, dynamic>> demoProducts = [
  _product(
    index: 1,
    id: 'mango',
    name: 'مانجو عويسي',
    nameEn: 'Owais Mango',
    description:
        'مانجو عويسي مصري أصلي، حلوة وعصيرية وخالية من الألياف. مثالية للأكل مباشرة أو للعصير.',
    descriptionEn:
        'Authentic Egyptian Owais mango — sweet, juicy and fiber-free. Perfect to eat fresh or for juice.',
    price: 75,
    oldPrice: 95,
    category: 'tropical',
    isFeatured: true,
    isOrganic: true,
    expirationMonths: 1,
    calories: 60,
    rating: 4.9,
    ratingCount: 412,
    sellingCount: 1840,
  ),
  _product(
    index: 2,
    id: 'apple',
    name: 'تفاح أحمر',
    nameEn: 'Red Apple',
    description:
        'تفاح أحمر مقرمش وطازج، غني بالألياف وفيتامين C. مناسب للأطفال وللوجبات الخفيفة.',
    descriptionEn:
        'Crisp, fresh red apples rich in fiber and vitamin C. Great for kids and healthy snacks.',
    price: 45,
    category: 'fruits',
    isOrganic: true,
    expirationMonths: 2,
    calories: 52,
    rating: 4.7,
    ratingCount: 356,
    sellingCount: 1620,
  ),
  _product(
    index: 3,
    id: 'watermelon',
    name: 'بطيخ',
    nameEn: 'Watermelon',
    description:
        'بطيخ أحمر سكري ومنعش، مختار بعناية من المزارع. الأفضل لأيام الصيف الحارة.',
    descriptionEn:
        'Sweet, refreshing red watermelon hand-picked from the farm. The best for hot summer days.',
    price: 18,
    oldPrice: 22,
    category: 'fruits',
    isFeatured: true,
    expirationMonths: 1,
    calories: 30,
    rating: 4.6,
    ratingCount: 289,
    sellingCount: 1510,
  ),
  _product(
    index: 4,
    id: 'banana',
    name: 'موز',
    nameEn: 'Banana',
    description:
        'موز بلدي ناضج ومليان طاقة، مصدر ممتاز للبوتاسيوم. مناسب للرياضيين والفطار.',
    descriptionEn:
        'Ripe local bananas full of energy and a great source of potassium. Ideal for breakfast and workouts.',
    price: 30,
    category: 'tropical',
    expirationMonths: 1,
    calories: 89,
    rating: 4.5,
    ratingCount: 301,
    sellingCount: 1395,
  ),
  _product(
    index: 5,
    id: 'orange',
    name: 'برتقال أبو سرة',
    nameEn: 'Navel Orange',
    description:
        'برتقال أبو سرة حلو وبدون بذور، مليان عصير وفيتامين C لتقوية المناعة.',
    descriptionEn:
        'Sweet, seedless navel oranges packed with juice and vitamin C to boost immunity.',
    price: 25,
    category: 'citrus',
    isOrganic: true,
    expirationMonths: 2,
    calories: 47,
    rating: 4.8,
    ratingCount: 264,
    sellingCount: 1280,
  ),
  _product(
    index: 6,
    id: 'grapes',
    name: 'عنب أبيض',
    nameEn: 'White Grapes',
    description: 'عنب أبيض بناتي بدون بذر، حبات كبيرة ومقرمشة وطعم سكري.',
    descriptionEn: 'Seedless white grapes with big, crunchy berries and a sugary taste.',
    price: 55,
    oldPrice: 65,
    category: 'fruits',
    isFeatured: true,
    expirationMonths: 1,
    calories: 69,
    rating: 4.7,
    ratingCount: 198,
    sellingCount: 1105,
  ),
  _product(
    index: 7,
    id: 'pomegranate',
    name: 'رمان',
    nameEn: 'Pomegranate',
    description:
        'رمان منفلوطي بحبات حمراء غامقة، غني بمضادات الأكسدة ومثالي للعصير.',
    descriptionEn:
        'Deep-red Manfalouty pomegranates, rich in antioxidants and perfect for juice.',
    price: 40,
    category: 'fruits',
    isOrganic: true,
    expirationMonths: 2,
    calories: 83,
    rating: 4.6,
    ratingCount: 143,
    sellingCount: 940,
  ),
  _product(
    index: 8,
    id: 'mandarin',
    name: 'يوسفي',
    nameEn: 'Mandarin',
    description: 'يوسفي سهل التقشير وحلو المذاق، سناك صحي ومنعش طول اليوم.',
    descriptionEn: 'Easy-to-peel, sweet mandarins — a fresh and healthy snack all day.',
    price: 28,
    category: 'citrus',
    expirationMonths: 1,
    calories: 53,
    rating: 4.4,
    ratingCount: 121,
    sellingCount: 870,
  ),
  _product(
    index: 9,
    id: 'pineapple',
    name: 'أناناس',
    nameEn: 'Pineapple',
    description: 'أناناس استوائي طازج بطعم حلو وحامض، مستورد ومختار بعناية.',
    descriptionEn: 'Fresh tropical pineapple with a sweet and tangy taste, carefully imported.',
    price: 90,
    unit: 'قطعة',
    unitEn: 'piece',
    category: 'tropical',
    isFeatured: true,
    expirationMonths: 1,
    calories: 50,
    rating: 4.5,
    ratingCount: 97,
    sellingCount: 640,
  ),
  _product(
    index: 10,
    id: 'kiwi',
    name: 'كيوي',
    nameEn: 'Kiwi',
    description: 'كيوي أخضر غني بفيتامين C والألياف، طعم منعش ومميز.',
    descriptionEn: 'Green kiwi rich in vitamin C and fiber, with a refreshing, unique taste.',
    price: 120,
    category: 'tropical',
    isOrganic: true,
    expirationMonths: 1,
    calories: 61,
    rating: 4.6,
    ratingCount: 88,
    sellingCount: 590,
  ),
  _product(
    index: 11,
    id: 'avocado',
    name: 'أفوكادو',
    nameEn: 'Avocado',
    description: 'أفوكادو هاس كريمي وغني بالدهون الصحية، مثالي للسلطات والتوست.',
    descriptionEn: 'Creamy Hass avocado full of healthy fats — perfect for salads and toast.',
    price: 150,
    oldPrice: 175,
    category: 'tropical',
    expirationMonths: 1,
    calories: 160,
    rating: 4.8,
    ratingCount: 76,
    sellingCount: 520,
  ),
  _product(
    index: 12,
    id: 'cherry',
    name: 'كريز',
    nameEn: 'Cherries',
    description: 'كريز أحمر لامع وحلو، موسمي ومحدود الكمية.',
    descriptionEn: 'Shiny, sweet red cherries — seasonal and in limited quantity.',
    price: 260,
    category: 'berries',
    expirationMonths: 1,
    calories: 50,
    rating: 4.9,
    ratingCount: 64,
    sellingCount: 410,
  ),
  _product(
    index: 13,
    id: 'blueberry',
    name: 'توت أزرق',
    nameEn: 'Blueberries',
    description: 'توت أزرق طازج في علبة 125 جرام، سوبر فود غني بمضادات الأكسدة.',
    descriptionEn: 'Fresh blueberries in a 125 g box — a superfood rich in antioxidants.',
    price: 95,
    unit: 'علبة',
    unitEn: 'box',
    category: 'berries',
    isOrganic: true,
    expirationMonths: 1,
    calories: 57,
    rating: 4.7,
    ratingCount: 58,
    sellingCount: 380,
  ),
  _product(
    index: 14,
    id: 'lemon',
    name: 'ليمون أصفر',
    nameEn: 'Yellow Lemon',
    description: 'ليمون أصفر عصيري ومستورد، مثالي للعصائر والطبخ.',
    descriptionEn: 'Juicy imported yellow lemons, perfect for drinks and cooking.',
    price: 35,
    category: 'citrus',
    expirationMonths: 2,
    calories: 29,
    rating: 4.3,
    ratingCount: 51,
    sellingCount: 350,
  ),
  _product(
    index: 15,
    id: 'guava',
    name: 'جوافة',
    nameEn: 'Guava',
    description: 'جوافة بلدي بريحة نفاذة وطعم حلو، غنية جدًا بفيتامين C.',
    descriptionEn: 'Local guava with a strong aroma and sweet taste, very rich in vitamin C.',
    price: 30,
    category: 'tropical',
    expirationMonths: 1,
    calories: 68,
    rating: 4.4,
    ratingCount: 47,
    sellingCount: 330,
  ),
  _product(
    index: 16,
    id: 'peach',
    name: 'خوخ',
    nameEn: 'Peach',
    description: 'خوخ ناعم وعصيري بطعم صيفي مميز.',
    descriptionEn: 'Soft, juicy peaches with a distinctive summer taste.',
    price: 60,
    category: 'fruits',
    expirationMonths: 1,
    calories: 39,
    rating: 4.5,
    ratingCount: 39,
    sellingCount: 290,
  ),
  _product(
    index: 17,
    id: 'apricot',
    name: 'مشمش',
    nameEn: 'Apricot',
    description: 'مشمش برتقالي حلو، متاح لفترة قصيرة في الموسم.',
    descriptionEn: 'Sweet orange apricots, available for a short time each season.',
    price: 70,
    category: 'fruits',
    expirationMonths: 1,
    calories: 48,
    rating: 4.4,
    ratingCount: 33,
    sellingCount: 260,
  ),
  _product(
    index: 18,
    id: 'green_apple',
    name: 'تفاح أخضر',
    nameEn: 'Green Apple',
    description: 'تفاح أخضر مقرمش بطعم مُز منعش، ممتاز للسلطات.',
    descriptionEn: 'Crunchy green apples with a refreshing sour taste, great for salads.',
    price: 50,
    category: 'fruits',
    isOrganic: true,
    expirationMonths: 2,
    calories: 52,
    rating: 4.5,
    ratingCount: 29,
    sellingCount: 230,
  ),
  _product(
    index: 19,
    id: 'pear',
    name: 'كمثرى',
    nameEn: 'Pear',
    description: 'كمثرى طرية وحلوة، غنية بالألياف ومفيدة للهضم.',
    descriptionEn: 'Soft, sweet pears rich in fiber and good for digestion.',
    price: 55,
    category: 'fruits',
    expirationMonths: 1,
    calories: 57,
    rating: 4.2,
    ratingCount: 21,
    sellingCount: 180,
  ),
];

/// Orders from different customers over the last two weeks, in every status,
/// so the dashboard charts and order screens have something to show.
List<Map<String, dynamic>> demoOrders(DateTime now) {
  const customers = [
    ('يوسف حدوة', '01012345678', 'شارع الجمهورية، عمارة 12', 'الزقازيق'),
    ('سارة محمد', '01123456789', 'شارع البحر، برج النور', 'طنطا'),
    ('أحمد علي', '01234567890', 'شارع التحرير 45', 'القاهرة'),
    ('منة الله إبراهيم', '01098765432', 'شارع الجلاء 8', 'المنصورة'),
    ('محمود حسن', '01187654321', 'شارع سعد زغلول 21', 'الإسكندرية'),
    ('نور أحمد', '01276543210', 'شارع النصر 3', 'شبين الكوم'),
  ];
  const baskets = [
    [('mango', 2), ('apple', 1), ('grapes', 1)],
    [('watermelon', 2), ('banana', 3)],
    [('avocado', 2), ('kiwi', 1)],
    [('orange', 3), ('mandarin', 2), ('lemon', 1)],
    [('apricot', 2), ('blueberry', 1)],
    [('pomegranate', 2), ('guava', 2)],
    [('mango', 3), ('peach', 1)],
    [('pineapple', 1), ('cherry', 1), ('apple', 2)],
  ];
  const statuses = [
    'pending', 'pending', 'preparing', 'onTheWay', 'delivered', 'delivered',
    'delivered', 'preparing', 'delivered', 'cancelled', 'delivered',
    'onTheWay', 'delivered', 'delivered', 'delivered', 'pending',
    'delivered', 'delivered',
  ];

  Map<String, dynamic>? item(String id, int qty) {
    final matches = demoProducts.where((e) => e['id'] == id);
    if (matches.isEmpty) return null;
    final p = matches.first;
    return {
      'productId': p['id'],
      'name': p['name'],
      'nameEn': p['nameEn'],
      'imageUrl': p['imageUrl'],
      'price': p['price'],
      'unit': p['unit'],
      'unitEn': p['unitEn'],
      'quantity': qty,
    };
  }

  return List.generate(statuses.length, (i) {
    final c = customers[i % customers.length];
    final items = baskets[i % baskets.length]
        .map((e) => item(e.$1, e.$2))
        .whereType<Map<String, dynamic>>()
        .toList();
    final subtotal = items.fold<double>(
        0, (sum, e) => sum + (e['price'] as num) * (e['quantity'] as int));
    final createdAt =
        now.subtract(Duration(hours: i * 17 + (i.isEven ? 2 : 9)));
    return {
      'id': 'FH-${48250 - i * 37}',
      'uid': 'customer-${i % customers.length}',
      'items': items,
      'subtotal': subtotal,
      'deliveryFee': 30,
      'total': subtotal + 30,
      'paymentMethod': i % 3 == 0 ? 'card' : 'cash',
      'status': statuses[i],
      'address': {
        'fullName': c.$1,
        'phone': c.$2,
        'address': c.$3,
        'city': c.$4,
        'floor': 'الدور ${(i % 5) + 1}، شقة ${(i % 9) + 2}',
      },
      'createdAt': createdAt.toIso8601String(),
    };
  });
}
