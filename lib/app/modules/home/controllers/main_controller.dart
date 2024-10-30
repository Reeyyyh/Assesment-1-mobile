import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MainController extends GetxController {
  var selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _setupFirebaseMessaging();
  }

  // print out token
  void _setupFirebaseMessaging() {
    FirebaseMessaging.instance.getToken().then((String? token) {
      print("FCM Token: $token");
    });

    // Mendengarkan pesan saat aplikasi dalam keadaan foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message in the foreground: ${message.notification?.title}');

      if (message.notification != null) {
        Get.snackbar(
          message.notification!.title ?? '',
          message.notification!.body ?? '',
          snackPosition: SnackPosition.TOP,
        );
      }
    });

    // Mendengarkan saat notifikasi dibuka saat aplikasi dalam keadaan background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new message was opened: ${message.messageId}');
    });
  }

  void updateSelectedIndex(int index) {
    selectedIndex.value = index;
  }
}
