import 'package:flutter/material.dart';
import 'package:flutter_application_3/widgets/profile/input_field.dart'; // Import the InputField widget

class ProfileForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String? userEmail;
  final void Function(String?) onEmailSaved;
  final void Function(String?) onUsernameSaved;
  final void Function(String?) onPasswordSaved;
  final String? Function(String?) emailValidator;
  final String? Function(String?) usernameValidator;
  final String? Function(String?) passwordValidator;
  final void Function()? onSubmit;

  const ProfileForm({
    super.key,
    required this.formKey,
    required this.userEmail,
    required this.onEmailSaved,
    required this.onUsernameSaved,
    required this.onPasswordSaved,
    required this.emailValidator,
    required this.usernameValidator,
    required this.passwordValidator,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/fon1.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Емейл: $userEmail', 
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                    ),
                    const SizedBox(height: 20),
                    InputField(
                      label: 'Новий емейл',
                      initialValue: userEmail,
                      onSave: onEmailSaved,
                      validator: emailValidator,
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      label: 'Нове ім\'я',
                      onSave: onUsernameSaved,
                      validator: usernameValidator,
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      label: 'Новий пароль',
                      isPassword: true,
                      onSave: onPasswordSaved,
                      validator: passwordValidator,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Validate the form and call onSubmit
                        if (formKey.currentState?.validate() ?? false) {
                          // If the form is valid, call onSubmit
                          onSubmit?.call();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text('Зберегти зміни'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
