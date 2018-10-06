import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:pubspec/pubspec.dart';
import 'package:pubspec_version/pubspec_version.dart';
import 'package:test/test.dart';

class MockConsole extends Mock implements Console {}

void main() {
  Directory temp;
  MockConsole mockConsole;
  Command setCommand;
  Command bumpCommand;

  expectVersion(String v) async {
    expect(verify(mockConsole.log(captureAny)).captured, [v]);
    expect((await PubSpec.load(Directory(temp.path))).version.toString(), v);
  }

  setUp(() async {
    temp = await Directory.systemTemp.createTemp();
    File('test/pubspec_sample.yaml').copy('${temp.path}/pubspec.yaml');
    mockConsole = MockConsole();

    setCommand = Command(mockConsole, setVersion);
    bumpCommand = Command(mockConsole, bumpVersion);
  });

  tearDown(() async {
    await temp.delete(recursive: true);
  });

  test('bump breaking', () async {
    await bumpCommand.run(['breaking', '-d', temp.path]);
    await expectVersion('0.4.0');
  });

  test('bump major', () async {
    await bumpCommand.run(['major', '-d', temp.path]);
    await expectVersion('1.0.0');
  });

  test('bump minor', () async {
    await bumpCommand.run(['minor', '-d', temp.path]);
    await expectVersion('0.4.0');
  });

  test('bump patch', () async {
    await bumpCommand.run(['patch', '-d', temp.path]);
    await expectVersion('0.3.3');
  });

  test('set', () async {
    final code = await setCommand.run(['5.4.321', '-d', temp.path]);
    expect(code, 0);
    await expectVersion('5.4.321');
  });
}
