import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/card_model.dart';
import '../services/card_service.dart';
import 'form_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<CardModel> _cards = [];

  @override
  void initState() {
    super.initState();
    _loadCards(); // Load cards from backend on widget initialization
  }

  // Fetch cards from the backend and update local list
  Future<void> _loadCards() async {
    final cards = await CardService.getCards();
    setState(() {
      _cards.clear();
      _cards.addAll(cards);
    });
  }

  // Delete a card both from backend and local list
  Future<void> _deleteCard(CardModel card) async {
    final success = await CardService.deleteCard(card.id);
    if (success) {
      setState(() {
        _cards.remove(card);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Card deleted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete card')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // App background color
      appBar: AppBar(
        title: const Text(
          'Cards',
          style: TextStyle(color: Colors.white), // Title color for dark background
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCards, // Manual refresh button
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadCards, // Pull-to-refresh functionality
        child: ListView.builder(
          itemCount: _cards.length,
          itemBuilder: (context, index) {
            final card = _cards[index];
            final createdAtFormatted =
                DateFormat('dd/MM/yyyy • HH:mm').format(card.createdAt);
            final updatedAtFormatted =
                DateFormat('dd/MM/yyyy • HH:mm').format(card.updatedAt);

            return Card(
              margin: const EdgeInsets.all(8),
              color: Color(card.color), // Card background color from model
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        card.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Text color for contrast
                        ),
                      ),
                      subtitle: Text(
                        card.description,
                        style: const TextStyle(color: Colors.black87),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Edit button
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.black87),
                            onPressed: () async {
                              final updatedCard = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FormScreen(existingCard: card),
                                ),
                              );
                              if (updatedCard != null) {
                                setState(() {
                                  _cards[index] = updatedCard;
                                });
                              }
                            },
                          ),
                          // Delete button
                          IconButton(
                            icon: const Icon(Icons.delete_rounded, color: Colors.black87),
                            onPressed: () => _deleteCard(card),
                            iconSize: 28,
                            padding: const EdgeInsets.all(6),
                            constraints: const BoxConstraints(),
                            tooltip: 'Delete card',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Metadata: creation and update timestamps
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Created: $createdAtFormatted',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          'Updated: $updatedAtFormatted',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newCard = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormScreen()),
          );
          if (newCard != null) {
            setState(() {
              _cards.add(newCard); // Add new card to list on return
            });
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
        elevation: 5.0,
        tooltip: 'Add card',
      ),
    );
  }
}
