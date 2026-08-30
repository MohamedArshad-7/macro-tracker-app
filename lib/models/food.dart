class Food {
  final String id;
  final String name;
  final String category;
  final double calories; // per 100g
  final double protein;  // per 100g
  final double carbs;    // per 100g
  final double fat;      // per 100g
  final double fiber;    // per 100g
  final double servingSize;
  final String servingUnit;
  final String? imageUrl;

  Food({
    required this.id,
    required this.name,
    required this.category,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    this.servingSize = 100,
    this.servingUnit = 'g',
    this.imageUrl,
  });

  Food copyWith({
    String? id,
    String? name,
    String? category,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    double? fiber,
    double? servingSize,
    String? servingUnit,
    String? imageUrl,
  }) {
    return Food(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      fiber: fiber ?? this.fiber,
      servingSize: servingSize ?? this.servingSize,
      servingUnit: servingUnit ?? this.servingUnit,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'calories': calories,
    'protein': protein,
    'carbs': carbs,
    'fat': fat,
    'fiber': fiber,
    'servingSize': servingSize,
    'servingUnit': servingUnit,
    'imageUrl': imageUrl,
  };

  factory Food.fromJson(Map<String, dynamic> json) => Food(
    id: json['id'],
    name: json['name'],
    category: json['category'],
    calories: json['calories'].toDouble(),
    protein: json['protein'].toDouble(),
    carbs: json['carbs'].toDouble(),
    fat: json['fat'].toDouble(),
    fiber: json['fiber'].toDouble(),
    servingSize: json['servingSize'].toDouble(),
    servingUnit: json['servingUnit'],
    imageUrl: json['imageUrl'],
  );
}
