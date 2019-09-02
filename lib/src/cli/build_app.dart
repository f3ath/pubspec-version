import 'package:args/command_runner.dart';
import 'package:pubspec_version/src/cli/command_container.dart';
import 'package:pubspec_version/src/cli/pub_spec_command.dart';
import 'package:pubspec_version/src/console.dart';

CommandRunner<int> buildApp(Console console) =>
    CommandRunner<int>('pubver', 'Package version manager.')
      ..addCommand(CommandContainer(
        'bump',
        'Bumps the package version.',
        [
          PubSpecCommand(
            'breaking',
            'Bumps the version to the next breaking.',
            (_) async {
              await _.bumpBreaking();
              console.log(await _.readVersion());
              return 0;
            },
          ),
          PubSpecCommand(
            'major',
            'Bumps the major version.',
            (_) async {
              await _.bumpMajor();
              console.log(await _.readVersion());
              return 0;
            },
          ),
          PubSpecCommand(
            'minor',
            'Bumps the minor version.',
            (_) async {
              await _.bumpMinor();
              console.log(await _.readVersion());
              return 0;
            },
          ),
          PubSpecCommand(
            'patch',
            'Bumps the patch version.',
            (_) async {
              await _.bumpPatch();
              console.log(await _.readVersion());
              return 0;
            },
          ),
          PubSpecCommand(
            'build',
            'Bumps the first numeric part of the build version.',
            (_) async {
              await _.bumpBuild();
              console.log(await _.readVersion());
              return 0;
            },
          ),
        ],
      ))
      ..addCommand(PubSpecCommand(
        'set',
        'Sets the package version.',
        (_) async {
          if (_.arguments.length < 2) {
            console.error(
                'Please provide the version' + '\n' * 2 + 'Example: set 3.2.1');
            return 64;
          }
          await _.writeVersion(_.getArgument(1));
          console.log(await _.readVersion());
          return 0;
        },
      ))
      ..addCommand(PubSpecCommand(
        'get',
        'Gets the current package version.',
        (_) async {
          console.log(await _.readVersion());
          return 0;
        },
      ))
      ..argParser.addOption('pubspec-dir',
          abbr: 'd',
          help: 'Directory containing pubspec.yaml.',
          defaultsTo: '.')
      ..argParser.addFlag('retain-build',
          abbr: 'b',
          help: 'Retain build when bumping major, minor, or patch.',
          defaultsTo: false);
