import 'package:args/command_runner.dart';

class BumpVersion<T> extends Command<T> {
  final name = 'bump';
  final description = 'Bumps the package version.';

  BumpVersion(List<Command<T>> subcommands) {
    subcommands.forEach(addSubcommand);
  }
}
