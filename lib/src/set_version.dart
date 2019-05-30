import 'package:args/command_runner.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_version/src/console.dart';
import 'package:pubspec_version/src/update_version.dart';

class SetVersion extends UpdateVersion {
  final name = 'set';
  final description = 'Sets the package version.';

  SetVersion(Console c) : super(c);

  Version nextVersion(Version v) {
    if (globalResults.arguments.length < 2) {
      throw UsageException('Please provide the version', 'Example: set 3.2.1');
    }
    return Version.parse(globalResults.arguments[1]);
  }
}
