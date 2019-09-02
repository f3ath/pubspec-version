import 'package:args/command_runner.dart';
import 'package:pubspec_version/src/pubspec_version_app.dart';

class PubSpecCommand extends Command<int> {
  final String description;
  final String name;
  final _Payload _payload;

  PubSpecCommand(this.name, this.description, this._payload);

  bool get retainBuild => globalResults['retain-build'];

  Future<String> readVersion() async => (await _app.readVersion()).toString();

  Future<void> writeVersion(String version) => _app.writeVersionString(version);

  Future<void> bumpBreaking() => _app.bumpBreaking(retainBuild: retainBuild);

  Future<void> bumpMajor() => _app.bumpMajor(retainBuild: retainBuild);

  Future<void> bumpMinor() => _app.bumpMinor(retainBuild: retainBuild);

  Future<void> bumpPatch() => _app.bumpPatch(retainBuild: retainBuild);

  Future<void> bumpBuild() => _app.bumpBuild();

  String getArgument(int index) => globalResults.arguments[index];

  List<String> get arguments => globalResults.arguments;

  Future<int> run() => _payload(this);

  PubSpecVersionApp get _app => PubSpecVersionApp(globalResults['pubspec-dir']);
}

typedef Future<int> _Payload(PubSpecCommand command);
