class Shoe {
  final String id;
  final String name;
  final String image;
  final String desc;
  final double price;
  String selectedSize;
  String selectedColor;
  bool isFavorite;
  int quantity;  // Добавлено поле quantity

  Shoe({
    required this.id,
    required this.name,
    required this.image,
    required this.desc,
    required this.price,
    this.selectedSize = 'M',
    this.selectedColor = 'Red',
    this.isFavorite = false,
    this.quantity = 1,  // Установлено значение по умолчанию
  });

  Shoe copyWith({
    String? id,
    String? name,
    String? image,
    String? desc,
    double? price,
    String? selectedSize,
    String? selectedColor,
    bool? isFavorite,
    int? quantity,  // Добавлено в метод copyWith
  }) {
    return Shoe(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      desc: desc ?? this.desc,
      price: price ?? this.price,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
      isFavorite: isFavorite ?? this.isFavorite,
      quantity: quantity ?? this.quantity,  // Присваиваем значение quantity
    );
  }
}
