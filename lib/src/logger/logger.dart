import 'package:logger/logger.dart';

class LogService {
  static Logger logger = Logger(
    printer: PrettyPrinter(
    colors: true, // Colorful log messages
    printEmojis: true, // Print an emoji for each log message
    printTime: true // Should each log print contain a timestamp
  ),
    output: ConsoleOutput(),
    filter: PrintallFilter(),
    
  );
}

// class SevrLogPrinter extends LogPrinter {
//   @override
//   List<String> log(LogEvent event) {
//     return [event.message];
//   }

// }
class PrintallFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    // var shouldLog = false;
    // assert(() {
    //   if (event.level.index >= level.index) {
    //     shouldLog = true;
    //   }
    //   return true;
    // }());
    return true;
  }
}