import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:pubspec_version/src/bump_version.dart';
import 'package:pubspec_version/src/bumper.dart';
import 'package:pubspec_version/src/console.dart';
import 'package:pubspec_version/src/get_version_command.dart';
import 'package:pubspec_version/src/next_build.dart';
import 'package:pubspec_version/src/set_version_command.dart';

class Application {
  final Console console;

  Application(this.console);

  Future<int> run(List<String> args) async {
    final bumpers = [
      Bumper('breaking', 'Bumps the version to the next breaking.', console,
          (_) => _.nextBreaking),
      Bumper('major', 'Bumps the major version.', console, (_) => _.nextMajor),
      Bumper('minor', 'Bumps the minor version.', console, (_) => _.nextMinor),
      Bumper('patch', 'Bumps the patch version.', console, (_) => _.nextPatch),
      Bumper('build', 'Bumps the first numeric part of the build version.',
          console, nextBuild),
    ];
    final commandRunner =
        await CommandRunner('pubver', 'Package version manager.')
          ..addCommand(BumpVersionCommand(bumpers))
          ..addCommand(SetVersionCommand(console))
          ..addCommand(GetVersionCommand(console))
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
