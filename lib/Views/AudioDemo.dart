import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'AudioProvider.dart';
import 'RercordingPlayer.dart';

class AudioDemo extends StatefulWidget {

  String audioFile;
  String type;

  AudioDemo(this.audioFile,this.type);
  @override
  _AudioDemoState createState() => _AudioDemoState();
}

class _AudioDemoState extends State<AudioDemo> {

  AudioPlayer audioPlayer = new AudioPlayer();
  Duration duration = new Duration();
  Duration position = new Duration();
  bool playing = false;
  /*String _information;
  void moveToSecondPage(String data) async {
    final information = await Navigator.push(
      context,
      MaterialPageRoute(
          fullscreenDialog: true, builder: (context) => RecordingPlayer("Assignment",data)),
    );
    updateInformation(information);
  }
  void updateInformation(String information) {
    setState(() => _information = information);
    //print(_information);
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView (
        child: WillPopScope(
          onWillPop: _onBackPressed,
          child: Container(
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image(image: AssetImage('audio.png')),
                slider(),
                InkWell(
                  onTap: ()
                  {
                    getAudio();
                  },
                  child: Icon(
                    !playing ? Icons.play_circle_outline
                        : Icons.pause_circle_outline,
                    size: 100,
                    color: Colors.blue,
                  ),
                ),
                widget.type == "AssignmentEdit" ? InkWell(
            onTap: ()
            {
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => RecordingPlayer("Assignment","Update")
              ));
            },

            child: Container(
              height: 60,
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: Colors.blueAccent

              ),
              child: Center(child:  Text("Want To Update Audio",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white
                  ) )),
            )
        ) : Text("")
        ],
            ),
          ),
        ),
      ),
    );
  }

  Widget slider()
  {
    return Slider.adaptive(
      min: 0.0,
        value: position.inSeconds.toDouble(),
        max: duration.inSeconds.toDouble(),
        onChanged: (double value)
        {
          setState(() {

            audioPlayer.seek( new Duration(seconds: value.toInt()));

          });
        }
    );

  }

  void getAudio () async
  {
    AudioProvider audioProvider;
    String url;


    if(playing)
      {
          var res =  await audioPlayer.pause();
          if(res == 1)
            {
              setState(() {
                playing = false;
              });
            }
      }
    else
      {
        if(widget.type == "Assignment")
        {

          url = "http://navelsoft.com/gayan/Audio/Assignments/"+ widget.audioFile;
          //print(url);
          setState(() {
            audioProvider = new AudioProvider(url);
          });

        }
        else if(widget.type == "AssignmentEdit")
        {

          url = "http://navelsoft.com/gayan/Audio/Assignments/"+ widget.audioFile;
          //print(url);
          setState(() {
            audioProvider = new AudioProvider(url);
          });

        }
        else if(widget.type == "Topics")
        {
          url = "http://navelsoft.com/gayan/Audio/Topics/"+ widget.audioFile;
          //print(url);
          setState(() {
            audioProvider = new AudioProvider(url);
          });
        }
        else
        {
          Navigator.pop(context);
        }

        String localUrl = await audioProvider.load();

        var res = await audioPlayer.play(localUrl);
        if(res == 1)
          {
            setState(() {
              playing = true;
            });

          }
      }

    audioPlayer.onDurationChanged.listen((Duration dd) {
      setState(() {
        duration = dd;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((Duration dd) {
      setState(() {
        position = dd;
      });
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to Close Audio.'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Padding(
              padding: EdgeInsets.all(8),
            child: Text("NO"),
            )

          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: ()
                async {
                  var res =  await audioPlayer.pause();
                  if(res == 1)
                  {
                    setState(() {
                      playing = false;
                    });
                  }
                  Navigator.of(context).pop(true);
                },
            child:  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("YES"),
                    )

          ),
        ],
      ),
    ) ??
        false;
  }
}
