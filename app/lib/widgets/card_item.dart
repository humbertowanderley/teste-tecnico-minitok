import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/card_model.dart';

class CardItem extends StatelessWidget {
  final CardModel card;
  final void Function(String) onDelete;
  final void Function(CardModel) onEdit;

  const CardItem({
    super.key,
    required this.card,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy • HH:mm').format(card.updatedAt);
    final color = Color(card.color);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: color.withAlpha((color.alpha * 0.85).toInt()), // Updated from deprecated withOpacity
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: color.withAlpha((color.alpha * 0.5).toInt()), blurRadius: 6)
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title of the card
                Expanded(
                  child: Text(
                    card.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  children: [
                    // Edit button
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () => onEdit(card),
                    ),
                    // Delete button
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () => onDelete(card.id),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Description of the card
            Text(
              card.description,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            // Display the formatted date
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                formattedDate,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
