import 'package:args/command_runner.dart';

class CommandContainer<T> extends Command<T> {
  final String name;
  final String description;

  CommandContainer(this.name, this.description, List<Command<T>> subcommands) {
    subcommands.forEach(addSubcommand);
  }
}
