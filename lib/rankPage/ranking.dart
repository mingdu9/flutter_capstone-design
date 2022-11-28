import 'package:capstone1/providers/stock.dart';
import 'package:capstone1/providers/user.dart';
import 'package:capstone1/searchPage/stockDetail/stockRoot.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher_string.dart';

final auth = FirebaseAuth.instance;
openBrowser(String url) async {
  if(await canLaunchUrlString(url)){
    launchUrlString(url, mode: LaunchMode.externalApplication);
  }else{
    print('can\'t open link');
  }
}

class Ranking extends StatefulWidget {
  const Ranking({Key? key}) : super(key: key);

  @override
  State<Ranking> createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  final GlobalKey _myRankKey = GlobalKey();

  _getSize() {
    if (_myRankKey.currentContext != null) {
      final RenderBox renderBox =
          _myRankKey.currentContext!.findRenderObject() as RenderBox;
      Size size = renderBox.size;
      return size.height;
    }
  }

  double? rankHeight = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        rankHeight = _getSize();
      });
    });
    context.read<UserProvider>().getRank();
  }

  @override
  Widget build(BuildContext context) {
    return Stack( children: [
      ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(
            height: rankHeight,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '많이 본 뉴스',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        letterSpacing: -1.5),
                  ),
                ),
                IconButton(
                  onPressed: () => context
                      .read<StockProvider>()
                      .updateNewsList(),
                  icon: Icon(
                    Icons.refresh_rounded,
                    color: Colors.black, size: 30,
                  ),
                  style: IconButton.styleFrom(

                  ),
                ),
              ],
            ),
          ),
          TopCarousel(),
          TopRank(),
        ],
      ),
      Positioned(
        top: 10,
        left: 0,
        right: 0,
        child: MyRank(key: _myRankKey),
      )
    ]);
  }
}


Widget loadingMyRank(Size size) {
  return Shimmer.fromColors(
    baseColor: Color(0xFFE0E0E0),
    highlightColor: Color(0xFFF5F5F5),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 23, width: size.width * 0.1,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: Colors.white
              ),
            ),
            Expanded(
                child: Container(
                  height: 23, width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      color: Colors.white
                  ),
                )),
            Container(
              height: 23, width: size.width * 0.1,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: Colors.white
              ),
            ),
            Text('',
                style: TextStyle(fontSize: 22, letterSpacing: -1.2))
          ]),
    ),
  );
}


class MyRank extends StatefulWidget {
  const MyRank({Key? key}) : super(key: key);

  @override
  State<MyRank> createState() => _MyRankState();
}

class _MyRankState extends State<MyRank> {

  int findRank(List<dynamic> list, String name){
    int index = 0;
    for(int i=0;i<list.length;i++){
      if(list[i]['name'] == name) index = i;
    }
    return index+1;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
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
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '내 순위',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 23, letterSpacing: -1.2),
          ),
          Divider(
            thickness: 1.0,
            color: Colors.grey.withOpacity(0.5),
          ),
          (context.watch<UserProvider>().loading == true ? loadingMyRank(MediaQuery.of(context).size) :
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 5),
                    child: Text(
                      '${findRank(context.watch<UserProvider>().userRanks, auth.currentUser!.displayName ?? ' ')}. ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                          letterSpacing: -1.2),
                    ),
                  ),
                  Expanded(
                      child: Text(auth.currentUser!.displayName ?? ' ',
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 18, letterSpacing: -1.2),
                      )),
                  Text('${context.watch<UserProvider>().realizedProfit} %',
                      style: TextStyle(fontSize: 22, letterSpacing: -1.2))
                ]),
          ))
        ],
      ),
    );
  }
}

class TopRank extends StatelessWidget {
  const TopRank({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shadowedBox = BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 7,
          offset: const Offset(4,8),
        )
      ],
      borderRadius: BorderRadius.circular(8.0),
    );
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: shadowedBox,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'top 10',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 30, letterSpacing: -1.2),
          ),
          Divider(
            thickness: 1.0,
          ),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: context.watch<UserProvider>().userRanks.length > 10 ? 10 :
                context.watch<UserProvider>().userRanks.length,
              itemBuilder: (c, i) {
                return Column(
                  children: [Rank(count: i), Divider(indent: 3,)],
                );
              })
        ],
      ),
    );
  }
}

class Rank extends StatelessWidget {
  const Rank({Key? key, this.count}) : super(key: key);
  final count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          margin: EdgeInsets.only(right: 5),
          child: Text(
            '${count + 1}. ',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 23, letterSpacing: -1.2),
          ),
        ),
        Expanded(
            child: Text(
          '${context.watch<UserProvider>().userRanks[count]['name']}',
          style: TextStyle(fontSize: 18, letterSpacing: -1.2),
        )),
        Text('${context.watch<UserProvider>().userRanks[count]['realizedProfit']}%', style: TextStyle(fontSize: 22, letterSpacing: -1.2))
      ]),
    );
  }
}

class TopCarousel extends StatefulWidget {
  const TopCarousel({Key? key}) : super(key: key);

  @override
  State<TopCarousel> createState() => _TopCarouselState();
}

class _TopCarouselState extends State<TopCarousel> {
  List<String> imgList = [];
  List<String> titleList = [];
  List<String> urlList = [];
  List<Widget> imageSliders = [];

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  getData() async {
    await context.read<StockProvider>().getNewsList();
    for(int i=0;i<5;i++){
      setState(() {
        imgList.add(context.read<StockProvider>().seenNewsList[i]['img']);
        titleList.add(context.read<StockProvider>().seenNewsList[i]['title']);
        urlList.add(context.read<StockProvider>().seenNewsList[i]['url']);
      });
    }
    setState(() {
      imageSliders = imgList.map((item) =>
          Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: GestureDetector(
                onTap: (){
                  openBrowser(urlList[imgList.indexOf(item)]);
                },
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(13.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(
                          item, fit: BoxFit.cover, width: 1000.0,
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress){
                            if (loadingProgress == null) return child;
                            return Shimmer.fromColors(
                                baseColor: Color(0xFFE0E0E0),
                                highlightColor: Color(0xFFF5F5F5),
                                child: Container(
                                  width: 1000, height: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white, borderRadius: BorderRadius.circular(13)
                                  ),
                                ));
                          },
                        ),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: const [
                                    Color.fromARGB(200, 0, 0, 0),
                                    Color.fromARGB(0, 0, 0, 0)
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                              child: Text(
                                titleList[imgList.indexOf(item)],
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    letterSpacing: -1.1),
                              )),
                        ),
                      ],
                    )),
              ),
            ),
          )).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 2.0,
        ),
        items: imageSliders,
      ),
    );
  }
}
