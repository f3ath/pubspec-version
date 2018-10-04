import 'dart:io';

import 'package:pub_semver/pub_semver.dart';

import 'base_command.dart';

class SetVersion extends BaseCommand {
  final String name = 'set';
  final String description = 'Sets the version to the given value.';

  SetVersion(Stdout outputSink, Stdout errorSink)
      : super(outputSink, errorSink);

  @override
  Version next(Version current) => Version.parse(
      getFirstArgOrThrow(ArgumentError('Argument missing.')).toLowerCase());
}
