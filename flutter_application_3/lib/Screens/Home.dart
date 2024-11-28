import 'package:flutter/material.dart';
import 'package:flutter_application_3/state/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_3/widgets/accout_info_table.dart';
import 'package:flutter_application_3/widgets/car_auction_table.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Завантаження даних користувача при ініціалізації сторінки
    final provider = context.read<HomeProvider>();
    provider.loadUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Домашня сторінка'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.pushNamed(context, '/profile'),),
          IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () => _showLogoutDialog(context),),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              _backgroundImage(constraints),
              _content(provider, constraints),
            ],
          );
        },
      ),
    );
  }

  Widget _backgroundImage(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/fon1.jpg'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _content(HomeProvider provider, BoxConstraints constraints) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Інформація про акаунт',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.yellow[700]),
            ),
            const SizedBox(height: 30),
            AccountInfoTable(
              email: provider.email,
              username: provider.username,
              carModel: provider.carModel,
            ),
            const SizedBox(height: 30),
            if (provider.cars.isNotEmpty) CarAuctionTable(cars: provider.cars),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: provider.fetchCars,
              child: const Text('Зробити запит до API'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Вихід'),
          content: const Text('Ви дійсно хочете вийти?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Ні'),
            ),
            TextButton(
              onPressed: () => context.read<HomeProvider>().logout(context),
              child: const Text('Так'),
            ),
          ],
        );
      },
    );
  }
}
