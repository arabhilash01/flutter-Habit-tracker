import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habit_tracker/data/database.dart';
import 'package:habit_tracker/data/date_time.dart';
import 'package:habit_tracker/widgets/habit_tile.dart';
import 'package:habit_tracker/widgets/monthly_summary.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  final _editcontroller = TextEditingController();
  @override
  void initState() {
    if (hive.get('HABIT_LIST') == null) {
      db.initialLoad();
    } else {
      db.loadDb();
      print(hive.get(todaysDateFormatted()));
    }
    db.updateDb();
    super.initState();
  }

  var db = DataBase();
  onChanged(bool value, int index) {
    setState(() {
      db.todaysList[index][1] = !value;
      db.updateDb();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(40, 190, 3, 252),
        child: Column(
          children: [
            MonthlySummary(datasets: db.heatMapDataSet, startDate: hive.get("START_DATE")),
            Expanded(
              child: ListView.builder(
                itemCount: db.todaysList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Slidable(
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        SlidableAction(
                          borderRadius: BorderRadius.circular(20),
                          onPressed: (context) {
                            editGoal(context, index);
                          },
                          backgroundColor: Color.fromARGB(80, 190, 3, 252),
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SlidableAction(
                          borderRadius: BorderRadius.circular(20),
                          onPressed: (context) {
                            setState(() {
                              db.todaysList.removeAt(index);
                              db.updateDb();
                            });
                          },
                          backgroundColor: Color.fromARGB(80, 190, 3, 252),
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: HabitTile(
                      name: db.todaysList[index][0],
                      isCompleted: db.todaysList[index][1],
                      onChanged: (value) => onChanged(db.todaysList[index][1], index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Goals'),
          content: alertContent,
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  db.todaysList.add([_controller.text, false]);
                  db.updateDb();
                  Navigator.of(context).pop();
                  _controller.clear();
                });
              },
            ),
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void editGoal(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Goals'),
          content: TextField(
            controller: _editcontroller,
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              hintText: db.todaysList[index][0],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  db.todaysList[index][0] = _editcontroller.text;
                  db.updateDb();
                  Navigator.of(context).pop();
                  _editcontroller.clear();
                });
              },
            ),
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget get alertContent {
    return Container(
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white))),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement
    _controller.dispose();
    _editcontroller.dispose();
    // _dispose
    super.dispose();
  }
}
