import 'dart:io';

import 'package:pubspec_version/pubspec-version.dart';

void main(List<String> arguments) async =>
    await App(stdout, stderr).run(arguments);
