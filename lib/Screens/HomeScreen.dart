import 'dart:async';
import 'package:dailytodo/DataModel/TaskData.dart';
import 'package:dailytodo/DesignElements/CustomChartCard.dart';
import 'package:dailytodo/DesignElements/CustomCheckBox.dart';
import 'package:dailytodo/LocalDatabase/LocalDatabase.dart';
import 'package:day_night_switch/day_night_switch.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'EditingDialog.dart';



class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: Provider.of<ValueNotifier<DateTime>>(context, listen: false).value,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != Provider.of<ValueNotifier<DateTime>>(context, listen: false).value){

      Provider.of<ValueNotifier<DateTime>>(context, listen: false).value = picked;
    }
  }

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Provider.of<LocalDatabase>(context, listen: false).initializeDB();

  }

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
          onPressed: (){
            showAboutDialog(context: context,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('App Icons by ', style: TextStyle(color: Colors.grey),),
                    GestureDetector(
                        onTap: () async{
                          await launch('https://flaticon.com');
                        },
                        child: Text('Flaticon.com', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blueGrey),)
                    ),
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
          Transform.scale(
            scale: .5,
            child: Container(
            
              child: Consumer<ValueNotifier<bool>>(
                builder: (context, data, child){

                  return DayNightSwitch(
                    value: data.value,
                    onChanged: (value){
                      Provider.of<ValueNotifier<bool>>(context, listen: false).value = value;
                      ThemeProvider.controllerOf(context).nextTheme();
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        controller: _scrollController,
        children: <Widget>[
          CustomChartCard(),
          Card(
                elevation: 5.0,
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                ),
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Consumer<ValueNotifier<DateTime>>(
                        builder: (context, data, child){
                          return Text('${DateFormat.yMMMMd().format(data.value)}', style: TextStyle(fontSize: 24.0,),);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.calendar_today,
                          color: Colors.blue,
                        ),
                        onPressed: () => _selectDate(context),
                      )
                    ],
                  ),
                )
            ),
          Consumer<ValueNotifier<DateTime>>(
            builder: (context, date, child){
              return Consumer<LocalDatabase>(
                builder: (context, data, child){

                  return FutureBuilder<List<TaskData>>(
                    future: data.returnTasks(date.value),
                    builder: (context, snapshot){
                      if (snapshot.hasData){
                        if (snapshot.data.length == 0){
                          return Center(
                              child: Text("You don't have any tasks to show!")
                          );
                        } else if (snapshot.data.length > 0 && snapshot.data.length <= 2){
                          return Column(
                            children: snapshot.data.map<Widget>((taskData) => CustomCheckBox(key: UniqueKey(), taskData: taskData)).toList(),
                          );
                        }
                        return Column(
                          children: <Widget>[
                            Column(
                              children: snapshot.data.map<Widget>((taskData) => CustomCheckBox(key: UniqueKey(), taskData: taskData)).toList(),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FloatingActionButton(
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Icon(
                                  Icons.keyboard_arrow_up,
                                ),
                                onPressed: () async{
                                  _scrollController.animateTo(
                                    0.0,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut,);
                                },
                              ),
                            ),
                          ],
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(

        child: Container(
          height: 50.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child:  RaisedButton(
                  color: Theme.of(context).bottomAppBarColor,
                  textColor: Colors.white,
                  child: Text('ADD NEW TASK', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                  onPressed: (){
                      showDialog(context: context, builder: (context){
                        return EditingDialog();
                      });
                  },
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
