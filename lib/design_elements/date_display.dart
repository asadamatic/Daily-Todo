import 'package:dailytodo/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DateDisplay extends StatelessWidget {
  const DateDisplay({
    Key? key,
    required HomeController homeController,
  }) : _homeController = homeController, super(key: key);

  final HomeController _homeController;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5.0,
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)),
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Container(
          padding:
          EdgeInsets.only(right: 12.0, left: 16.0, top: 12.0, bottom: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GetBuilder<HomeController>(
                builder: (_homeController) {
                  return Text(
                    '${DateFormat.yMMMMd().format(_homeController.pickedDate)}',
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.calendar_today,
                  color: Colors.blue,
                ),
                onPressed: () => _homeController.selectDate(),
              )
            ],
          ),
        ));
  }
}
