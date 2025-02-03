import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideo extends StatefulWidget {
  YoutubeVideo({super.key});

  @override
  _YoutubeVideoState createState() => _YoutubeVideoState();
}

class _YoutubeVideoState extends State<YoutubeVideo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;
  bool _isPlayerReady = false;
  late String videoId;
  final List<String> _ids = [
    "rzC3pXB0D-c",
    'Nc6ffPtAtnY',
    "X8134JVOPb8",
    'TnwPxwhkTcU',
    "pkiaP5Ky2iM",
  ];

  @override
  void initState() {
    super.initState();
    videoId = _ids.first;
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(mute: false, autoPlay: true, disableDragSeek: false, loop: false, isLive: false, forceHD: false, enableCaption: true, controlsVisibleAtStart: false),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {});
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }
PageController _pc=PageController();
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pc,
      scrollDirection: Axis.vertical,
      onPageChanged: (value) {
        _controller.load(_ids[1]);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PLay next video")));

      },
      children: [
        Container(
          color: Colors.blue,
          child: VisibilityDetector(
            key: const Key("unique key"),
            onVisibilityChanged: (info) {
              if (info.visibleFraction == 0) {
                _controller.pause();
              } else {
                _controller.value.isPlaying ? _controller.play() : _controller.pause();
              }
            },
            child: YoutubePlayerBuilder(
              onExitFullScreen: () {
                // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
                SystemChrome.setPreferredOrientations(DeviceOrientation.values);
              },
              player: YoutubePlayer(
                aspectRatio: 9 / 16,
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.blueAccent,
                topActions: <Widget>[
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      _controller.metadata.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
                onReady: () {
                  _controller.addListener(listener);
                },
                onEnded: (data) {
                  _pc.nextPage(duration: Duration(milliseconds: 5), curve: Curves.bounceIn);
                  _controller.load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PLay next video")));
                },
              ),
              builder: (context, player) => Scaffold(
                key: _scaffoldKey,
                body: ListView(
                  children: [
                    player,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
