import 'package:flutter/material.dart';

import 'app.dart';
import 'ui.dart';

/// 화면 구성 예시
/// 
/// 기본 화면
/// * 페이지 목록 > 이미지, 제목, 수정
/// * 페이지 추가
/// 
/// 페이지 화면
/// * 페이지 구성 > 제목, 저장
/// * 페이지 항목 > 이미지, 섬네일
/// 
/// 드로우 메뉴
/// * 로고와 제목
/// * 버전
/// 
class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final Logger logger = Logger('HomePage');

  @override
  Widget build(BuildContext context) {
    // 언어 리소스에서 텍스트를 가져옴
    final AppLocale locale = AppLocale.of(context);
    final String kAppTitle = locale.translate('appTitle');
    final String kDarkMode = locale.translate('darkMode');
    final String kLightMode = locale.translate('lightMode');
    final String kModify = locale.translate('modify');
    final String kAdd = locale.translate('add');
    final String kSample = 'sample';

    return Scaffold(
      key: scaffoldKey,
      /// 드로우 페이지
      drawer: DrawerPage(),
      appBar: AppBar(
        /// 메뉴 버튼
        leading: IconButton(
          icon: Icon(Icons.sort),
          onPressed: () {
            scaffoldKey.currentState.openDrawer();
          },
        ),
        title: Text(kAppTitle),
        actions: [
          /// 테마 변경 버튼 : 어두운 테마 <-> 밝은 테마
          IconButton(
            icon: AppGlobal.isDarkMode ? Icon(Icons.brightness_7) : Icon(Icons.brightness_4),
            iconSize: 32.0,
            tooltip: AppGlobal.isDarkMode ? kLightMode : kDarkMode,
            onPressed: () {
              AppGlobal.toggleThemeMode(refresh: true);
            },
          ),
        ],
      ),
      /// 페이지 목록
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(8.0),
          children: [
            /// 페이지 항목
            Card(
              elevation: 3.0,
              child: Column(
                children: [
                  Image.asset('assets/images/1.jpg'),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      /// 편집 버튼
                      Tooltip(
                        message: kModify, 
                        child: FlatButton.icon(
                          icon: Icon(Icons.mode_edit), 
                          label: Text(kSample),
                          onPressed: () {
                            /// 편집 화면으로 전환
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => EditPage(),
                              ),
                            );
                          }, 
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      /// 추가 버튼
      floatingActionButton: FloatingActionButton.extended(
        label: Text(kAdd),
        icon: Icon(Icons.add),
        onPressed: () {
          /// 편집 페이지로 전환
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => EditPage(),
            ),
          );
        },
      ),
    );
  }
}
