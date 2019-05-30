import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:pubspec_version/src/bump_version.dart';
import 'package:pubspec_version/src/bumper.dart';
import 'package:pubspec_version/src/console.dart';
import 'package:pubspec_version/src/get_version.dart';
import 'package:pubspec_version/src/set_version.dart';

class Application {
  final Console console;

  Application(this.console);

  Future<int> run(List<String> args) async {
    final bumpers = [
      Bumper('breaking', 'Bumps the version to the next breaking.', console),
      Bumper('major', 'Bumps the major version.', console),
      Bumper('minor', 'Bumps the minor version.', console),
      Bumper('patch', 'Bumps the patch version.', console),
    ];
    final commandRunner =
        await CommandRunner('pubver', 'Package version manager.')
          ..addCommand(BumpVersion(bumpers))
          ..addCommand(SetVersion(console))
          ..addCommand(GetVersion(console))
          ..argParser.addOption('pubspec-dir',
              abbr: 'd',
              help: 'Directory containing pubspec.yaml.',
              defaultsTo: '.');

    try {
      await commandRunner.run(args);
      return 0;
    } on UsageException catch (e) {
      console.error(e.toString());
      return 64;
    }
  }
}
