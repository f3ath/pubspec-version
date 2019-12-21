import 'package:args/command_runner.dart';

class CommandContainer<T> extends Command<T> {
  @override
  final String name;
  @override
  final String description;

  CommandContainer(this.name, this.description, List<Command<T>> subcommands) {
    subcommands.forEach(addSubcommand);
  }
}
