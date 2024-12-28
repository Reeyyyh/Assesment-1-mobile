import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_app/app/modules/1_home/controllers/home_controller.dart';

class FilterDialog extends StatelessWidget {
  final HomeController controller;
  const FilterDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Hotels'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Hanya dropdown untuk Price
          Obx(() {
            return ListTile(
              title: const Text('By Price'),
              trailing: DropdownButton<int>(
                value: controller.selectedPrice.value,
                onChanged: (value) {
                  controller.selectedPrice.value = value!;
                  controller.filterHotelsByPrice(value);
                  Navigator.of(context).pop(); // Tutup dialog setelah memilih
                },
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Low to High')),
                  DropdownMenuItem(value: 2, child: Text('High to Low')),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
