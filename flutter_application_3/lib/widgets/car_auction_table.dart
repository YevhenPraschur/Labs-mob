import 'package:flutter/material.dart';

class CarAuctionTable extends StatelessWidget {
  final List<Map<String, dynamic>> cars;

  const CarAuctionTable({super.key, required this.cars});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Table(
        border: TableBorder.all(color: Colors.transparent),
        children: [
          _headerRow(),
          ...cars.map((car) => _carAuctionRow(
                (car['make'] ?? 'Невідомо').toString(),
                (car['model'] ?? 'Невідомо').toString(),
                car['year']?.toString() ?? 'Невідомо',
                car['price']?.toString() ?? 'Невідомо',
                (car['fuelType'] ?? 'Невідомо').toString(),
              ),),
        ],
      ),
    );
  }

  TableRow _headerRow() {
    return TableRow(
      children: [
        _tableCell('Name', isHeader: true),
        _tableCell('Model', isHeader: true),
        _tableCell('Year', isHeader: true),
        _tableCell('Price', isHeader: true),
        _tableCell('Fuel Type', isHeader: true),
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

  Widget _tableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: isHeader ? Colors.black : Colors.grey[800],
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
