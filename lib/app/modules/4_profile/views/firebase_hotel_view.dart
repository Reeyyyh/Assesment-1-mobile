import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHotelView extends StatelessWidget {
  final TextEditingController imageController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();

  void saveHotelData(BuildContext context) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('datahotel').doc();
      await docRef.set({
        'id': docRef.id,
        'image': imageController.text,
        'longitude': double.tryParse(longitudeController.text) ?? 0.0,
        'latitude': double.tryParse(latitudeController.text) ?? 0.0,
        'description': descriptionController.text,
        'location': locationController.text,
        'name': nameController.text,
        'price': priceController.text,
        'rating': double.tryParse(ratingController.text) ?? 0.0,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hotel data saved successfully!')),
      );

      // Clear input fields after saving
      imageController.clear();
      longitudeController.clear();
      latitudeController.clear();
      descriptionController.clear();
      locationController.clear();
      nameController.clear();
      priceController.clear();
      ratingController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Hotel Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField('Image URL', imageController),
              buildTextField('Longitude', longitudeController, isNumber: true),
              buildTextField('Latitude', latitudeController, isNumber: true),
              buildTextField('Description', descriptionController),
              buildTextField('Location', locationController),
              buildTextField('Name', nameController),
              buildTextField('Price', priceController),
              buildTextField('Rating', ratingController, isNumber: true),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => saveHotelData(context),
                  child: const Text('Save Hotel Data'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
