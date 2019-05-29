import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec/pubspec.dart';

class App {
  final Console console;

  App(this.console);

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

class Bumper extends UpdateVersion {
  final String name;
  final String description;

  Bumper(this.name, this.description, Console c) : super(c);

  Version nextVersion(Version v) => {
        'breaking': () => v.nextBreaking,
        'major': () => v.nextMajor,
        'minor': () => v.nextMinor,
        'patch': () => v.nextPatch,
      }[name]();
}

class Console {
  final Stdout _output;
  final Stdout _error;

  Console(this._output, this._error);

  Console.stdio() : this(stdout, stderr);

  void error(Object e) => _error.writeln(e);

  void log(Object message) => _output.writeln(message);
}

class BumpVersion<T> extends Command<T> {
  final name = 'bump';
  final description = 'Bumps the package version.';

  BumpVersion(List<Command<T>> subcommands) {
    subcommands.forEach(addSubcommand);
  }
}

class SetVersion extends UpdateVersion {
  final name = 'set';
  final description = 'Sets the package version.';

  SetVersion(Console c) : super(c);

  Version nextVersion(Version v) {
    if (globalResults.arguments.length < 2)
      throw UsageException('Please provide the version', 'Example: set 3.2.1');
    return Version.parse(globalResults.arguments[1]);
  }
}

abstract class UpdateVersion extends Command {
  final Console console;

  UpdateVersion(this.console);

  Future run() async {
    final dir = Directory(globalResults['pubspec-dir']);
    final pubSpec = await PubSpec.load(dir);
    final version = nextVersion(pubSpec.version);
    await pubSpec.copy(version: version).save(dir);
    console.log(version.toString());
  }

  Version nextVersion(Version v);
}

class GetVersion extends Command {
  final Console console;
  final name = 'get';
  final description = 'Gets the current package version.';

  GetVersion(this.console);

  @override
  Future run() async {
    final dir = Directory(globalResults['pubspec-dir']);
    final pubSpec = await PubSpec.load(dir);
    console.log(pubSpec.version.toString());
  }
}
