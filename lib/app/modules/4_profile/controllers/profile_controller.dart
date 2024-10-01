import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  var imagePath = ''.obs;
  File? imageFile;

  
  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imagePath.value = pickedFile.path;
      imageFile = File(pickedFile.path);
    }
  }

  void removeImage() {
    imagePath.value = '';
    imageFile = null;
  }
}