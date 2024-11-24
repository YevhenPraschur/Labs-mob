import 'package:flutter/material.dart';
import 'package:flutter_application_3/repos/local_repos.dart';
import 'package:http/http.dart' as http; // Додано імпорт для http
import 'dart:convert'; // Для роботи з JSON

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocalUserRepository _userRepository = LocalUserRepository();
  String _email = 'Не вказано', _username = 'Не вказано', _carModel = 'Не вказано';
  List<dynamic> _cars = []; // Змінна для зберігання отриманих даних

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    final userDetails = await _userRepository.getUserDetails();
    setState(() {
      _email = userDetails['email'] ?? 'Не вказано';
      _username = userDetails['username'] ?? 'Не вказано';
      _carModel = userDetails['carModel'] ?? 'Не вказано';
    });
  }

  void _navigate(String route) => Navigator.pushNamed(context, route);

  void _showLogoutDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Вихід'),
          content: const Text('Ви дійсно хочете вийти?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text('Ні'),
            ),
            TextButton(
              onPressed: () async {
                await _userRepository.setUserLoggedIn(false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ви успішно вийшли з акаунта!')),
                );
                Navigator.pushReplacementNamed(context, '/login'); 
              },
              child: const Text('Так'),
            ),
          ],
        );
      },
    );
  }

  // Функція для запиту до API
  Future<void> fetchData() async {
    final url = 'https://www.freetestapi.com/api/v1/cars?limit=3'; // Замість цього поставте ваш API
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Якщо запит успішний
        setState(() {
          final data = json.decode(response.body);
          if (data is List) {
            _cars = data; // Якщо це список
          } else {
            _cars = [];
          }
        });
      } 
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Домашня сторінка'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: () => _navigate('/profile')),
          IconButton(icon: const Icon(Icons.exit_to_app), onPressed: _showLogoutDialog),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              _backgroundImage(constraints),
              _content(constraints),
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

  Widget _content(BoxConstraints constraints) {
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
            _accountInfoTable(),
            const SizedBox(height: 30),
            _cars.isNotEmpty ? _carAuctionTable() : Container(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchData, // Запит до API при натисканні
              child: const Text('Зробити запит до API'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _accountInfoTable() {
    return _infoTable([
      _tableRow('Емейл', _email),
      _tableRow('Ім\'я', _username),
      _tableRow('Ваш автомобіль', _carModel),
    ]);
  }

  Widget _carAuctionTable() {
    return _infoTable([
      _headerRow(),
      ..._cars.map((car) {
        // Safe conversion of dynamic values to String
        return _carAuctionRow(
          (car['make'] ?? 'Невідомо').toString(),
          (car['model'] ?? 'Невідомо').toString(),
          (car['year']?.toString() ?? 'Невідомо'),
          (car['price']?.toString() ?? 'Невідомо'),
          (car['fuelType']?.toString() ?? 'Невідомо'),
        );
      }).toList(),
    ]);
  }

  Widget _infoTable(List<TableRow> rows) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 3, blurRadius: 7, offset: const Offset(0, 3)),
        ],
      ),
      child: Table(
        border: TableBorder.all(color: Colors.transparent),
        children: rows,
      ),
    );
  }

  TableRow _tableRow(String label, String value) {
    return TableRow(
      children: [_tableCell(label), _tableCell(value)],
    );
  }

  TableRow _headerRow() {
    return TableRow(
      children: [
        _tableCell('Name'),
        _tableCell('Model'),
        _tableCell('Year'),
        _tableCell('Price'),
        _tableCell('fuelType'),
      ],
    );
  }

  TableRow _carAuctionRow(String name, String model, String year, String price, String fuelType) {
    return TableRow(
      children: [
        _tableCell(name),
        _tableCell(model),
        _tableCell(year),
        _tableCell(price),
        _tableCell(fuelType),
      ],
    );
  }

  Widget _tableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(text, style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500)),
    );
  }
}
