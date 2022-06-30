import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _controller;
  bool isVisibleController = true;
  double currentPosition = 0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network('https://www.sample-videos.com/video123/mp4/240/big_buck_bunny_240p_5mb.mp4')
      ..initialize().then(
        (_) {
          _controller.play();
          setState(() => {});
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    _controller.addListener(() {
      setState(() {
        currentPosition = _controller.value.position.inMilliseconds.toDouble();
      });
    });
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isVisibleController = !isVisibleController;
                        });
                      },
                      child: VideoPlayer(_controller),
                    ),
                  )
                : const CircularProgressIndicator(
                    color: Colors.red,
                  ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Visibility(
                visible: isVisibleController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Slider(
                      value: currentPosition,
                      max: _controller.value.duration.inMilliseconds.toDouble(),
                      min: 0,
                      onChanged: (value) => {_controller.seekTo(Duration(milliseconds: value.toInt()))},
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          color: Colors.red,
                          onPressed: () {
                            setState(() {
                              _controller.seekTo(Duration(milliseconds: currentPosition.toInt() - 3000));
                            });
                          },
                          icon: const Icon(Icons.undo),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          color: Colors.red,
                          onPressed: () {
                            setState(() {
                              _controller.value.isPlaying ? _controller.pause() : _controller.play();
                            });
                          },
                          icon: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          color: Colors.red,
                          onPressed: () {
                            setState(() {
                              _controller.seekTo(Duration(milliseconds: currentPosition.toInt() + 3000));
                            });
                          },
                          icon: const Icon(Icons.redo),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
