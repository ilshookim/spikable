import 'app.dart';
import 'ui.dart';

/// 앱이 시작하는 진입점을 정의함
void main() async {
  // 앱을 준비하고
  await prepareApp();

  // 앱을 시작함
  runApp(App());
}

/// 앱을 준비
Future<bool> prepareApp() async {
  // 함수명을 읽음
  final String function = Trace.current().frames[0].member;
  bool succeed = true;
  try {
    // 플러터 엔진과 위젯의 바인딩을 미리 완료함
    WidgetsFlutterBinding.ensureInitialized();

    // 세로(portraitUp) 화면만을 사용함 (가로 화면을 사용하지 않음)
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // 로깅을 시작함
    final bool logger = AppGlobal.initLogger();

    // 로컬 스토리지를 시작함
    final bool storage = await AppGlobal.initStorage();

    AppGlobal.logger.info('$function[$succeed]: logger=$logger, storage=$storage');
  } catch (exc) {
    succeed = false;
    AppGlobal.logger.warning('$function: $exc');
  }
  return succeed;
}
