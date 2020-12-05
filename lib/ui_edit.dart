
import 'app.dart';

class EditPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final Logger logger = Logger('EditPage');

  @override
  Widget build(BuildContext context) {
    // 공용 데이터에 접근하기 위해 모델을 활용
    final AppModel model = Provider.of<AppModel>(context, listen: false);
    final String kEditTitle = model.sharedTitle;
    // 언어 리소스에서 텍스트를 가져옴
    final AppLocale locale = AppLocale.of(context);
    final String kSave = locale.translate('save');

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(kEditTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            iconSize: 32.0,
            tooltip: kSave,
            onPressed: () {
                Navigator.pop(context, true);
            },
          ),
        ],
      ),
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
                    children: [
                      FlatButton(
                        child: Image.asset(
                          'assets/images/1.jpg', 
                          width: 60, 
                          height: 60,
                          fit: BoxFit.fitWidth,
                        ),
                        onPressed: () {
                          // nothing to do
                        }, 
                      ),
                      FlatButton(
                        child: Image.asset(
                          'assets/images/2.jpg', 
                          width: 60, 
                          height: 60,
                          fit: BoxFit.fitWidth,
                        ),
                        onPressed: () {
                          // nothing to do
                        }, 
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
