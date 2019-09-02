import 'package:pub_semver/pub_semver.dart';

class VersionTransform {
  final Version version;

  VersionTransform(this.version);

  VersionTransform bumpBreaking() => VersionTransform(version.nextBreaking);

  VersionTransform bumpMajor() => VersionTransform(version.nextMajor);

  VersionTransform bumpMinor() => VersionTransform(version.nextMinor);

  VersionTransform bumpPatch() => VersionTransform(version.nextPatch);

  VersionTransform bumpBuild() {
    var incremented = false;
    final build = version.build.map((part) {
      if (part is! int) return part;
      if (incremented) return 0;
      incremented = true;
      return part + 1;
    }).toList();
    if (!incremented) build.add(1);
    return withBuild(build);
  }

  VersionTransform withBuild(List build) =>
      VersionTransform(Version(version.major, version.minor, version.patch,
          build: build.join('.')));

  VersionTransform withBuildFrom(VersionTransform other) =>
      withBuild(other.version.build);

  @override
  String toString() => version.toString();
}
