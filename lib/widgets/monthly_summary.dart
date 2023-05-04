import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:habit_tracker/data/date_time.dart';

class MonthlySummary extends StatelessWidget {
  final Map<DateTime, int>? datasets;
  final String startDate;

  const MonthlySummary({
    super.key,
    required this.datasets,
    required this.startDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 25, bottom: 25),
      child: HeatMapCalendar(
        datasets: datasets,
        colorMode: ColorMode.color,
        defaultColor: Colors.grey[400],
        textColor: Colors.white,
        size: 35,
        colorsets: const {
          1: Color.fromARGB(20, 190, 3, 252),
          2: Color.fromARGB(40, 190, 3, 252),
          3: Color.fromARGB(60, 190, 3, 252),
          4: Color.fromARGB(80, 190, 3, 252),
          5: Color.fromARGB(100, 190, 3, 252),
          6: Color.fromARGB(120, 190, 3, 252),
          7: Color.fromARGB(150, 190, 3, 252),
          8: Color.fromARGB(180, 190, 3, 252),
          9: Color.fromARGB(220, 190, 3, 252),
          10: Color.fromARGB(255, 190, 3, 252),
        },
        onClick: (value) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.toString())));
        },
      ),
    );
  }
}
