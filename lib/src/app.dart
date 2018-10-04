import 'dart:io';

import 'package:args/command_runner.dart';

import 'bump_version.dart';
import 'set_version.dart';

class App extends CommandRunner {
  App(Stdout outputSink, Stdout errorSink)
      : super('pubspec-version', 'Version bumper/setter for pubspec.yaml') {
    addCommand(BumpVersion(outputSink ?? stdout, errorSink ?? stderr));
    addCommand(SetVersion(outputSink ?? stdout, errorSink ?? stderr));
  }
}
