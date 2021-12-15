import 'package:dailytodo/controllers/home_controller.dart';
import 'package:dailytodo/data_model/task_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditingDialog extends StatefulWidget {
  final TaskData? taskData;
  EditingDialog({this.taskData});

  @override
  _EditingDialogState createState() => _EditingDialogState();
}

class _EditingDialogState extends State<EditingDialog> {
  final HomeController _homeController = Get.find();
  //Task editing controller
  TextEditingController taskController = TextEditingController();

  void edit() async {
    widget.taskData!.title = taskController.text;
    _homeController.editTask(widget.taskData!);
    Navigator.of(context).pop();
  }

  void add() async {
    TaskData newTaskData = TaskData(
        title: taskController.text,
        date: DateFormat('d/M/y').format(_homeController.pickedDate),
        status: false);
    await _homeController.addTask(newTaskData);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    taskController.text =
        widget.taskData == null ? '' : widget.taskData!.title!;
    return AlertDialog(
      title: Text(
        widget.taskData == null ? 'New Task' : 'Edit Task',
        style: TextStyle(color: Colors.blue[400]),
      ),
      content: TextField(
        controller: taskController,
        autofocus: true,
        cursorColor: Colors.blue[400],
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue[400]!,
            ),
          ),
          focusColor: Colors.blue[400],
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            color: Colors.blue[400]!,
          )),
          hintText: 'Task Name',
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.grey),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            widget.taskData == null ? 'Add' : 'Update',
            style: TextStyle(color: Colors.blue[400]),
          ),
          onPressed: widget.taskData == null ? add : edit,
        )
      ],
    );
  }

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }
}
