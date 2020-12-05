
import 'app.dart';

class DrawerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 언어 리소스에서 텍스트를 가져옴
    final AppLocale locale = AppLocale.of(context);
    final String kAppTitle = locale.translate('appTitle');
    final String kAppVersion = locale.translate('appVersion');
    final String kVersion = locale.translate('version');
    final String kDebug = locale.translate('debug');
    final String kThisVersion = AppGlobal.debugMode
        ? '$kDebug $kVersion $kAppVersion'
        : '$kVersion $kAppVersion';

    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: ListView(
                  children: [
                    /// 드로워 헤더
                    DrawerHeader(
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/0.png'),
                        ),
                      ),
                      child: Stack(
                        children: [
                          /// 앱 이름
                          Positioned(
                            bottom: 12.0,
                            left: 16.0,
                            child: Text(kAppTitle,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            /// 버전
            Container(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.help),
                        title: Text('$kAppTitle - $kThisVersion'),
                        onTap: () {
                          showAboutDialog(
                            context: context,
                            applicationName: kAppTitle,
                            applicationVersion: kAppVersion,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
