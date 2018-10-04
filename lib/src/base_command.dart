import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec/pubspec.dart';

abstract class BaseCommand extends Command {
  final Stdout outputSink;
  final Stdout errorSink;

  BaseCommand(Stdout this.outputSink, Stdout this.errorSink) {
    argParser.addOption('pubspec-dir',
        abbr: 'd',
        help: 'Directory to look pubspec.yaml in. Default is the current dir.',
        defaultsTo: '.');
    argParser.addFlag('commit',
        abbr: 'c',
        help:
            'Runs `git commit . -m "Release <version>"` and `git tag <version>`',
        defaultsTo: false);
  }

  Version next(Version current);

  FutureOr run() async {
    try {
      final dir = Directory(argResults['pubspec-dir']);
      final pubspec = await await PubSpec.load(dir);
      final nextVersion = next(pubspec.version);
      await await pubspec.copy(version: nextVersion).save(dir);
      outputSink.writeln(nextVersion.toString());
      if (argResults['commit']) {
        await Process.run(
            'git', ['commit', '.', '-m', 'Release ${nextVersion.toString()}']);
        await Process.run('git', ['tag', nextVersion.toString()]);
      }
    } on Error catch (e) {
      errorSink.writeln(e);
      exitCode = 2;
    }
  }

  String getFirstArgOrThrow(Error e) {
    final args = argResults.arguments;
    if (args.isEmpty) throw e;
    return args[0];
  }
}
