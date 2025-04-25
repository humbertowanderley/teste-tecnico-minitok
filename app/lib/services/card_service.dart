import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../models/card_model.dart';

class CardService {
  // Fetch all cards, ordered by creation date (most recent first)
  static Future<List<CardModel>> getCards() async {
    final query = QueryBuilder(ParseObject('Card'))..orderByDescending('createdAt');
    final response = await query.query();

    if (response.success && response.results != null) {
      return response.results!.map((e) {
        final obj = e as ParseObject;
        return CardModel(
          id: obj.objectId!,
          title: obj.get<String>('title') ?? '',
          description: obj.get<String>('description') ?? '',
          color: obj.get<int>('color') ?? 0xFF000000,
          createdAt: obj.get<DateTime>('createdAt')!,
          updatedAt: obj.get<DateTime>('updatedAt')!,
        );
      }).toList();
    } else {
      return [];
    }
  }

  // Create a new card on the Parse server
  static Future<CardModel> createCard(CardModel card) async {
    final obj = ParseObject('Card')
      ..set<String>('title', card.title)
      ..set<String>('description', card.description)
      ..set<int>('color', card.color)
      ..set<DateTime>('createdAt', card.createdAt)
      ..set<DateTime>('updatedAt', card.updatedAt);

    final response = await obj.save();

    if (response.success && response.result != null) {
      return CardModel(
        id: response.result?.objectId,
        title: card.title,
        description: card.description,
        color: card.color,
        createdAt: card.createdAt,
        updatedAt: DateTime.now(),
      );
    } else {
      throw Exception('Failed to create card: ${response.error!.message}');
    }
  }

  // Update an existing card on the Parse server
  static Future<void> updateCard(CardModel card) async {
    if (card.id.isEmpty) {
      print('Error: Card has no objectId. Cannot update.');
      return;
    }

    final obj = ParseObject('Card')..objectId = card.id;
    obj.set<String>('title', card.title);
    obj.set<String>('description', card.description);
    obj.set<int>('color', card.color);
    obj.set<DateTime>('updatedAt', card.updatedAt);

    final response = await obj.save();

    if (response.success) {
      print('Card updated successfully.');
    } else {
      print('Failed to update card: ${response.error!.message}');
    }
  }

  // Delete a card by ID
  static Future<bool> deleteCard(String id) async {
    final obj = ParseObject('Card')..objectId = id;
    final response = await obj.delete();

    if (response.success) {
      return true;
    } else {
      print('Failed to delete card: ${response.error?.message}');
      return false;
    }
  }
}
