import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:firebase_admob/firebase_admob.dart';
class VideoScreen extends StatefulWidget {

  final String id;
  final String url;
  final String title;

  VideoScreen({this.id,this.url,this.title});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  
  YoutubePlayerController _controller;
  BannerAd myBanner;

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
    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    );
  }
  void dispose() {
    myBanner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Center(child: new Text(widget.title, textAlign: TextAlign.center)),
        backgroundColor: Colors.red[900],
      ),
      body:Container(
       child: Column(
            children:<Widget>[
              YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                onReady: () {
                  print('Player is ready.');
                },
              ),
              new GestureDetector(
                onTap:(){ share(context,widget.title,widget.url); } ,
                  child: Card(
                    color: Colors.red[900],
                      margin: const EdgeInsets.only(top: 50.0),
                      child: Padding(
                      padding: EdgeInsets.all(36.0),
                      child: Text("PAYLAŞ",style: TextStyle(fontSize: 15,color: Colors.white,fontWeight:FontWeight.w800)),
                  ),
                ), 
              ),
          ],
        ),
        
      ),
    );
  }
  void share(BuildContext context,String title,String url){
    final String text=title+" "+"https://www.youtube.com/watch?v="+url;
    final RenderBox box=context.findRenderObject();
    
    Share.share(text,sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}