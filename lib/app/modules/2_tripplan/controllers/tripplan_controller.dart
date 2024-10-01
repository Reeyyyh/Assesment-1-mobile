
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class TripplanController extends GetxController{
  var selectedImagePath = ''.obs;
  final ImagePicker picker = ImagePicker();

  Future<void> getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;
    } else {
      Get.snackbar('Error', 'No image selected');
    }
  }

}