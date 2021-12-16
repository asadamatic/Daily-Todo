class DayPerformance {
  int? day;
  int? total, done;
  double? percentage;

  DayPerformance({this.day, this.total, this.done});

  double getPercentage() {
    if (done == 0 || done == null || total == null) {
      return 0.0;
    }
    return done! / total!;
  }
}
