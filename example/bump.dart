import 'dart:io';

import 'package:pubspec_version/pubspec_version.dart';

void main(List<String> args) async {
  exitCode = await Command(Console(), bumpVersion).run(args);
}
