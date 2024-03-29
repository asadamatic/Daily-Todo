import 'package:dailytodo/data_model/day_performance.dart';
import 'package:dailytodo/data_model/task_data.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  LocalDatabase();

  static const databaseName = 'funnel.db';
  static Database? _database;

  Future<Database?> get database async {
    if (_database == null) {
      return await initializeDB();
    } else {
      return _database;
    }
  }

  initializeDB() async {
    return await openDatabase(join(await getDatabasesPath(), databaseName),
        version: 1, onCreate: (db, version) async {
      return await db.execute(
          'CREATE TABLE checklist(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, status INTEGER, date TEXT)');
    });
  }

  bool getStatus(int status) {
    return status == 1 ? true : false;
  }

  TaskData returnTaskData(Map<String, dynamic> map) {
    return TaskData(
      id: map['id'],
      title: map['title'],
      status: getStatus(map['status']),
      date: map['date'],
    );
  }

  Future<List<TaskData>> returnTasks(DateTime selectedDate) async {
    final Database? db = await database;
    final List<Map<String, dynamic>> list = await db!.query('checklist',
        where: 'date = "${DateFormat('d/M/y').format(selectedDate)}"');
    return list.map(returnTaskData).toList();
  }

  Future<int> insertData(TaskData taskData) async {
    final Database? db = await database;
    return await db!.insert('checklist', taskData.toMap());
  }

  Future<void> update(TaskData taskData) async {
    final Database? db = await database;
    await db!.update('checklist', taskData.toMap(),
        where: 'id = ?', whereArgs: [taskData.id]);
  }

  Future<void> delete(TaskData taskData) async {
    final Database? db = await database;
    await db!.delete('checklist', where: 'id = ?', whereArgs: [taskData.id]);
  }

  List _daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

  bool isLeapYear(int year) =>
      (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));

  int daysInMonth(int year, int month) =>
      (month == DateTime.february && isLeapYear(year))
          ? 29
          : _daysInMonth[month - 1];

  Future<List<DayPerformance>> getDataForGraph(DateTime selectedDate) async {
    List<DayPerformance> data = [];
    String month = DateFormat('M/y').format(selectedDate);

    Database? db = await database;

    for (int index = 1;
        index <= daysInMonth(selectedDate.year, selectedDate.month);
        index++) {
      int? total = Sqflite.firstIntValue(await db!.rawQuery(
          "SELECT COUNT(*) FROM checklist WHERE date LIKE '$index/$month' "));
      int? done = Sqflite.firstIntValue(await db.rawQuery(
          "SELECT SUM(checklist.status) FROM checklist WHERE date LIKE '$index/$month' "));

      data.add(DayPerformance(
        day: index,
        total: total,
        done: done,
      ));
    }

    return data;
  }
}
