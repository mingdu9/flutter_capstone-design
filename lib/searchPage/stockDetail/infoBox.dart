import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone1/providers/stock.dart';
import 'package:url_launcher/url_launcher_string.dart';



openBrowser(String url) async {
  if(await canLaunchUrlString(url)){
    launchUrlString(url, mode: LaunchMode.externalApplication);
  }else{
    print('can\'t launch');
  }
}

class NewsBox extends StatefulWidget {
  const NewsBox({Key? key, this.ticker}) : super(key: key);
  final ticker;

  @override
  State<NewsBox> createState() => _NewsBoxState();
}

class _NewsBoxState extends State<NewsBox> {

  @override
  void initState() {
    super.initState();
    context.read<StorePrice>().getNewsByTicker(widget.ticker);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20, left: 18, right: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(4, 8),
          )
        ],
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '종목 뉴스',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.2,
                    fontSize: 26,
                  ),
                ),
                IconButton(
                    onPressed: () => context
                        .read<StorePrice>()
                        .getNewsByTicker(widget.ticker),
                    icon: Icon(
                      Icons.refresh_rounded,
                      color: Colors.black,
                    ))
              ],
            ),
            Divider(
              thickness: 0.8,
              color: Colors.grey.withOpacity(0.8),
            ),
            context.watch<StorePrice>().newsList.isNotEmpty ? ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (c, i) {
                return News(
                  index: i,
                );
              },
            )
                : Center(child: Text('없음'),),
          ],
        ),
      ),
    );
  }
}

class News extends StatefulWidget {
  const News({Key? key, this.index}) : super(key: key);
  final index;

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openBrowser(context.read<StorePrice>().newsList[widget.index]['link']),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context
                            .watch<StorePrice>()
                            .newsList[widget.index]['title']
                            .replaceAll('', '\u{200B}'),
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: TextStyle(fontSize: 17, letterSpacing: -0.4),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        context.watch<StorePrice>().newsList[widget.index]
                        ['date'],
                        style: TextStyle(
                          fontSize: 13,
                          letterSpacing: -0.4,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                    flex: 4,
                    child: Text(
                      context.watch<StorePrice>().newsList[widget.index]
                      ['source'],
                      style: TextStyle(fontSize: 15, letterSpacing: -0.8),
                    ))
              ],
            ),
            Divider(
              thickness: 0.5,
              color: Colors.grey.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}

class NoticeBox extends StatefulWidget {
  const NoticeBox({Key? key, this.ticker}) : super(key: key);
  final ticker;

  @override
  State<NoticeBox> createState() => _NoticeBoxState();
}

class _NoticeBoxState extends State<NoticeBox> {
  @override
  void initState() {
    super.initState();
    context.read<StorePrice>().getNoticeByTicker(widget.ticker);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20, left: 18, right: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(4, 8),
          )
        ],
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '공시 정보',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.2,
                    fontSize: 26,
                  ),
                ),
                IconButton(
                    onPressed: () => context
                        .read<StorePrice>()
                        .getNoticeByTicker(widget.ticker),
                    icon: Icon(
                      Icons.refresh_rounded,
                      color: Colors.black,
                    ))
              ],
            ),
            Divider(
              thickness: 0.8,
              color: Colors.grey.withOpacity(0.8),
            ),
            context.watch<StorePrice>().noticeList.isNotEmpty
                ? ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (c, i) {
                return Notice(
                  index: i,
                );
              },
            )
                : Center(
              child: Text('없음'),
            ),
          ],
        ),
      ),
    );
  }
}

class Notice extends StatefulWidget {
  const Notice({Key? key, this.index}) : super(key: key);
  final index;

  @override
  State<Notice> createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openBrowser(context.read<StorePrice>().noticeList[widget.index]['link']),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context
                            .watch<StorePrice>()
                            .noticeList[widget.index]['title']
                            .replaceAll('', '\u{200B}'),
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: TextStyle(fontSize: 17, letterSpacing: -0.4),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        context.watch<StorePrice>().noticeList[widget.index]
                        ['date'],
                        style: TextStyle(
                          fontSize: 13,
                          letterSpacing: -0.4,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                    flex: 4,
                    child: Text(
                      context.watch<StorePrice>().noticeList[widget.index]
                      ['source'],
                      style: TextStyle(fontSize: 15, letterSpacing: -0.8),
                    ))
              ],
            ),
            Divider(
              thickness: 0.5,
              color: Colors.grey.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}
