import 'dart:io';

import 'package:pubspec_version/pubspec_version.dart';

void main(List<String> args) async =>
    exit(await App(Console.stdio()).run(args));
