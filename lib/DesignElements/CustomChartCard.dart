import 'package:charts_flutter/flutter.dart';
import 'package:dailytodo/DataModel/DayPerformance.dart';
import 'package:dailytodo/LocalDatabase/LocalDatabase.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CustomChartCard extends StatefulWidget {

  @override
  _CustomChartCardState createState() => _CustomChartCardState();
}

class _CustomChartCardState extends State<CustomChartCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
          elevation: 5.0,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)
          ),
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            children: <Widget>[
              Container(
                height: 250.0,
                child: CustomChart(),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Consumer<ValueNotifier<DateTime>>(
                      builder: (context, date, child){
                        return Text('${DateFormat('MMMM y').format(date.value)}');
                      },
                ),
              )
            ],
          ),
        );
  }
}


class CustomChart extends StatefulWidget {

  @override
  _CustomChartState createState() => _CustomChartState();
}

class _CustomChartState extends State<CustomChart> {

  @override
  Widget build(BuildContext context) {

    return Consumer<ValueNotifier<DateTime>>(
        builder: (context, date, child) {
          return Consumer<LocalDatabase>(
              builder: (context, data, child) {
                return FutureBuilder<List<DayPerformance>>(
                  future: Provider.of<LocalDatabase>(context).getDataForGraph(
                      date.value),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Series<DayPerformance, String>> series = [
                        Series(
                            id: 'Performance',
                            data: snapshot.data,
                            domainFn: (DayPerformance dayPerformance, _) => dayPerformance.day.toString(),
                            measureFn: (DayPerformance dayPerformance, _) => dayPerformance.getPercentage()
                        ),
                      ];
                      return BarChart(
                        series,
                        animate: true,
                        primaryMeasureAxis: NumericAxisSpec(
                          renderSpec: NoneRenderSpec(),
                        ),
                        domainAxis: OrdinalAxisSpec(
                          renderSpec: NoneRenderSpec(),
                          showAxisLine: true,
                          viewport: OrdinalViewport('AePS', 31),
                        ),
                        behaviors: [
                          SeriesLegend(),
                        ],
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                );
              }
          );
        }
    );
  }
}


