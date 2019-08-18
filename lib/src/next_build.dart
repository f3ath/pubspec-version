import 'package:pub_semver/pub_semver.dart';

Version nextBuild(Version v) {
  final build = List.from(v.build);
  final firstIntegerIndex = build.indexWhere((_) => _ is int);
  if (firstIntegerIndex == -1) return _withBuild(v, (build + [1]).join('.'));
  build[firstIntegerIndex] += 1;
  return _withBuild(v, (build).join('.'));
}

Version _withBuild(Version v, String build) =>
    Version(v.major, v.minor, v.patch, build: build);
