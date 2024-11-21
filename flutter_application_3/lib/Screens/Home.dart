import 'package:flutter/material.dart';
import 'package:flutter_application_3/repos/local_repos.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocalUserRepository _userRepository = LocalUserRepository();
  String _email = 'Не вказано', _username = 'Не вказано', _carModel = 'Не вказано';

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  // Loads user details from the local repository
  Future<void> _loadUserDetails() async {
    final userDetails = await _userRepository.getUserDetails();
    setState(() {
      _email = userDetails['email'] ?? 'Не вказано';
      _username = userDetails['username'] ?? 'Не вказано';
      _carModel = userDetails['carModel'] ?? 'Не вказано';
    });
  }

  // Navigate to another screen
  void _navigate(String route) => Navigator.pushNamed(context, route);

  // Logs out the user, navigating to the login page
  void _logout() async {
    // Do not delete any user data, just redirect to the login page
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Домашня сторінка'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: () => _navigate('/profile')),
          IconButton(icon: const Icon(Icons.exit_to_app), onPressed: _logout), // Logout button with no account deletion
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
          alignment: Alignment.center,
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
            _carAuctionTable(),
          ],
        ),
      ),
    );
  }

  // General table cell widget
  Widget _tableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(text, style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500)),
    );
  }

  // Table for user account information
  Widget _accountInfoTable() {
    return _infoTable([
      _tableRow('Емейл', _email),
      _tableRow('Ім\'я', _username),
      _tableRow('Ваш автомобіль', _carModel),
    ]);
  }

  // Table for car auction information
  Widget _carAuctionTable() {
    return _infoTable([
      _headerRow(),
      _carAuctionRow('BMW', 'G20', '\$9,000'),
      _carAuctionRow('BMW', 'G30', '\$6,700'),
      _carAuctionRow('BMW', 'F25', '\$4,200'),
      _carAuctionRow('BMW', 'F15', '\$5,300'),
      _carAuctionRow('BMW', 'F30', '\$2,300'),
    ]);
  }

  // General method to create a table with rows
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

  // Table row for user account information
  TableRow _tableRow(String label, String value) {
    return TableRow(
      children: [_tableCell(label), _tableCell(value)],
    );
  }

  // Header row for car auction
  TableRow _headerRow() {
    return TableRow(
      children: [
        _tableCell('Авто'),
        _tableCell('Серія'),
        _tableCell('Вартість'),
      ],
    );
  }

  // Table row for each car auction item
  TableRow _carAuctionRow(String car, String series, String price) {
    return TableRow(
      children: [
        _tableCell(car),
        _tableCell(series),
        _tableCell(price),
      ],
    );
  }
}
