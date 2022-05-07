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

  Future<void> _hotReload() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    );
    _process.stdin.write('r');
  }

  void _manualInput(String input) {
    if (input == 'r' ||
        input == 'R' ||
        input == 'v' ||
        input == 'w' ||
        input == 't' ||
        input == 'L' ||
        input == 'S' ||
        input == 'U' ||
        input == 'i' ||
        input == 'p' ||
        input == 'I' ||
        input == 'o' ||
        input == 'b' ||
        input == 'P' ||
        input == 'a' ||
        input == 'M' ||
        input == 'g' ||
        input == 'h' ||
        input == 'd') {
      _process.stdin.write(input);
    } else if (input == 'c') {
      print("\x1B[2J\x1B[0;0H");
    } else if (input == 'q') {
      _process.stdin.write(input);
      print("Application finished.");
      _process.kill();
      exit(0);
    }
  }

  Future<void> start() async {
    _process = await Process.start('flutter', ['run', ..._listOfArgs]);
    _process.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .forEach(_processLine);

    final projectDir = File('.');
    projectDir.watch(recursive: true).listen((e) {
      if (e.path.startsWith('./lib')) {
        _hotReload();
      }
    });
    readInput().listen(_manualInput);
  }

  Stream<String> readInput() =>
      stdin.transform(utf8.decoder).transform(const LineSplitter());
}
