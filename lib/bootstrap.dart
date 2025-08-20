import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

@immutable
class ApplicationBootstrap {
  const ApplicationBootstrap._();

  static final _log = Logger('AppBootstrap');

  static Future<void> run({
    required FutureOr<Widget> Function() builder,
  }) async {
    final errorHandler = _ErrorHandler();

    await runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();

        _setupLogging();

        errorHandler.setupErrorHandling();

        if (kDebugMode) {
          _setupPerformanceMonitoring();
        }

        _log.info('Bootstrap complete. Running app...');
        runApp(await builder());
      },
      (error, stackTrace) => errorHandler.handleError(
        'Unhandled error caught by Zone',
        error,
        stackTrace,
      ),
    );
  }

  static void _setupLogging() {
    Logger.root.level = kDebugMode ? Level.ALL : Level.WARNING;
    Logger.root.onRecord.listen((record) {
      developer.log(
        record.message,
        time: record.time,
        sequenceNumber: record.sequenceNumber,
        level: record.level.value,
        name: record.loggerName,
        zone: record.zone,
        error: record.error,
        stackTrace: record.stackTrace,
      );
    });
    _log.info('Logging initialized.');
  }

  static void _setupPerformanceMonitoring() {
    WidgetsBinding.instance.addTimingsCallback((timings) {
      for (final timing in timings) {
        if (timing.totalSpan > const Duration(milliseconds: 17)) {
          _log.warning(
            'Janky frame detected! '
            'Took ${timing.totalSpan.inMilliseconds}ms to render.',
          );
        }
      }
    });
    _log.info('Frame performance monitor enabled.');
  }
}

class _ErrorHandler {
  final _log = Logger('ErrorHandler');

  void setupErrorHandling() {
    FlutterError.onError = (details) {
      handleError(
        'FlutterError caught',
        details.exception,
        details.stack,
      );
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      handleError('PlatformDispatcher error caught', error, stack);
      return true;
    };
    _log.info('Global error handlers set up.');
  }

  void handleError(String context, Object error, StackTrace? stackTrace) {
    _log.severe(context, error, stackTrace);
  }
}
