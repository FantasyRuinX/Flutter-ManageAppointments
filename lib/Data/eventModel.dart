
class Event{

  final String date;
  final String rand;
  final String info;
  final String location;

  Event({
    required this.date,
    required this.rand,
    required this.info,
    required this.location
  });

  Event.fromJson(Map<String, dynamic> jsonMap) : this(
    date : jsonMap['started'],
    rand : jsonMap['rand'],
    info : jsonMap['info'],
    location : jsonMap['location']
  );

  Map<String, Object?> toJson() {
    return {
      'id': hashCode.toInt(),
      'date': date.toString(),
      'rand': rand.toString(),
      'info': info.toString(),
      'location': location.toString(),
    };
  }


  @override
  String toString() {
    return "$date : ${info.length} events";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Event &&
        other.date == date &&
        other.rand == rand &&
        other.info == info &&
        other.location == location;
  }

  @override
  int get hashCode => date.hashCode ^ rand.hashCode ^ info.hashCode;

}