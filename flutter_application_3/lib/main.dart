import 'package:flutter/material.dart';
import 'package:flutter_application_3/repos/local_repos.dart';
import 'package:flutter_application_3/screens/Home.dart';
import 'package:flutter_application_3/screens/Login.dart';
import 'package:flutter_application_3/screens/Reg.dart';
import 'package:flutter_application_3/screens/Profile.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_3/state/home_provider.dart';
import 'package:flutter_application_3/state/loginprovider.dart';
import 'package:flutter_application_3/state/profile_provider.dart';
import 'package:flutter_application_3/state/register_provider.dart'; // Import your RegisterViewModel

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final LocalUserRepository userRepository = LocalUserRepository();
  final bool isLoggedIn = await userRepository.isUserLoggedIn();

  runApp(MyApp(isLoggedIn: isLoggedIn, userRepository: userRepository));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final LocalUserRepository userRepository;

  const MyApp({required this.isLoggedIn, required this.userRepository, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider(userRepository: userRepository, isLoggedIn: isLoggedIn)),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
      ],
      child: MaterialApp(
        title: 'Flutter App',
        initialRoute: isLoggedIn ? '/home' : '/login',
        routes: {
          '/login': (_) => const LoginPage(),
          '/home': (_) => const HomePage(),
          '/register': (_) => const RegisterPage(),
          '/profile': (_) => const ProfilePage(),
        },
      ),
    );
  }
}
