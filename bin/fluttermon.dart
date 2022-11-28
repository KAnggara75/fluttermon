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

  // Constractor
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
    await Future.delayed(const Duration(milliseconds: 500));
    _process.stdin.write('r');
  }

  Future<void> _quit() async {
    _process.stdin.write('q');
    await Future.delayed(const Duration(milliseconds: 500));
    _process.kill();
    exit(await _process.exitCode);
  }

  void _manualInput(String input) async {
    if (input == 'c') {
      print("\x1B[2J\x1B[0;0H");
    } else if (input == 'q') {
      await _quit();
    } else {
      _process.stdin.write(input);
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
