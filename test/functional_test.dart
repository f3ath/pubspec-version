import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:pubspec/pubspec.dart';
import 'package:test/test.dart';

import 'package:pubspec_version/pubspec-version.dart';

class MockStdOut extends Mock implements Stdout {}

class MockStdErr extends Mock implements Stdout {}

void main() {
  Directory temp;
  MockStdOut mockStdOut;
  MockStdErr mockStdErr;
  App app;

  expectVersion(String v) async {
    expect(verify(mockStdOut.writeln(captureAny)).captured, [v]);
    expect((await PubSpec.load(Directory(temp.path))).version.toString(), v);
  }

  setUp(() async {
    temp = await Directory.systemTemp.createTemp();
    File('test/pubspec_sample.yaml').copy('${temp.path}/pubspec.yaml');
    mockStdOut = MockStdOut();
    mockStdErr = MockStdErr();
    app = App(mockStdOut, mockStdErr);
  });

  tearDown(() async {
    await temp.delete(recursive: true);
  });

  test('bump breaking', () async {
    await app.run(['bump', 'breaking', '-d', temp.path]);
    await expectVersion('0.4.0');
  });

  test('bump major', () async {
    await app.run(['bump', 'major', '-d', temp.path]);
    await expectVersion('1.0.0');
  });

  test('bump minor', () async {
    await app.run(['bump', 'minor', '-d', temp.path]);
    await expectVersion('0.4.0');
  });

  test('bump patch', () async {
    await app.run(['bump', 'patch', '-d', temp.path]);
    await expectVersion('0.3.3');
  });

  test('set', () async {
    await app.run(['set', '5.4.321', '-d', temp.path]);
    await expectVersion('5.4.321');
  });
}
