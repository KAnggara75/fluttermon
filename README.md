# Fluttermon

fluttermon is a CLI tool that helps develop Flutter based applications by automatically hot reload the flutter/dart application when file changes in the directory are detected.

## Install

```
flutter pub global activate fluttermon
```

## Running

To run your flutter project with fluttermon, just change the `flutter run` command to `fluttermon`:

```
fluttermon
```

All arguments passed to it will be proxied to the `flutter run` command, so if you want to run on a specific device, the following command can be used:

```
fluttermon -d macOS
```

## FVM support

Fluttermon supports [fvm](https://github.com/leoafarias/fvm) out of the box. Assuming that you have `fvm` installed on your computer, to run fluttermon using fvm under the hood, just pass `--fvm` to it:

```
fluttermon --fvm
```

using fvm with specific device:

```
fluttermon --fvm -d macOS
```
