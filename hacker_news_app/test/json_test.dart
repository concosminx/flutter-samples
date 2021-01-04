import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as json;
import 'package:hackernewsapp/src/article.dart';

void main() {
  test("parse topstories", () {
    const jsonString =
        '[ 25024639, 25025363, 25012900, 25024224, 25025429, 25022665, 25023986, 25021261, 25023938, 25025189, 25025511, 25025066]';

    expect(parseTopStories(jsonString).first, 25024639);
  }, skip: true);

  test("parse item", () {
    const jsonString = """
        {"by":"dhouston","descendants":71,"id":8863,"kids":[9224,8917,8952,8958,8884,8887,8869,8940,8908,9005,8873,9671,9067,9055,8865,8881,8872,8955,10403,8903,8928,9125,8998,8901,8902,8907,8894,8870,8878,8980,8934,8943,8876],"score":104,"time":1175714200,"title":"My YC app: Dropbox - Throw away your USB drive","type":"story","url":"http://www.getdropbox.com/u/2/screencast.html"}
        """;
    expect(parseArticle(jsonString).by, 'dhouston');
  }, skip: true);

  //not great, maybe in integration testing
  test("parse item over network", () async {
    final url = 'https://hacker-news.firebaseio.com/v0/topstories.json';
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final idList = json.jsonDecode(res.body);
      if (idList.isNotEmpty) {
        final itemResponse = await http.get(
            'https://hacker-news.firebaseio.com/v0/item/${idList.first}.json');
        if (itemResponse.statusCode == 200) {
          expect(parseArticle(itemResponse.body).by, isNotNull);
        }
      }
    }
  }, skip : true);
}
