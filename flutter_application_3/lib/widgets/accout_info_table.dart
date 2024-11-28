import 'package:flutter/material.dart';

class AccountInfoTable extends StatelessWidget {
  final String email;
  final String username;
  final String carModel;

  const AccountInfoTable({
    super.key,
    required this.email,
    required this.username,
    required this.carModel,
  });

  @override
  Widget build(BuildContext context) {
    return _infoTable([
      _tableRow('Емейл', email),
      _tableRow('Ім\'я', username),
      _tableRow('Ваш автомобіль', carModel),
    ]);
  }

  Widget _infoTable(List<TableRow> rows) {
    return Container(
      width: 450,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Table(
        border: TableBorder.all(color: Colors.transparent),
        children: rows,
      ),
    );
  }

  TableRow _tableRow(String label, String value) {
    return TableRow(
      children: [
        _tableCell(label),
        _tableCell(value),
      ],
    );
  }

  Widget _tableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }
}
