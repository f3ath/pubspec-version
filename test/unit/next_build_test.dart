import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_version/src/next_build.dart';
import 'package:test/test.dart';

void main() {
  test('bumping empty build sets it to 1', () async {
    final v = Version.parse('1.2.3');
    expect(nextBuild(v).toString(), '1.2.3+1');
  });

  test('non-numeric build gets ".1" appended to it', () async {
    final v = Version.parse('1.2.3+foo42');
    expect(nextBuild(v).toString(), '1.2.3+foo42.1');
  });

  test('in a complex build the first numeric part gets incremented', () async {
    final v = Version.parse('1.2.3+foo.1.2.3.bar');
    expect(nextBuild(v).toString(), '1.2.3+foo.2.0.0.bar');
  });
}
