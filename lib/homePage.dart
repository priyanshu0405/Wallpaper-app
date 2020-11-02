import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //API
  Future initWallpaper;
  Future getWallpapers(int count) async {
    List images = [];
    final res = await http.get(
        "https://api.unsplash.com/photos/random?client_id=UxZVvgsPkeWjT8iIvnpYg2oLk8mtUzkdLvmzwTrk2EQ&count=$count&orientation=portrait");
    if (res.statusCode == 200) {
      json.decode(res.body).forEach((e) {
        images.add(e['urls']['regular']);
      });
      return images;
    } else {
      throw Exception("Failed to retrieve images");
    }
  }

  @override
  void initState() {
    super.initState();
    initWallpaper = getWallpapers(10);
    currentIndex = 0;
  }

  int currentIndex;
  List urls;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFc3c3c3),
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
        title: Center(
            child: Text(
          "Wallpaper",
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        )),
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder(
          future: initWallpaper,
          builder: (context, snap) {
            if (!snap.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ));
            }
            urls = snap.data;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  height: MediaQuery.of(context).size.height * 0.60,
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      image: DecorationImage(
                          image: NetworkImage(urls[currentIndex]),
                          fit: BoxFit.fill)),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.13,
                  child: PageView.builder(
                      itemCount: 10,
                      controller: PageController(viewportFraction: 0.3),
                      onPageChanged: (int index) =>
                          setState(() => currentIndex = index),
                      itemBuilder: (context, index) {
                        return Transform.scale(
                          scale: index == currentIndex ? 1 : 0.7,
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: index == currentIndex
                                    ? Border.all(color: Colors.black, width: 5)
                                    : Border.all(color: Colors.transparent),
                                image: DecorationImage(
                                    image: NetworkImage(urls[index]),
                                    fit: BoxFit.cover)),
                          ),
                        );
                      }),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: RaisedButton(
                    onPressed: () {},
                    child: Text(
                      "Set on Lock Screen",
                      style: TextStyle(color: Colors.white.withOpacity(0.8)),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    color: Color(0xFF9e9e9e),
                  ),
                )
              ],
            );
          }),
    );
  }
}
