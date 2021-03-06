import 'package:html/parser.dart' show parse;
import 'package:cat_dog/modules/category/repository.dart';


getNewsFromUrl (String url,int page) async {
  String urlPage = "${url.replaceAll('.epi', '')}/trang$page.epi?loadmore=1";
  String result = await fetchNewsFromUrl(urlPage);
  if (result != '') {
    List<Object> data = new List();
    var document = parse(result);
    var elements = document
      .getElementsByTagName('body')[0]
      .getElementsByClassName('story');
    int i;
    int length = elements.length;
    for (i = 0; i < length; i++) {
      try {
        var element = elements[i];
        var tagLink = element.getElementsByClassName('story__link')[0];
        var tagHeading = element.getElementsByClassName('story__heading')[0];
        var tagSummary = element.getElementsByClassName('story__summary')[0];
        var tagImage = element.getElementsByTagName('img')[0];
        var tagMeta = element.getElementsByClassName('story__meta')[0];
        var item = {
          'url': tagLink.attributes['href'],
          'heading': tagHeading.innerHtml,
          'summary': tagSummary.innerHtml,
          'source': tagMeta.getElementsByClassName('source')[0].innerHtml,
          'time': tagMeta.getElementsByTagName('time')[0].attributes['datetime'],
          'image': tagImage.attributes['data-src']
        };
        data.add(item);
      } catch (err) {
        print(err);
      }
    }
    if (data.length > 0) {
      return data;
    }
  }
  return [];
}

getTopics (int page) async {
  try {
    String urlPage = "https://m.baomoi.com/chu-de/trang$page.epi?loadmore=1";
    String result = await fetchNewsFromUrl(urlPage);
    if (result != '') {
      List<dynamic> data = new List();
      var document = parse(result);
      var elements = document
        .getElementsByTagName('body')[0]
        .getElementsByClassName('topic-timeline');
      int i;
      int length = elements.length;
      for (i = 0; i < length; i++) {
        try {
          var item = parsetTopicItem(elements[i]);
          data.add(item);
        } catch (err) {
        }
      }
      if (data.length > 0) {
        return {
          'data': data
        };
      }
    }
  } catch (err) {
  }
  return {
    'data': []
  };
}

parsetTopicItem (element) {
  var tagTopic = element.getElementsByTagName('h2')[0].getElementsByTagName('a')[0];
  var storyTag = element.getElementsByClassName('story')[0];
  var tagSummary = storyTag.getElementsByClassName('story__summary')[0];
  var tagImage = storyTag.getElementsByTagName('img')[0];
  var tagMeta = storyTag.getElementsByClassName('story__meta')[0];
  return {
    'url': tagTopic.attributes['href'],
    'heading': tagTopic.innerHtml,
    'summary': tagSummary.innerHtml,
    'source': tagMeta.getElementsByClassName('source')[0].innerHtml,
    'time': tagMeta.getElementsByTagName('time')[0].attributes['datetime'],
    'image': tagImage.attributes['data-src']
  };
}
