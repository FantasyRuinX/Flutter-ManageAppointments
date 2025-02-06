
class Event{

  final String description;
  final double rand;

  Event({
    required this.description,
    required this.rand
});

}

class Events{

  final DateTime date;
  final String client;
  final List<Event> events;

  Events({
    required this.date,
    required this.client,
    required this.events
  });

  @override
  String toString() {
    return "$date : ${events.length} events";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Events && other.date == date && other.events == events;
  }

  @override
  int get hashCode => date.hashCode;

}