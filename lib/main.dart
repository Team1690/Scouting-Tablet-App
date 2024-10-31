import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'dart:math' show pi;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Video Player',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  VideoPlayerController? _controller;
  bool _isVideoPlaying = false;
  bool _isMenuVisible = false;
  Alignment _menuAlignment = Alignment.center;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null) {
      final videoFile = File(result.files.single.path!);
      _initializeVideoPlayer(videoFile);
    }
  }

  void _initializeVideoPlayer(File videoFile) {
    _controller = VideoPlayerController.file(videoFile)
      ..initialize().then((_) {
        setState(() {
          _isVideoPlaying = true;
          _controller!.play();
        });
      });
  }

  void _showMenu(TapDownDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localPosition = box.globalToLocal(details.globalPosition);
    final Size size = box.size;
    setState(() {
      _controller?.pause();
      _isMenuVisible = true;
      _menuAlignment = Alignment(
        (localPosition.dx / size.width) * 2 - 1,
        (localPosition.dy / size.height) * 2 - 1,
      );
    });
  }

  void _hideMenu([bool shouldPlayVideo = false]) {
    setState(() {
      _isMenuVisible = false;
      if (shouldPlayVideo) {
        _controller?.play();
      }
    });
  }

  void _stopVideo() {
    _controller?.pause();
    _controller?.seekTo(Duration.zero);
    setState(() {
      _isVideoPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: GestureDetector(
        onTap: () => _hideMenu(true),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: _isVideoPlaying && _controller != null
                    ? GestureDetector(
                        onDoubleTapDown: _showMenu,
                        child: AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: VideoPlayer(_controller!),
                        ),
                      )
                    : const Text('Pick a video to play'),
              ),
            ),
            if (_isMenuVisible)
              CircularMenu(
                alignment: _menuAlignment,
                startingAngleInRadian: 0,
                endingAngleInRadian: pi * 2,
                radius: 80,
                items: [
                  CircularMenuItem(
                    icon: Icons.add_ic_call_outlined,
                    color: Colors.red,
                    onTap: () {},
                  ),
                  CircularMenuItem(
                    icon: Icons.add_ic_call_outlined,
                    color: Colors.green,
                    onTap: () {},
                  ),
                  CircularMenuItem(
                    icon: Icons.add_ic_call_outlined,
                    color: Colors.red,
                    onTap: () {},
                  ),
                  CircularMenuItem(
                    icon: Icons.add_ic_call_outlined,
                    color: Colors.green,
                    onTap: () {},
                  ),
                  CircularMenuItem(
                    icon: Icons.add_ic_call_outlined,
                    // color: Colors.green,
                    iconColor: Colors.orange,
                    onTap: () {},
                  ),
                ],
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickVideo,
        tooltip: 'Pick Video',
        child: const Icon(Icons.video_library),
      ),
    );
  }
}
