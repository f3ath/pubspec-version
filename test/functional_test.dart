import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:pubspec/pubspec.dart';
import 'package:pubspec_version/pubspec_version.dart';
import 'package:test/test.dart';

class MockConsole extends Mock implements Console {}

void main() {
  Directory temp;
  MockConsole mockConsole;
  App app;

  expectVersion(String v) async {
    expect((await PubSpec.load(Directory(temp.path))).version.toString(), v);
    expect(verify(mockConsole.log(captureAny)).captured, [v]);
  }

  setUp(() async {
    temp = await Directory.systemTemp.createTemp();
    File('test/pubspec_sample.yaml').copy('${temp.path}/pubspec.yaml');
    mockConsole = MockConsole();
    app = App(mockConsole);
  });

  tearDown(() async {
    await temp.delete(recursive: true);
  });

  test('bump breaking', () async {
    final code = await app.run(['bump', 'breaking', '-d', temp.path]);
    expect(code, 0);
    await expectVersion('0.4.0');
  });

  test('bump major', () async {
    final code = await app.run(['bump', 'major', '-d', temp.path]);
    expect(code, 0);
    await expectVersion('1.0.0');
  });

  test('bump minor', () async {
    final code = await app.run(['bump', 'minor', '-d', temp.path]);
    expect(code, 0);
    await expectVersion('0.4.0');
  });

  test('bump patch', () async {
    final code = await app.run(['bump', 'patch', '-d', temp.path]);
    expect(code, 0);
    await expectVersion('0.3.3');
  });

  test('set', () async {
    final code = await app.run(['set', '5.4.321', '-d', temp.path]);
    expect(code, 0);
    await expectVersion('5.4.321');
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
    await expectVersion('0.3.2');
  });
}
