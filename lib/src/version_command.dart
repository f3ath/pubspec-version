import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec/pubspec.dart';
import 'package:pubspec_version/src/console.dart';

abstract class VersionCommand extends Command {
  final Console console;

  VersionCommand(this.console);

  Future run() async {
    final dir = Directory(globalResults['pubspec-dir']);
    final pubSpec = await PubSpec.load(dir);
    final version = nextVersion(pubSpec.version);
    await pubSpec.copy(version: version).save(dir);
    console.log(version.toString());
  }

  Version nextVersion(Version v);
}
