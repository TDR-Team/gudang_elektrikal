import 'package:logger/logger.dart';

final log = Logger(
  printer: CustomePrinter(),
);

class CustomePrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    final color = PrettyPrinter.defaultLevelColors[event.level];
    final emoji = PrettyPrinter.defaultLevelEmojis[event.level];
    final message = event.message;

    return [color!('$emoji $message')];
  }
}