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
  }

  Version next(Version current);

  FutureOr run() async {
    try {
      final dir = Directory(argResults['pubspec-dir']);
      final pubspec = await await PubSpec.load(dir);
      final nextVersion = next(pubspec.version);
      await await pubspec.copy(version: nextVersion).save(dir);
      outputSink.writeln(nextVersion.toString());
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
