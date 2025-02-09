
class Events{

  final String client;
  final List<String> date;
  final List<String> rand;
  final List<String> info;

  Events({
    required this.client,
    required this.date,
    required this.rand,
    required this.info
  });

  Events.fromJson(Map<String, dynamic> jsonMap) : this(
    client : (jsonMap['client'] as String),
    date : List<String>.from(jsonMap['started'] as List),
    rand : List<String>.from(jsonMap['rand'] as List),
    info : List<String>.from(jsonMap['info'] as List)
  );

  Map<String, Object?> toJson() {
    return {
      'client': client.toString(),
      'date': date.toString(),
      'rand': rand.toString(),
      'info': info.toString(),
    };
  }


  @override
  String toString() {
    return "$date : ${info.length} events";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Events &&
        other.client == client &&
        other.date == date &&
        other.rand == rand &&
        other.info == info;
  }

  @override
  int get hashCode => date.hashCode;

}