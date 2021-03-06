import 'package:flutter_music/baseImport.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

/// 网页浏览页
class WebViewPage extends StatefulWidget {
  String url;

  WebViewPage(this.url);

  @override
  State<StatefulWidget> createState() {
    return MyState(url);
  }
}

class MyState extends State<WebViewPage> {
  String url;

  MyState(this.url);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: CommonThemeData.get(),
      routes: {
        "/": (_) => new WebviewScaffold(
              url: url,
              appBar: new AppBar(
                title: Container(
                  child: Text(
                    'Flutter Music',
                    style: TextStyle(color: COLOR_YELLOW),
                  ),
                  alignment: Alignment.center,
                ),
              ),
            )
      },
    );
  }
}
