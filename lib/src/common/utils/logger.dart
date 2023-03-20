import 'package:talker_flutter/talker_flutter.dart';

final talker = Talker(
  observers: [],
  settings: TalkerSettings(
    enabled: true,
    useHistory: true,
    maxHistoryItems: 100,
    useConsoleLogs: true,
  ),
  logger: TalkerLogger(
    formater: const ExtendedLoggerFormatter(),
    settings: TalkerLoggerSettings(
      colors: {
        LogLevel.info: AnsiPen()..cyan(),
        LogLevel.good: AnsiPen()..green(),
      },
    ),
  ),
);
