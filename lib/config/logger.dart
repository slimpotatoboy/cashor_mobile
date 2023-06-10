import 'package:discord_logger/discord_logger.dart';

class DiscordLog {
  final discord = DiscordLogger.instance;
  void log(String message) {
    discord.sendMessage(message);
  }
}
