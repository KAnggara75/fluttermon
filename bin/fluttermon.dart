import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  final fluttermon = Fluttermon(args);
  fluttermon.start();
}

class Fluttermon {
  late Process _process;
  final List<String> args;
  final List<String> _listOfArgs = [];

  Fluttermon(this.args) {
    _parseArgs();
  }

  void _parseArgs() {
    for (String arg in args) {
      _listOfArgs.add(arg);
    }
  }

  void _processLine(String line) {
    print(line);
  }

  Future<void> start() async {
    _process = await Process.start('flutter', ['run', ..._listOfArgs]);
    _process.stdout
        .transform(
          utf8.decoder,
        )
        .forEach(
          _processLine,
        );
  }
}
