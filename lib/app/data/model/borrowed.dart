import 'package:timeago/timeago.dart' as timeago;

class Borrowed {
  final int id;
  final String toolsName;
  final String borrowersName;
  final String date;
  final String duration;
  final bool status;

  Borrowed({
    required this.id,
    required this.toolsName,
    required this.borrowersName,
    required this.date,
    required this.duration,
    required this.status,
  });

  factory Borrowed.withCalculatedDuration({
    required int id,
    required String toolsName,
    required String borrowersName,
    required String date,
    required bool status,
  }) {
    final parsedDate = DateTime.parse(date);
    final duration = timeago.format(parsedDate);
    return Borrowed(
      id: id,
      toolsName: toolsName,
      borrowersName: borrowersName,
      date: date,
      duration: duration,
      status: status,
    );
  }
}

final listDummyBorrowed = [
  Borrowed.withCalculatedDuration(
    id: 1,
    toolsName: "Hammer",
    borrowersName: "Alice",
    date: "2024-08-01 08:00:00",
    status: true,
  ),
  Borrowed.withCalculatedDuration(
    id: 2,
    toolsName: "Screwdriver",
    borrowersName: "Bob",
    date: "2024-08-01 07:00:00",
    status: false,
  ),
  Borrowed.withCalculatedDuration(
    id: 3,
    toolsName: "Wrench",
    borrowersName: "Charlie",
    date: "2024-07-31 08:00:00",
    status: true,
  ),
  Borrowed.withCalculatedDuration(
    id: 4,
    toolsName: "Drill",
    borrowersName: "Dave",
    date: "2024-07-25 08:00:00",
    status: false,
  ),
  Borrowed.withCalculatedDuration(
    id: 5,
    toolsName: "Saw",
    borrowersName: "Eve",
    date: "2024-07-01 08:00:00",
    status: true,
  ),
];
