import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_app/app/modules/Aunt/controllers/login_controller.dart';
import 'package:hotel_app/app/modules/Aunt/views/register_view.dart';
import 'package:hotel_app/app/data/connections/controllers/connectivity_controller.dart';
import 'package:hotel_app/app/modules/components/custom/appBar.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final LoginController loginController = Get.put(LoginController());
  final ConnectivityController connectivityController = Get.find();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90.0),
        child: Hero(
          tag: 'appBarHero',
          child: ClipPath(
            clipper: CustomAppBarClipper(),
            child: Container(
              color: Theme.of(context).primaryColor,
              child: AppBar(
                title: Text(
                  'Login',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pesan peringatan jika offline
              Obx(
                () => connectivityController.isOffline.value
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        color: Colors.redAccent,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.signal_wifi_off, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'No internet connection.',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 20),
              Text(
                "Welcome Back!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Login to your account to continue",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              // Email TextField
              Container(
                width: double.infinity, // Menyesuaikan dengan lebar layar
                child: TextField(
                  controller: loginController.emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(
                      Icons.email,
                      color: theme.primaryColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 20),
              // Password TextField
              Container(
                width: double.infinity, // Menyesuaikan dengan lebar layar
                child: Obx(
                  () => TextField(
                    controller: loginController.passwordController,
                    obscureText: loginController.obscureText.value,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(
                        Icons.lock,
                        color: theme.primaryColor,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          loginController.obscureText.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: theme.primaryColor,
                        ),
                        onPressed: () {
                          loginController.obscureText.value =
                              !loginController.obscureText.value;
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Login Button
              Obx(
                () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: connectivityController.isOffline.value
                      ? null // Nonaktifkan tombol jika offline
                      : loginController.login, // Jika online, bisa login
                  child: Text(
                    'Login',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.off(
                        () => RegisterView(),
                        transition: Transition.fadeIn,
                        duration: const Duration(milliseconds: 400),
                      );
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
