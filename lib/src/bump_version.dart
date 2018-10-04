import 'dart:io';

import 'package:pub_semver/pub_semver.dart';

import 'base_command.dart';

class BumpVersion extends BaseCommand {
  static final breaking = 'breaking';
  static final major = 'major';
  static final minor = 'minor';
  static final patch = 'patch';
  static final _usage =
      'Use "${breaking}", "${major}", "${minor}", or "${patch}".';
  final String name = 'bump';
  final String description =
      'Bumps the version. ${_usage} See pub_semver for details';

  BumpVersion(Stdout outputSink, Stdout errorSink)
      : super(outputSink, errorSink);

  @override
  Version next(Version current) {
    final part =
        getFirstArgOrThrow(ArgumentError('Argument missing. ${_usage}'));
    if (part == breaking) return current.nextBreaking;
    if (part == major) return current.nextMajor;
    if (part == minor) return current.nextMinor;
    if (part == patch) return current.nextPatch;
    throw ArgumentError('Invalid argument. ${_usage}');
  }
}
