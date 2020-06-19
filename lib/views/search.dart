import 'package:flutter/material.dart';


import 'package:proje1/views/model.dart';
import 'package:proje1/views/searchvideo.dart';
import 'package:proje1/views/videoscreen.dart';
import 'package:proje1/views/api_services.dart';
import 'package:firebase_admob/firebase_admob.dart';

class SearchScreen extends StatefulWidget {
  @override
   final String data;
   SearchScreen({
    Key key,
    @required this.data,
  }) : super(key: key);
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Channel _channel;
  bool _isLoading = false;
  BannerAd myBanner;
  List<VideoSearch> moreVideos;

  BannerAd buildBannerAd() {
    return BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            myBanner..show();
          }
        });
  }

  BannerAd buildLargeBannerAd() {
    return BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.largeBanner,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            myBanner
              ..show(
                  anchorType: AnchorType.top,
                  anchorOffset: MediaQuery.of(context).size.height * 0.15);
          }
        });
  }
 
   

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    myBanner = buildBannerAd()..load();
    _loadMoreVideos();
  }
  void dispose() {
    myBanner.dispose();
    setState(() {
      moreVideos.clear();
    });
    super.dispose();
  }


 
  _buildVideo(VideoSearch video) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoScreen(id: video.id,url:video.id,title:video.title),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        padding: EdgeInsets.all(10.0),
        height: 140.0,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Image(
              width: 150.0,
              image: NetworkImage(video.thumbnailUrl),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Text(
                video.title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _loadMoreVideos() async {
   
    _isLoading = false;
     List<VideoSearch> newmoreVideos = await APIService.instance
        .fetchVideosSearch(video:widget.data);
     setState(() {
       moreVideos=newmoreVideos;
     });

    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: new Center(child: new Text(widget.data+" Arama Sonucu", textAlign: TextAlign.center)),
        
      ),
      body: _channel == null
          ? NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollDetails) {
                return false;
              },
              child: ListView.builder(
                itemCount:20,
                itemBuilder: (BuildContext context, int index) {
                  VideoSearch video = moreVideos[index];
                  return _buildVideo(video);
                },
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor, // Red
                ),
              ),
            ),
    );
  }
}