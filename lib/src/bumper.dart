import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_version/src/version_command.dart';

import 'console.dart';

class Bumper extends VersionCommand {
  final String name;
  final String description;
  final _Mutator mutator;

  Bumper(this.name, this.description, Console c, this.mutator) : super(c);

  Version nextVersion(Version v) => mutator(v);
}

typedef Version _Mutator(Version v);
