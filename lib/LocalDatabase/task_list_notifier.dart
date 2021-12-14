import 'package:dailytodo/DataModel/DayPerformance.dart';
import 'package:dailytodo/DataModel/TaskData.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class CheckListNotifier extends ChangeNotifier{

  List<TaskData> tasks = [];

  Future<void> insertData(TaskData taskData) async{
    tasks.add(taskData);
    notifyListeners();
  }

  Future<void> update(TaskData taskData) async{
    tasks[tasks.indexWhere((item) => item.id == taskData.id)] = taskData;
    notifyListeners();
  }

  Future<void> delete(TaskData taskData) async{
    tasks.remove(taskData);
    notifyListeners();
  }

  List _daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

  bool isLeapYear(int year) =>
      (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));

  int daysInMonth(int year, int month) =>
      (month == DateTime.february && isLeapYear(year)) ? 29 : _daysInMonth[month-1];

  List<DayPerformance> getDataForGraph(DateTime selectedDate){

    List<DayPerformance> data = [];
    data.add(DayPerformance(day: selectedDate.day , total: tasks.length, done: tasks.where((element) => element.status == true).length,));
    return data;
  }
}