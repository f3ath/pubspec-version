import 'package:args/command_runner.dart';

class BumpVersionCommand<T> extends Command<T> {
  final name = 'bump';
  final description = 'Bumps the package version.';

  BumpVersionCommand(List<Command<T>> subcommands) {
    subcommands.forEach(addSubcommand);
  }
}
