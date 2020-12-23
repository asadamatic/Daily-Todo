import 'package:dailytodo/DataModel/TaskData.dart';
import 'package:dailytodo/LocalDatabase/LocalDatabase.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditingDialog extends StatefulWidget {

  final TaskData taskData;
  EditingDialog({this.taskData});

  @override
  _EditingDialogState createState() => _EditingDialogState();
}

class _EditingDialogState extends State<EditingDialog> {

  //Task editing controller
  TextEditingController taskController = TextEditingController();

  void edit() async{

    widget.taskData.title = taskController.text;
    await Provider.of<LocalDatabase>(context, listen: false).update(widget.taskData);
    Navigator.of(context).pop();
  }
  void add() async{

    TaskData newTaskData = TaskData(title: taskController.text, date: DateFormat('d/M/y').format(Provider.of<ValueNotifier<DateTime>>(context, listen: false).value), status: false);
    await Provider.of<LocalDatabase>(context, listen: false).insertData(newTaskData);
    Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {
    taskController.text = widget.taskData == null ? '' : widget.taskData.title;
    return AlertDialog(
      title: Text(widget.taskData == null ? 'New Task' : 'Edit Task', style: TextStyle(color: Colors.blue[400]),),
      content: TextField(
        controller: taskController,
        autofocus: true,
        cursorColor: Colors.blue[400],
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue[400],
            ),
          ),
          focusColor: Colors.blue[400],
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue[400],
            )
          ),
          hintText: 'Task Name',
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel', style: TextStyle(color: Colors.grey),),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(widget.taskData == null ? 'Add' : 'Update', style: TextStyle(color: Colors.blue[400]),),
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
