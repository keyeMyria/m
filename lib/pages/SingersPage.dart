import 'package:flutter_music/baseImport.dart';
import 'package:flutter_music/entitesImport.dart';
import 'package:flutter_music/widgets/SingerItem.dart';
import 'package:flutter_music/widgets/SingersPageIndexItem.dart';
/// 歌手页
class SingersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyState();
  }
}

class MyState extends State<SingersPage> {
  List<Singer> singerList = [];
  var indexList = []; // 右侧索引

  MyState() {
    getData();
  }

  getData() async {
    Response response = await Api.getSingerList();
    if (response == null) {
      MyToast.show('歌手请求出错');
    } else {
      SingersResp resp = SingersResp.fromJson(json.decode(response.data));
      if (Api.isOk(resp.code)) {
        List<Singer> tempSingerList = [];
        var tempIndexList = [];

        // 前10个作为热门
        tempSingerList.add(Singer()
          ..Fsinger_name = '热'
          ..isHead = true);
        tempIndexList.add('热');
        resp.data.list.forEach((item) {
          if (tempSingerList.length <= 10) {
            tempSingerList.add(item);
          }
        });
        // 排序
        resp.data.list.sort((a, b) {
          return a.Findex.compareTo(b.Findex);
        });
        // 分组
        var pre = '';
        resp.data.list.forEach((item) {
          if (pre != item.Findex) {
            pre = item.Findex;
            // 加组头
            var singer = Singer()
              ..Fsinger_name = item.Findex
              ..isHead = true;
            tempSingerList.add(singer);
            tempSingerList.add(item);
            tempIndexList.add(item.Findex);
          } else {
            tempSingerList.add(item);
          }
        });
        setState(() {
          singerList = tempSingerList;
          indexList = tempIndexList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // 列表
        ListView.builder(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
            itemCount: singerList.length,
            itemBuilder: (context, index) {
              var singer = singerList[index];
              return SingerItem(singer);
            }),
        // 悬停头
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            '热门',
            style: TextStyle(
              fontSize: 12.0,
              color: COLOR_TRANSLUCENT_WHITE_ZERO_POINT_FIVE,
            ),
          ),
          height: 30.0,
          color: Color(0xFF333333),
        ),
        // 右侧索引栏
        Container(
          alignment: Alignment.centerRight,
          child: Container(
            width: 18.0,
            height: indexList.length * 18.0 + 40,
            child: Material(
              borderRadius: BorderRadius.circular(9.0),
              color: COLOR_TRANSLUCENT_BLACK_ZERO_POINT_EIGHT,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: getIndexListWidgets(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> getIndexListWidgets() {
    var list = <Widget>[];
    indexList.forEach((text) {
      list.add(SingersPageIndexItem(false, text));
    });
    return list;
  }
}
