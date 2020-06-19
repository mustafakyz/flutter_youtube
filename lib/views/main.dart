import 'package:flutter/material.dart';
import 'package:proje1/views/channelmodel.dart';
import 'package:proje1/views/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:proje1/views/search.dart';

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}
 Future<List<ChannelModel>> getData() async {
    final responseData = await http.get("http://webimkan.com/yemektarifi.php");

    if(responseData.statusCode == 200){
      List responseJson = json.decode(responseData.body);
      return responseJson.map((m) => new ChannelModel.fromJson(m)).toList();
    }
    else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
      throw Exception('Failed to load album');
    }
}

class MainScreenState extends State<MainScreen> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final SnackBar snackBar = const SnackBar(content: Text('Showing Snackbar'));
  Future<List<ChannelModel>> futureChannelModel;
  final searchController = TextEditingController();

   
 
  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
   
    setState(() {
      futureChannelModel = getData();
    });
    
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    setState(() {
      futureChannelModel = getData();
    });
    
  }
  void arama(){
    var deger=this.searchController.text;
    Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              SearchScreen(data: deger),
        ),
    );
  }
  void openPage(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(
    builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Next page'),
        ),
        body: const Center(
          child: Text(
            'This is the next page',
            style: TextStyle(fontSize: 24),
          ),
        ),
      );
    },
  ));
}
Widget projectWidget() {
  return FutureBuilder<List<ChannelModel>>(
    future:futureChannelModel,
    builder: (context, projectSnap) {
      if (projectSnap.connectionState == ConnectionState.done && projectSnap.hasData == null) {

        return Container();
      }
      else{
           return
           Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: <Widget>[
                   Expanded(
                     flex: 0,
                     child:Container(
                       child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: 
                              TextFormField(
                                
                                controller: searchController,
                                decoration: const InputDecoration(
                                  hintText: 'Videolarda Ara',
                                  contentPadding: const EdgeInsets.all(15.0),
                                  hintStyle: TextStyle(
                                        color: Color(0xFFF00),
                                        fontSize: 20),
                                ),
                                
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: RaisedButton(  
                                padding: const EdgeInsets.all(0.0),
                                textColor: Colors.white,
                                onPressed: () {arama(); },
                                child: Container(
                                   
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: <Color>[
                                          Color(0xFF0D47A1),
                                          Color(0xFF0D47A1),
                                          Color(0xFF0D47A1),
                                        ],
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(12.0),
                                    child:
                                        const Text('Video Ara', style: TextStyle(fontSize: 20)),
                                  ),
                            ),
                            ),
                          ],
                       ),
                            
                     )
                    
                   ),
                   Expanded(
                 child: ListView.builder(
                    itemCount: projectSnap.data.length,
                    itemBuilder: (context, index) {
                      ChannelModel projects = projectSnap.data[index];
                      return Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.star,color: Colors.red),
                            title: Text(projects.name),
                            onTap: (){
                              Navigator.of(context).push(
                                // With MaterialPageRoute, you can pass data between pages,
                                // but if you have a more complex app, you will quickly get lost.
                                MaterialPageRoute(
                                  builder: (context) =>
                                      HomeScreen(data: projects.code),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                   )
                ],
              ),   
           );
                   
      }
     
    },
  );
}

Widget build(BuildContext context) {
  return Scaffold(
    key: scaffoldKey,
    appBar: AppBar(
      backgroundColor: Colors.red[900],
      title:new Center(child: new Text("Yemek Tarifleri", textAlign: TextAlign.center)),

    ),
    body:projectWidget(),
      );
    }
}