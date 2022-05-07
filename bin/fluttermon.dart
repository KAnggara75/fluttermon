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
  Future? _updater;

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
    _updater = null;
  }

  Future<void> start() async {
    _process = await Process.start('flutter', ['run', ..._listOfArgs]);
    _process.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .forEach(_processLine);

    final projectDir = File('.');
    projectDir.watch(recursive: true).listen((event) {
      if (event.path.startsWith('./lib')) {
        if (_updater == null) {
          print('Reloading.... ');
          _updater = _hotReload();
        }
      }
    });
  }
}
