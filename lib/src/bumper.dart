import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_version/src/update_version.dart';

import 'console.dart';

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
