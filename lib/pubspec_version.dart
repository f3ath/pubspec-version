import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec/pubspec.dart';

class Console {
  final Stdout _output;
  final Stdout _error;

  Console([Stdout output, Stdout error])
      : _output = output ?? stdout,
        _error = error ?? stderr;

  void error(Object e) => _error.writeln(e);

  void log(Object message) => _output.writeln(message);
}

class Command {
  final _parser = ArgParser();
  final Console _console;
  final NextVersion _nextVersion;

  Command(Console this._console, NextVersion this._nextVersion) {
    _parser.addOption('pubspec-dir',
        abbr: 'd',
        help: 'Directory to look pubspec.yaml in. Default is the current dir.',
        defaultsTo: '.');

    _parser.addFlag('commit',
        abbr: 'c',
        help:
            'Runs `git commit . -m "Release <version>"` and `git tag <version>`',
        defaultsTo: false);
  }

  FutureOr<int> run(List<String> cliArgs) async {
    try {
      final args = _parseArgs(cliArgs);
      final dir = Directory(args['pubspec-dir']);
      final pubSpec = await PubSpec.load(dir);
      final nextVersion = _nextVersion(pubSpec.version, args.arguments);
      await pubSpec.copy(version: nextVersion).save(dir);
      _console.log(nextVersion.toString());
      if (args['commit']) {
        await Process.run('git', [
          'commit',
          '.',
          '-m',
          'Release ${Version.parse(args.arguments[0]).toString()}'
        ]);
        await Process.run(
            'git', ['tag', Version.parse(args.arguments[0]).toString()]);
      }
      return 0;
    } on Error catch (e) {
      _console.error(e);
      return 2;
    }
  }

  ArgResults _parseArgs(List<String> cliArgs) => _parser.parse(cliArgs);
}

typedef Version NextVersion(Version current, List<String> args);

Version setVersion(Version c, List<String> args) => Version.parse(args[0]);

Version bumpVersion(Version current, List<String> args) {
  final part = args[0];
  if (part == 'breaking') return current.nextBreaking;
  if (part == 'major') return current.nextMajor;
  if (part == 'minor') return current.nextMinor;
  if (part == 'patch') return current.nextPatch;
  throw ArgumentError();
}
