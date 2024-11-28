import 'package:flutter/material.dart';
import 'package:flutter_application_3/state/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_3/widgets/profile/profile_form.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редагування профілю'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<UserProfileProvider>(
        builder: (context, userProfileProvider, child) {
          // Завантаження email
          if (userProfileProvider.userEmail == null) {
            userProfileProvider.loadUserEmail();
            return const Center(child: CircularProgressIndicator());
          }

          return ProfileForm(
            formKey: GlobalKey<FormState>(),
            userEmail: userProfileProvider.userEmail!,
            onEmailSaved: (value) => userProfileProvider.setNewEmail(value),
            onUsernameSaved: (value) => userProfileProvider.setNewUsername(value),
            onPasswordSaved: (value) => userProfileProvider.setNewPassword(value),
            emailValidator: (value) => userProfileProvider.isValidEmail(value ?? ""),
            usernameValidator: (value) => userProfileProvider.isValidUsername(value ?? ""),
            passwordValidator: (value) =>
                value == null || value.isEmpty ? 'Введіть пароль' : null,
            onSubmit: () {
              if (userProfileProvider.isFormValid()) {
                userProfileProvider.updateProfile();
                Navigator.pushReplacementNamed(context, '/home');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Будь ласка, заповніть всі поля правильно!')),
                );
              }
            },
          );
        },
      ),
    );
  }
}
