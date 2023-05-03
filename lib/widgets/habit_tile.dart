import 'package:flutter/material.dart';

class HabitTile extends StatelessWidget {
  final String name;
  final bool isCompleted;
  final Function(bool?) onChanged;
  const HabitTile({super.key, required this.name, required this.isCompleted, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromARGB(150, 190, 3, 252), borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Checkbox(value: isCompleted, onChanged: onChanged),
            Text(
              name,
              style: isCompleted
                  ? const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.white)
                  : const TextStyle(decoration: TextDecoration.none, color: Colors.white),
            ),
            Expanded(child: Container()),
            Icon(
              Icons.arrow_back,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
