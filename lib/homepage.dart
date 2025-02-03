import 'package:flutter/material.dart';
import 'package:youtube_video_player/videoplayer.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Container(
          child: YoutubeVideo(),
        ));
  }
}