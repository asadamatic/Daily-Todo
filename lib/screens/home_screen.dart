import 'package:dailytodo/controllers/home_controller.dart';
import 'package:dailytodo/design_elements/custom_chart_card.dart';
import 'package:dailytodo/design_elements/CustomCheckBox.dart';
import 'package:dailytodo/design_elements/date_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'editing_dialog.dart';

class HomeScreen extends StatelessWidget {
  final _homeController = Get.put(TodoHomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('DAILY TODO'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.info_outline,
            ),
            onPressed: () {
              showAboutDialog(
                context: context,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'App Icons by ',
                        style: TextStyle(color: Colors.grey),
                      ),
                      GestureDetector(
                          onTap: () async {
                            await launch('https://flaticon.com');
                          },
                          child: Text(
                            'Flaticon.com',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.blueGrey),
                          )),
                    ],
                  )
                ],
                applicationName: 'Daily Todo',
                applicationVersion: '1.0.1',
                applicationIcon: Image(
                  image: AssetImage('Assets/calendar_1.png'),
                  height: 60.0,
                  width: 60.0,
                ),
              );
            },
          ),
          actions: <Widget>[
            Container(
              child: GetBuilder<TodoHomeController>(
                id: 'themeUpdate',
                assignId: true,
                builder: (_homeController) {
                  print('Theme switch rebuilt');
                  return Switch(
                      value: _homeController.themeMode == ThemeMode.dark,
                      onChanged: _homeController.toggleTheme);
                },
              ),
            ),
          ],
        ),
        body: ListView(
          controller: _homeController.scrollController,
          children: <Widget>[
            CustomChartCard(),
            DateDisplay(homeController: _homeController),
            Column(
              children: <Widget>[
                GetBuilder<TodoHomeController>(
                    id: 'tasksUpdate',
                    assignId: true,
                    builder: (_homeController) {
                      print('Tasks list rebuilt');
                      return Column(
                        children: _homeController.tasks
                            .map<Widget>((taskData) => CustomCheckBox(
                                key: UniqueKey(), taskData: taskData))
                            .toList(),
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    child: Icon(
                      Icons.keyboard_arrow_up,
                    ),
                    onPressed: () async {
                      _homeController.scrollController.animateTo(
                        0.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    },
                  ),
                )
              ],
            )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 50.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).bottomAppBarColor)),
                    child: Text(
                      'ADD NEW TASK',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return EditingDialog();
                          });
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
