import 'package:flutter/material.dart';

class Youtube extends StatefulWidget {
  
  @override
  YoutubeState createState() => YoutubeState();
}

class YoutubeState extends State<Youtube> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(24),
            child: Center(
              child: Column(
                children: <Widget>[
                  Center(
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.asset('assets/images/logo.jpg'),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  
                   ButtonTheme(
                    //elevation: 4,
                    //color: Colors.green,
                    
                    minWidth: double.infinity,
                    child: MaterialButton(
                      onPressed: () => { Navigator.pushNamed(context, '/')  },
                      textColor: Colors.white,
                      color: Colors.blue,
                      height: 50,
                      child: Text("Yeni Oyun"),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                   ButtonTheme(
                    //elevation: 4,
                    //color: Colors.green,
                    
                    minWidth: double.infinity,
                    child: MaterialButton(
                      onPressed: () => {  },
                      textColor: Colors.white,
                      color: Colors.blue,
                      height: 50,
                      child: Text("Kayıt Ol"),
                    ),
                  ),
SizedBox(
                    height: 30,
                  ),
                   ButtonTheme(
                    //elevation: 4,
                    //color: Colors.green,
                    
                    minWidth: double.infinity,
                    child: MaterialButton(
                      onPressed: () => {  },
                      textColor: Colors.white,
                      color: Colors.blue,
                      height: 50,
                      child: Text("Sıralamam"),
                    ),
                  ),

                ]
              )
            )
          )
        )
     )
    );
  }
}