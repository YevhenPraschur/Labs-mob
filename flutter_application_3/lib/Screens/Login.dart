import 'package:flutter/material.dart';
import 'package:flutter_application_3/state/loginprovider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_3/widgets/login/login_input_field.dart';
import 'package:flutter_application_3/widgets/login/login_button.dart';
import 'package:flutter_application_3/widgets/login/register_button.dart';
import 'package:flutter_application_3/widgets/login/auto_login_button.dart';
import 'package:flutter_application_3/widgets/login/snack_bar.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Вхід')),
          body: Stack(
            children: [
              _buildBackgroundImage(),  // Background image placed here
              _buildLoginForm(context, provider),
            ],
          ),
        );
      },
    );
  }

  // This method is responsible for displaying the background image
  Widget _buildBackgroundImage() {
    return Positioned.fill(  // Ensures that the background image takes up the full screen
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fon1.jpg'),  // Ensure the path is correct
            fit: BoxFit.cover,  // This ensures the image covers the whole background
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, LoginProvider provider) {
  return Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: GlobalKey<FormState>(),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              LoginInputField(
                label: 'Емейл',
                controller: provider.emailController,
                validator: (value) => value?.isEmpty == true ? 'Введіть емейл' : null,
              ),
              const SizedBox(height: 16),
              LoginInputField(
                label: 'Пароль',
                controller: provider.passwordController,
                validator: (value) => value?.isEmpty == true ? 'Введіть пароль' : null,
                isPassword: true,
              ),
              const SizedBox(height: 20),
              LoginButton(
                provider: provider,
                onPressed: () async {
                  final email = provider.emailController.text;
                  final password = provider.passwordController.text;
                  final success = await provider.login(email, password);
                  if (success) {
                    Navigator.pushReplacementNamed(context, '/home');
                  } else {
                    showSnackBar(context, 'Невірний емейл або пароль.');
                  }
                },
              ),
              const SizedBox(height: 10),
              RegisterButton(),
              const SizedBox(height: 20),
              AutoLoginButton(provider: provider),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  provider.checkConnectivity(context); // Виклик стану мережі
                },
                child: const Text('Перевірити стан мережі'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}