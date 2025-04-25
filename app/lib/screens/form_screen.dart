import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../services/card_service.dart';

class FormScreen extends StatefulWidget {
  final CardModel? existingCard;

  const FormScreen({Key? key, this.existingCard}) : super(key: key);

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late Color _selectedColor;
  late DateTime _createdAt;
  late DateTime _updatedAt;

  @override
  void initState() {
    super.initState();
    // Initialize values for an existing card if provided
    if (widget.existingCard != null) {
      _titleController = TextEditingController(text: widget.existingCard!.title);
      _descriptionController = TextEditingController(text: widget.existingCard!.description);
      _selectedColor = Color(widget.existingCard!.color);
      _createdAt = widget.existingCard!.createdAt;
      _updatedAt = widget.existingCard!.updatedAt;
    } else {
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
      _selectedColor = Colors.blue;
      _createdAt = DateTime.now();
      _updatedAt = DateTime.now();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Function to save the card, either creating a new one or updating an existing one
  void _saveCard() async {
    if (_formKey.currentState!.validate()) {
      CardModel newCard = CardModel(
        id: widget.existingCard?.id ?? '',
        title: _titleController.text,
        description: _descriptionController.text,
        color: _selectedColor.value,
        createdAt: _createdAt,
        updatedAt: _updatedAt,
      );

      if (widget.existingCard == null) {
        newCard = await CardService.createCard(newCard); // Create new card
      } else {
        await CardService.updateCard(newCard); // Update existing card
      }

      Navigator.pop(context, newCard); // Return saved card
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingCard == null ? 'Create Card' : 'Edit Card'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Text field for the title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a title' : null,
              ),
              // Text field for the description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 20),
              const Text('Select Card Color:'),
              // Color picker
              ColorPicker(
                selectedColor: _selectedColor,
                onColorSelected: (color) => setState(() {
                  _selectedColor = color;
                }),
              ),
              const SizedBox(height: 20),
              // Button to save or create the card
              ElevatedButton(
                onPressed: _saveCard,
                child: Text(widget.existingCard == null ? 'Create Card' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget for color selection
class ColorPicker extends StatelessWidget {
  final Color selectedColor;
  final Function(Color) onColorSelected;

  const ColorPicker({
    Key? key,
    required this.selectedColor,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        final color = _getColorByIndex(index);
        return GestureDetector(
          onTap: () => onColorSelected(color),
          child: Container(
            color: color,
            child: selectedColor.value == color.value
                ? const Icon(Icons.check, color: Colors.white) // Mark selected color
                : null,
          ),
        );
      },
    );
  }

  // Return a color based on the index
  Color _getColorByIndex(int index) {
    switch (index) {
      case 0: return Colors.red;
      case 1: return Colors.green;
      case 2: return Colors.blue;
      case 3: return Colors.yellow;
      case 4: return Colors.orange;
      case 5: return Colors.purple;
      case 6: return Colors.cyan;
      case 7: return Colors.brown;
      case 8: return Colors.pink;
      case 9: return Colors.grey;
      default: return Colors.white;
    }
  }
}
