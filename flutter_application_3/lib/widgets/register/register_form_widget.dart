import 'package:flutter/material.dart';
import 'package:flutter_application_3/state/register_provider.dart';
import 'package:flutter_application_3/widgets/register/input_field_widget.dart';
import 'package:provider/provider.dart';

class RegisterFormWidget extends StatelessWidget {
  const RegisterFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterViewModel>(
      builder: (context, viewModel, child) {
        final _formKey = GlobalKey<FormState>();

        return Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    buildInputField(
                      label: 'Емейл',
                      onSave: (value) {
                        viewModel.email = value;
                        print("Saved value for email: $value");
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Введіть емейл';
                        if (!viewModel.isValidEmail(value)) return 'Невірний формат емейлу';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    buildInputField(
                      label: 'Ім\'я',
                      onSave: (value) {
                        viewModel.username = value;
                        print("Saved value for username: $value");
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Введіть ім\'я';
                        if (!viewModel.isValidUsername(value)) return 'Ім\'я не може містити цифр';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    buildInputField(
                      label: 'Пароль',
                      isPassword: true,
                      onSave: (value) {
                        viewModel.password = value;
                        print("Saved value for password: $value");
                      },
                      validator: (value) => value == null || value.isEmpty ? 'Введіть пароль' : null,
                    ),
                    const SizedBox(height: 16),
                    buildInputField(
                      label: 'На якому авто ви їздите?',
                      onSave: (value) {
                        viewModel.carModel = value;
                        print("Saved value for car model: $value");
                      },
                      validator: (value) => value == null || value.isEmpty ? 'Введіть марку авто' : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: viewModel.isSubmitting
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                print("Form is being submitted");
                                try {
                                  await viewModel.register();
                                  Navigator.pushReplacementNamed(context, '/home');
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: viewModel.isSubmitting
                          ? const CircularProgressIndicator()
                          : const Text('Зареєструватися', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
