import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'ui.dart';

class App extends StatelessWidget {
  /// 로깅
  final Logger logger = Logger('App');

  // 모바일 앱의 루트 위젯
  @override
  Widget build(BuildContext context) {
    final String function = Trace.current().frames[0].member;

    // 핫리로드를 할 때 로그레벨을 수정함
    Logger.root.level = Level.CONFIG;
    logger.info('$function: loggerLevel=${Logger.root.level.toString()}');

    // 앱을 시작함
    return MultiProvider(
      // 프로바이더를 시작함
      providers: [
        Provider<AppModel>(
          create: (context) => AppModel(),
          dispose: (context, model) => model.dispose(),
        ),
      ],
      // 프로바이더를 전역으로 사용하는 머터리얼 앱을 시작함
      child: Consumer<AppModel>(
        builder: (context, model, child) {

          // 테마를 변경하면 앱을 다시 빌드
          return ValueListenableBuilder<int>(
            valueListenable: AppGlobal.appRefreshNotifier,
            builder: (BuildContext context, int refresh, Widget child) {
              
              // 언어, 국가 코드를 로드함
              final String languageCode = AppGlobal.storage.get(AppGlobal.kLanguageCodeKey, defaultValue: 'ko');
              final String countryCode = AppGlobal.storage.get(AppGlobal.kCountryCodeKey, defaultValue: 'KR');
              logger.info('$function: ${AppGlobal.kLanguageCodeKey}=$languageCode, ${AppGlobal.kCountryCodeKey}=$countryCode');

              return MaterialApp(

                // 밝은 테마
                theme: ThemeData.light().copyWith(
                  accentColorBrightness: Brightness.light,
                  primaryColor: Colors.deepOrange,
                  accentIconTheme: IconThemeData(color: Colors.black),
                  floatingActionButtonTheme: FloatingActionButtonThemeData(
                    backgroundColor: Colors.deepOrange,
                  ),
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                // 어두운 테마
                darkTheme: ThemeData.dark().copyWith(
                  accentColorBrightness: Brightness.light,
                  accentIconTheme: IconThemeData(color: Colors.black),
                  floatingActionButtonTheme: FloatingActionButtonThemeData(
                    backgroundColor:  Colors.white,
                  ),
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                // 지정한 테마
                // default mode is 'system' > light mode or dark mode
                themeMode: AppGlobal.themeMode,

                // 기본 로케일을 지정함
                locale: Locale(languageCode, countryCode),
                // 국어, 영어를 지원함
                supportedLocales: [
                  Locale('ko', 'KR'),
                  Locale('en', 'US'),
                ],
                // 국가별 언어를 지원하는 로컬라이제이션을 설정함
                localizationsDelegates: [
                  AppLocale.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  DefaultCupertinoLocalizations.delegate,
                ],
                // 시스템에서 지원하는 언어 중에서 첫 번째 언어를 사용함
                localeResolutionCallback: (locale, supportedLocales) {
                  for (var supportedLocale in supportedLocales) {
                    if (locale != null &&
                        locale.languageCode != null &&
                        locale.countryCode != null &&
                        supportedLocale.languageCode == locale.languageCode &&
                        supportedLocale.countryCode == locale.countryCode) {
                      return supportedLocale;
                    }
                  }
                  return supportedLocales.first;
                },

                // 시스템에서 지원하는 언어를 사용해 앱 타이틀을 설정함
                onGenerateTitle: (BuildContext context) =>
                    AppLocale.of(context).translate('appTitle'),
                home: HomePage(),

                // 디버그 베너를 감춤
                debugShowCheckedModeBanner: false,
              );
            },
          );

        }
      ),
    );
  }
}
