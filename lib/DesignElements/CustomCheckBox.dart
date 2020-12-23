import 'package:dailytodo/DataModel/TaskData.dart';
import 'package:dailytodo/LocalDatabase/LocalDatabase.dart';
import 'package:dailytodo/Screens/EditingDialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CustomCheckBox extends StatefulWidget {

  final TaskData taskData;
  final Key key;
  CustomCheckBox({this.key, this.taskData,});

  @override
  _CustomCheckBoxState createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {

    return Card(
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
        ),
        elevation: 3.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.5),
        child: CheckboxListTile(
          checkColor: Colors.white,
          activeColor: Colors.blue,
          value: widget.taskData.status,
          onChanged: (newValue) async{
            widget.taskData.status = newValue;
            await Provider.of<LocalDatabase>(context, listen: false).update(widget.taskData);
          },
          controlAffinity: ListTileControlAffinity.leading,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(child: Text('${widget.taskData.title}', style: TextStyle(decoration: widget.taskData.status ? TextDecoration.lineThrough :  TextDecoration.none),)),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  size: 21.0,
                ),
                onPressed: () async{
                  showDialog(context: context,
                  barrierDismissible: false,
                  builder: (context){
                    return EditingDialog(taskData: widget.taskData);
                   }
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  size: 21.0,
                ),
                onPressed: () async{
                  await Provider.of<LocalDatabase>(context, listen: false).delete(widget.taskData);
                },
              )
            ],
          ),
        )
    );
  }
}
