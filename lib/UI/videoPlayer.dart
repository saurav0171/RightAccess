import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:right_access/CommonFiles/common.dart';
import 'package:video_player/video_player.dart';



class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller ;
  Future<void> _initializeVideoPlayerFuture;
  bool isVideoEnded = false;
  bool isRatingDone = false;

  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    
  _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );
    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(false);
    
    
    _controller.addListener(checkVideo);

    super.initState();

     SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
  ]);
  }

  @override
  void dispose() {
    super.dispose();
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();
    _controller.removeListener(checkVideo);
    SystemChrome.setPreferredOrientations([
       DeviceOrientation.portraitUp,
      ]);
    
  }
  void checkVideo(){
    // Implement your calls inside these conditions' bodies : 
    if(_controller.value.position == Duration(seconds: 0, minutes: 0, hours: 0)&& isVideoEnded == true) {
      print('video Started');
      isVideoEnded = false; 
    }
      // print("_controller.value.position : ${_controller.value.position}");
    if(_controller.value.position == _controller.value.duration && isVideoEnded == false) {
      print('video Ended');
      isVideoEnded = true; 
      setState(() {
         _controller.pause();
          _controller.seekTo(Duration(seconds: 0, minutes: 0, hours: 0));
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(gradient: setGradientColor())
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Butterfly Video'),
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: Center(
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the VideoPlayerController has finished initialization, use
              // the data it provides to limit the aspect ratio of the video.
              return AspectRatio(
                aspectRatio: 2.20,
                // Use the VideoPlayer widget to display the video.
                child: VideoPlayer(_controller),
              );
            } else {
              // If the VideoPlayerController is still initializing, show a
              // loading spinner.
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: appThemeColor2,
        onPressed: () {
          // Wrap the play or pause in a call to `setState`. This ensures the
          // correct icon is shown.
          setState(() {
            // If the video is playing, pause it.
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // If the video is paused, play it.
              isVideoEnded = true; 
              _controller.play();
              
            }
          });
        },
        // Display the correct icon depending on the state of the player.
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    ),
      ],
    );
    
    
  }

}