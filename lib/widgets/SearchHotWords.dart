import 'package:flutter_music/baseImport.dart';
import 'package:flutter_music/entitesImport.dart';

class SearchHotWords extends StatefulWidget {
  OnHotKeyClicked onClick;

  SearchHotWords(this.onClick);

  @override
  State<StatefulWidget> createState() {
    return MyState(onClick);
  }
}

class MyState extends State<SearchHotWords> {
  List<HotKeyItem> hotKeyList = [];
  OnHotKeyClicked onClick;

  MyState(this.onClick) {
    getData();
  }

  getData() async {
    Response response = await Api.getHotKeyWord();
    if (response == null) {
      MyToast.show('搜索热词请求出错');
    } else {
      HotKeyResp resp = HotKeyResp.fromJson(json.decode(response.data));
      if (Api.isOk(resp.code)) {
        // 随机范围获取10条
        if (resp.data.hotkey.length > 9) {
          var range =
              await MyUtils.getRandomIntRange(resp.data.hotkey.length - 1, 10);
          setState(() {
            hotKeyList = resp.data.hotkey.sublist(range[0], range[1] + 1);
          });
        } else {
          setState(() {
            hotKeyList = resp.data.hotkey;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      alignment: Alignment.topLeft,
      child: Wrap(
        runSpacing: 10.0,
        spacing: 20.0,
        children: _getWordsItem(),
      ),
    ));
  }

  List<Widget> _getWordsItem() {
    var list = <Widget>[];
    hotKeyList.forEach((item) {
      list.add(GestureDetector(
        onTap: () {
          onClick(item);
        },
        child: Material(
          color: COLOR_GRAY,
          borderRadius: BorderRadius.circular(6.0),
          child: Container(
            padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            child: Text(
              item.k,
              style: TextStyle(
                  color: COLOR_TRANSLUCENT_WHITE_ZERO_POINT_THREE,
                  fontSize: 14.0),
            ),
          ),
        ),
      ));
    });
    return list;
  }
}
