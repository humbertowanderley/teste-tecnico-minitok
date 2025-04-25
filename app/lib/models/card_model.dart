class CardModel {
  final String id;
  final String title;
  final String description;
  final int color;
  final DateTime createdAt;
  final DateTime updatedAt;

  CardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
  });
}
