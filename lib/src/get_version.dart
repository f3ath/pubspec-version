import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:pubspec/pubspec.dart';
import 'package:pubspec_version/src/console.dart';

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
