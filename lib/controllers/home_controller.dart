import 'package:dailytodo/data_model/day_performance.dart';
import 'package:dailytodo/data_model/task_data.dart';
import 'package:dailytodo/local_database/local_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  DateTime pickedDate = DateTime.now();
  ScrollController scrollController = ScrollController();
  List<TaskData> tasks = [];
  Brightness brightness = SchedulerBinding.instance!.window.platformBrightness;
  ThemeMode themeMode = ThemeMode.system;
  LocalDatabase _localDatabase = LocalDatabase();
  RxList<DayPerformance> dayPerformance = <DayPerformance>[].obs;
  @override
  void onInit() async {
    print("Initializing");
    tasks = await _localDatabase.returnTasks(pickedDate);
    await updateDataForGraph();
    themeMode =
        brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;

    update();
    super.onInit();
  }

  selectDate() async {
    pickedDate = await Get.dialog(DatePickerDialog(
            firstDate: DateTime(2000, 1, 1),
            lastDate: DateTime(2030, 1, 1),
            initialDate: pickedDate)) ??
        pickedDate;
    tasks = await _localDatabase.returnTasks(pickedDate);
    update();
  }

  toggleTheme(bool value) {
    if (value) {
      themeMode = ThemeMode.dark;
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      themeMode = ThemeMode.light;
      Get.changeThemeMode(ThemeMode.light);
    }
    update();
  }

  addTask(TaskData taskData) async {
    print("Add");
    await _localDatabase.insertData(taskData);
    tasks.add(taskData);
    await updateDataForGraph();
    update();
  }

  editTask(TaskData taskData) async {
    print("Edit");
    await _localDatabase.update(taskData);
    tasks[tasks.indexWhere((item) => item.id == taskData.id)] = taskData;
    await updateDataForGraph();
    update();
  }

  deleteTask(TaskData taskData) async {
    print("Delete");
    await _localDatabase.delete(taskData);
    tasks.remove(taskData);
    await updateDataForGraph();
    update();
  }

  updateDataForGraph() async {
    dayPerformance.value = await _localDatabase.getDataForGraph(pickedDate);
  }
}
