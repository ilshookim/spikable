import 'package:hive/hive.dart';

import 'app.dart';

/// 화면에서 공유하는 데이터를 가짐
class AppModel {
  /// 공용 타이틀
  String sharedTitle = 'Spilable';

  /// 공용 저장소
  final Box storage = AppGlobal.storage;

  void dispose() {

  }
}
