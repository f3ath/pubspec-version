import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mockito/mockito.dart';
import 'package:pubspec/pubspec.dart';
import 'package:pubspec_version/pubspec_version.dart';
import 'package:test/test.dart';

class MockConsole extends Mock implements Console {}

void main() {
  Directory temp;
  MockConsole mockConsole;
  CommandRunner<int> app;

  void expectVersion(String v) async {
    expect((await PubSpec.load(Directory(temp.path))).version.toString(), v);
    expect(
        verify(mockConsole.log(captureAny)).captured.map((_) => _.toString()),
        [v]);
  }

  setUp(() async {
    temp = await Directory.systemTemp.createTemp();
    await File('test/pubspec_sample.yaml').copy('${temp.path}/pubspec.yaml');
    mockConsole = MockConsole();
    app = buildApp(mockConsole);
  });

  tearDown(() async {
    await temp.delete(recursive: true);
  });

  test('bump breaking', () async {
    final code = await app.run(['bump', 'breaking', '-d', temp.path]);
    expect(code, 0);
    await expectVersion('0.4.0');
  });

  test('bump breaking retaining build', () async {
    final code = await app.run(['bump', 'breaking', '-d', temp.path, '-b']);
    expect(code, 0);
    await expectVersion('0.4.0+42');
  });

  test('bump major', () async {
    final code = await app.run(['bump', 'major', '-d', temp.path]);
    expect(code, 0);
    await expectVersion('1.0.0');
  });

  test('bump major retaining build', () async {
    final code = await app.run(['bump', 'major', '-d', temp.path, '-b']);
    expect(code, 0);
    await expectVersion('1.0.0+42');
  });

  test('bump minor', () async {
    final code = await app.run(['bump', 'minor', '-d', temp.path]);
    expect(code, 0);
    await expectVersion('0.4.0');
  });

  test('bump minor retaining build', () async {
    final code = await app.run(['bump', 'minor', '-d', temp.path, '-b']);
    expect(code, 0);
    await expectVersion('0.4.0+42');
  });

  test('bump patch', () async {
    final code = await app.run(['bump', 'patch', '-d', temp.path]);
    expect(code, 0);
    await expectVersion('0.3.3');
  });

  test('bump patch retaining build', () async {
    final code = await app.run(['bump', 'patch', '-d', temp.path, '-b']);
    expect(code, 0);
    await expectVersion('0.3.3+42');
  });

  test('bump build', () async {
    final code = await app.run(['bump', 'build', '-d', temp.path]);
    expect(code, 0);
    await expectVersion('0.3.2+43');
  });

  test('set', () async {
    final code = await app.run(['set', '5.4.321+12', '-d', temp.path]);
    expect(code, 0);
    await expectVersion('5.4.321+12');
  });

  test('set called without version', () async {
    final code = await app.run(['set']);
    expect(code, 64);
    expect(verify(mockConsole.error(captureAny)).captured,
        ['Please provide the version\n\nExample: set 3.2.1']);
  });

  test('get', () async {
    final code = await app.run(['get', '-d', temp.path]);
    expect(code, 0);
    await expectVersion('0.3.2+42');
  });
}
