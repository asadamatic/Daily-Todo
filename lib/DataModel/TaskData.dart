
class TaskData{

  int id;
  String title;
  bool status;
  String date;

  TaskData({this.id, this.title, this.status, this.date});

  int getStatus(){

    return status ? 1 : 0;
  }
  Map<String, dynamic> toMap (){

    return {
      'id': id,
      'title': title,
      'status': getStatus(),
      'date': date,
    };
  }
}