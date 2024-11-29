import 'package:flutter/material.dart';
import 'package:flutter_application_3/widgets/register/register_form_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_3/state/register_provider.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegisterViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Реєстрація'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Stack(
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
            const Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: RegisterFormWidget(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
