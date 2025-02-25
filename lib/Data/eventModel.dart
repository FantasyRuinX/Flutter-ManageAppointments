
class Event{

  final int id;
  final String name;
  final String date;
  final String rand;
  final String info;
  final String location;

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.rand,
    required this.info,
    required this.location,
  });

  Event.fromJson(Map<String, dynamic> jsonMap) : this(
    id : jsonMap['id'],
    name : jsonMap['name'],
    date : jsonMap['date'],
    rand : jsonMap['rand'],
    info : jsonMap['info'],
    location : jsonMap['location']
  );

  Map<String, Object?> toJson() {
    return {
      'id': id.toString(),
      'name': name.toString(),
      'date': date.toString(),
      'rand': rand.toString(),
      'info': info.toString(),
      'location': location.toString(),
    };
  }


  @override
  String toString() {
    return "$name | $date : $info";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Event &&
        other.id == id &&
        other.name == name &&
        other.date == date &&
        other.rand == rand &&
        other.info == info &&
        other.location == location;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ date.hashCode ^ rand.hashCode ^ info.hashCode ^ location.hashCode;

}