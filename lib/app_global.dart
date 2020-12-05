import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stack_trace/stack_trace.dart';

/// 글로벌 상수와 함수
class AppGlobal {
  /// 애플리케이션 상수
  static const String kAppTitle = 'Spikable';
  static const String kAppVersion = '1.0.0';

  /// 스토리지 상수
  static const String kDefaultStorageName = 'default';

  /// 로케일 상수
  static const String kLanguageCodeKey = 'languageCode';
  static const String kCountryCodeKey = 'countryCode';

  /// 디버그, 릴리즈, 프로파일 모드를 구분함
  static bool get debugMode => kDebugMode;
  static bool get releaseMode => kReleaseMode;
  static bool get profileMode => kProfileMode;

  /// 앱을 다시 고침
  static final ValueNotifier<int> appRefreshNotifier = ValueNotifier(refreshNow());
  static int refreshNow() { return DateTime.now().millisecondsSinceEpoch; }
  static void refreshApp() { appRefreshNotifier.value = refreshNow(); }

  /// 로깅
  static Logger logger = Logger('AppGlobal');

  /// 로깅을 시작함
  static bool initLogger({Level level = Level.ALL}) {
    final String function = Trace.current().frames[0].member;
    bool succeed = true;
    try {
      // 로그 레벨을 지정함
      Logger.root.level = level;

      // 로그 출력을 정의함
      Logger.root.onRecord.listen((record) {
        print('[${record.time}][${record.level.name}] ${record.message}');
      });
    } catch (exc) {
      succeed = false;
      logger.warning('$function: $exc');
    } finally {
      logger.info('$function[$succeed]: level=${logger.level}');
    }
    return succeed;
  }

  /// 테마
  static ThemeMode themeMode = ThemeMode.system;

  /// 테마를 변경함
  static ThemeMode toggleThemeMode({bool refresh = true}) {
  final String function = Trace.current().frames[0].member;
    try {
      final String function = Trace.current().frames[0].member;
      final ThemeMode older = themeMode;
      final ThemeMode newly = (themeMode == ThemeMode.light || themeMode == ThemeMode.system)
          ? ThemeMode.dark
          : ThemeMode.light;
      themeMode = newly;
      logger.info('$function: old=$older, new=$newly');
    } catch (exc) {
      logger.warning('$function: $exc');
    } finally {
      if (refresh) refreshApp();
    }
    return themeMode;
  }

  /// 어두운 테마인지 확인함
  static bool get isDarkMode => themeMode == ThemeMode.dark;
  /// 어두운 테마인지 시스템 상태를 확인함
  static bool get isSystemDarkMode =>
      SchedulerBinding.instance.window.platformBrightness == Brightness.dark;

  /// 로컬 스토리지
  static Box storage;
  static String storagePath = '.\\';

  /// 로컬 스토리지를 시작함
  static Future<bool> initStorage() async {
    final String function = Trace.current().frames[0].member;
    bool succeed = true;
    try {
      // 웹에서 초기화 작업을 생략함
      if (!kIsWeb) {
        if (Platform.isWindows) {
          // 윈도우에서 아직 지원 안 함 @200328: getApplicationDocumentsDirectory()
          final String appPath = '.\\';
          storagePath = appPath;
          Hive.init(storagePath);
        } else {
          // 맥OS, 안드로이드, 아이폰에서 실험함
          final Directory appDir = await getApplicationDocumentsDirectory();
          storagePath = appDir.path;
          Hive.init(storagePath);
          // 리눅스에서 미실험: getApplicationDocumentsDirectory()
        }
      }

      // 로컬 스토리지에서 기본 박스를 오픈하고 글로벌 스토리지에 저장함
      final Box box = await Hive.openBox(AppGlobal.kDefaultStorageName);
      if (box == null)
        throw Exception('$function: '
            'name=${AppGlobal.kDefaultStorageName}, box=$box, storagePath=$storagePath');
      AppGlobal.storage = box;
    } catch (exc) {
      succeed = false;
      logger.warning('$function: $exc');
    } finally {
      logger.info(
          '$function[$succeed]: box=${AppGlobal.storage?.name}, storagePath=$storagePath');
    }
    return succeed;
  }
}
