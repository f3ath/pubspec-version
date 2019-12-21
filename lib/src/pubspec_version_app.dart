import 'dart:io';

import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec/pubspec.dart' as ps;
import 'package:pubspec_version/src/version_transform.dart';

class PubSpecVersionApp {
  final Directory _dir;

  PubSpecVersionApp(String path) : _dir = Directory(path);

  Future<VersionTransform> readVersion() async {
    final pubSpec = await _load();
    return VersionTransform(pubSpec.version);
  }

  Future<void> writeVersion(VersionTransform version) async {
    final pubSpec = await _load();
    await pubSpec.copy(version: version.version).save(_dir);
  }

  Future<void> writeVersionString(String version) =>
      writeVersion(VersionTransform(Version.parse(version)));

  Future<void> bumpBreaking({bool retainBuild = false}) =>
      _update((_) => _.bumpBreaking(), retainBuild: retainBuild);

  Future<void> bumpMajor({bool retainBuild = false}) =>
      _update((_) => _.bumpMajor(), retainBuild: retainBuild);

  Future<void> bumpMinor({bool retainBuild = false}) =>
      _update((_) => _.bumpMinor(), retainBuild: retainBuild);

  Future<void> bumpPatch({bool retainBuild = false}) =>
      _update((_) => _.bumpPatch(), retainBuild: retainBuild);

  Future<void> bumpBuild() => _update((_) => _.bumpBuild());

  Future<void> _update(VersionTransform Function(VersionTransform v) mutate,
      {bool retainBuild = false}) async {
    final version = await readVersion();
    var newVersion =
        retainBuild ? mutate(version).withBuildFrom(version) : mutate(version);
    await writeVersion(newVersion);
  }

  Future<ps.PubSpec> _load() => ps.PubSpec.load(_dir);
}
