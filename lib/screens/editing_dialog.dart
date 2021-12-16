import 'package:dailytodo/controllers/home_controller.dart';
import 'package:dailytodo/data_model/task_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditingDialog extends StatefulWidget {
  final TaskData? taskData;
  EditingDialog({this.taskData});

  @override
  _EditingDialogState createState() => _EditingDialogState();
}

class _EditingDialogState extends State<EditingDialog> {
  final TodoHomeController _homeController = Get.find();
  //Task editing controller
  final taskController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(widget.taskData == null ? 'New Task' : 'Edit Task',
                style: TextStyle(fontSize: 18.0)),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: taskController,
                autofocus: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Title is required!";
                  }
                  return null;
                },
                cursorColor: Colors.blue[400],
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Expanded(
                  flex: 4,
                  child: TextButton(
                    child: Text(
                      'Cancel',
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      foregroundColor:
                          _homeController.themeMode == ThemeMode.light ? MaterialStateProperty.all(Colors.blue)
                              :  MaterialStateProperty.all(Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 4,
                  child: TextButton(
                      child: Text(
                        widget.taskData == null ? 'Add' : 'Update',
                      ),
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (widget.taskData == null) {
                            add();
                          } else {
                            edit();
                          }
                        }
                      }),
                ),
                Spacer()
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }
}
