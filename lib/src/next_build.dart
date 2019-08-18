import 'package:pub_semver/pub_semver.dart';

Version nextBuild(Version v) {
  var incremented = false;
  final build = v.build.map((part) {
    if (part is! int) return part;
    if (incremented) return 0;
    incremented = true;
    return part + 1;
  }).toList();
  if (!incremented) build.add(1);
  return Version(v.major, v.minor, v.patch, build: build.join('.'));
}
