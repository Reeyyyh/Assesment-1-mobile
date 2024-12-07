import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_app/app/modules/Aunt/controllers/register_controller.dart';
import 'package:hotel_app/app/modules/Aunt/views/login_view.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  final RegisterController registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Ambil tema aktif

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Sesuaikan dengan tema
      appBar: AppBar(
        backgroundColor: theme.primaryColor, // Sesuaikan dengan tema
        title: Text(
          'Register',
          style: theme.appBarTheme.titleTextStyle, // Sesuaikan dengan tema
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Create Account",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor, // Sesuaikan dengan tema
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Register to continue",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: registerController.nameController,
              decoration: InputDecoration(
                labelText: 'Nama',
                prefixIcon: Icon(Icons.person, color: theme.primaryColor), // Sesuaikan dengan tema
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: registerController.emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email, color: theme.primaryColor), // Sesuaikan dengan tema
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Obx(() => TextField(
              controller: registerController.passwordController,
              obscureText: !registerController.isPasswordVisible.value,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock, color: theme.primaryColor), // Sesuaikan dengan tema
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    registerController.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                    color: theme.primaryColor, // Sesuaikan dengan tema
                  ),
                  onPressed: () {
                    registerController.togglePasswordVisibility();
                  },
                ),
              ),
            )),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor, // Sesuaikan dengan tema
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                registerController.register();
              },
              child: Text(
                'Register',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.off(() => LoginView());
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor, // Sesuaikan dengan tema
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
