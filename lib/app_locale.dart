import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'app.dart';

/// 국가별 언어를 지원하도록 앱 로케일을 정의함
class AppLocale {
  /// 로깅
  final Logger logger = Logger('AppLocale');

  /// 기본 로케일
  final Locale locale;

  /// 생성자
  AppLocale(this.locale);

  /// 앱 로케일 프로바이더
  static AppLocale of(BuildContext context) =>
      Localizations.of<AppLocale>(context, AppLocale);

  /// 앱 로케일 딜리게이터
  static const LocalizationsDelegate<AppLocale> delegate = AppLocaleDelegate();

  /// 지원하는 국가별 언어를 정의한 제네릭
  Map<String, String> localizedStrings;

  /// 국가별 언어로 정의한 언어 파일에서 문자열을 로드함
  Future<bool> load() async {
    final String function = Trace.current().frames[0].member;
    bool succeed = true;
    try {
      String asset = 'assets/lang/${locale.languageCode}.json';

      // 언어 코드에 따른 언어 파일을 JSON 포맷으로 로드함
      String jsonString = await rootBundle.loadString(asset);

      // JSON 포맷을 제네릭으로 변환함
      Map<String, dynamic> jsonMap = json.decode(jsonString);

      // 국가별 언어를 정의한 제네릭으로 로드한 언어를 추가함
      localizedStrings = jsonMap.map((key, value) => MapEntry(key, '$value'));

      logger.info(
          '$function[$succeed]: asset=$asset, loadString=${jsonString.length}, '
          'jsonMap=${jsonMap.length}, localizedStrings=${localizedStrings.length}');
    } catch (exc) {
      succeed = false;
      logger.warning('$function[$succeed]: $exc');
    }
    return succeed;
  }

  /// 상수값에 해당하는 국가별 언어 문자열을 반환함
  String translate(String key) {
    // 미리 로드한 국가별 언어를 정의한 제네릭에서 상수값을 찾고 반환함
    return localizedStrings[key];
  }
}

/// 시스템을 위한 국가별 언어를 지원하도록 앱 로케일 딜리게이터를 정의함
class AppLocaleDelegate extends LocalizationsDelegate<AppLocale> {
  /// 생성자
  const AppLocaleDelegate();

  /// 지정한 로케일을 지원하는지 확인함
  @override
  bool isSupported(Locale locale) {
    return ['ko', 'en'].contains(locale.languageCode);
  }

  /// 지정한 로케일을 로드함
  @override
  Future<AppLocale> load(Locale locale) async {
    /// 로깅
    final Logger logger = Logger.root;
    final String function = Trace.current().frames[0].member;
    bool succeed = true;
    try {
      // 로케일 코드나 이름을 확인함
      final String localeName =
          locale.countryCode == null || locale.countryCode.isEmpty
              ? locale.languageCode
              : locale.toString();

      // 로케일 이름에 대한 표준 이름을 확인함
      final String canonicalLocaleName = Intl.canonicalizedLocale(localeName);

      // Intl 플러그인의 기본 로케일을 설정함
      Intl.defaultLocale = canonicalLocaleName;

      // 앱 로케일을 생성함
      AppLocale localizations = AppLocale(locale);

      // 앱 로케일을 로드함
      succeed = await localizations.load();

      logger.info('$function[$succeed]: '
          'localeName=$localeName, canonicalLocaleName=$canonicalLocaleName');

      return localizations;
    } catch (exc) {
      succeed = false;
      logger.warning('$function[$succeed]: $exc');
    }
    // 앱 로케일을 생성함
    AppLocale localizations = AppLocale(locale);
    return localizations;
  }

  /// Hot Reload를 할 때 앱 로케일을 다시 로드할 것인지 확인함
  @override
  bool shouldReload(AppLocaleDelegate old) => true;
}
