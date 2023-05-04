import 'package:hive_flutter/hive_flutter.dart';

import 'date_time.dart';

var hive = Hive.box("HABITS");

class DataBase {
  List todaysList = [];
  Map<DateTime, int> heatMapDataSet = {};
  void updateDb() {
    hive.put(todaysDateFormatted(), todaysList);
    hive.put('HABIT_LIST', todaysList);
    calculateHabitPercentages();
    loadHeatMap();
  }

  void initialLoad() {
    todaysList = [
      ["Add a New Habit", false]
    ];
    hive.put("START_DATE", todaysDateFormatted());
  }

  void refresh() {
    todaysList = [];
  }

  void loadDb() {
    if (hive.get(todaysDateFormatted()) == null) {
      todaysList = hive.get('HABIT_LIST');
      for (int i = 0; i < todaysList.length; i++) {
        todaysList[i][1] = false;
      }
    } else {
      todaysList = hive.get(todaysDateFormatted());
      print(hive.get(todaysDateFormatted()));
      
    }
  }

  void calculateHabitPercentages() {
    int countCompleted = 0;
    for (int i = 0; i < todaysList.length; i++) {
      if (todaysList[i][1] == true) {
        countCompleted++;
      }
    }

    String percent = todaysList.isEmpty ? '0.0' : (countCompleted / todaysList.length).toStringAsFixed(1);

    hive.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percent);
    print("percentage");
    print(hive.get("PERCENTAGE_SUMMARY_${todaysDateFormatted()}"));
  }

  void loadHeatMap() {
    DateTime startDate = DateTime(2023,5,2);

    int daysInBetween = DateTime.now().difference(startDate).inDays;

    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );

      double strengthAsPercent = double.parse(
        hive.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
      );

      int year = startDate.add(Duration(days: i)).year;

      int month = startDate.add(Duration(days: i)).month;

      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
      print(heatMapDataSet);
    }
  }
}
