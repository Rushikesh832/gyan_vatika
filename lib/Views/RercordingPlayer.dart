import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';


class RecordingPlayer extends StatefulWidget {

  String type,updateCreate;
  RecordingPlayer(this.type,this.updateCreate);
  @override
  _RecordingPlayerState createState() => _RecordingPlayerState();
}

class _RecordingPlayerState extends State<RecordingPlayer> {
  String statusText = "";
  var uuid = Uuid();
  bool isComplete = false;
  AudioPlayer audioPlayer = AudioPlayer();
  String idValue;
  Future<File> fileGallery;
  String galleryStatus = '';
  String base64ImageGallery;
  File tmpFileGallery;
  String errMessageGallery = 'Error Uploading Gallery Image.';
  String galleryName;
  String recordFilePath;
  static final String uploadEndPointTopic =
      'http://navelsoft.com/gayan/uploadTopicAudio.php';
  static final String uploadEndPointAssignment =
      'http://navelsoft.com/gayan/uploadAssignmentAudio.php';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("GYAN VATIKA",style: TextStyle(color: Colors.black),) ),
          backgroundColor: Color(0xFFFFA300),
        ),
        body: SingleChildScrollView(
          child: WillPopScope(
            onWillPop: onBackPressed,
            child: Column(children: [
              widget.updateCreate == "Update"  ? Text("Your Previous Recording will be overridden.",style: TextStyle(color: Colors.redAccent) ):Text(""),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        height: 48.0,
                        decoration: BoxDecoration(color: Colors.red.shade300),
                        child: Center(
                          child: Text(
                            'start',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      onTap: () async {
                        startRecord();
                      },
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        height: 48.0,
                        decoration: BoxDecoration(color: Colors.blue.shade300),
                        child: Center(
                          child: Text(
                            RecordMp3.instance.status == RecordStatus.PAUSE
                                ? 'resume'
                                : 'pause',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      onTap: () {
                        pauseRecord();
                      },
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        height: 48.0,
                        decoration: BoxDecoration(color: Colors.green.shade300),
                        child: Center(
                          child: Text(
                            'stop',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      onTap: () {
                        stopRecord();
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  statusText,
                  style: TextStyle(color: Colors.red, fontSize: 20),
                ),
              ),
              isComplete && recordFilePath != null  ?GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: ()
                  {
                    play();
                  },

                  child: Container(
                    height: 60,
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: Colors.blueAccent

                    ),
                    child:
                         Center(child:  Text("Play",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white
                        ) )),
                  )
              ) :Container(),
              isComplete && recordFilePath != null ? GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: upload,

                  child: Container(
                    height: 60,
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: Colors.blueAccent

                    ),
                    child:
                    Center(child:  Text("Upload",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white
                        ) )),
                  )
              ) :Container(),
              Text(
                galleryStatus,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                  fontSize: 20.0,
                ),
              ),
              InkWell(
                onTap: ()
                {
                  audioPlayer.pause();
                  //print(galleryName);
                  Navigator.pop(context,galleryName);
                },
                child: Column(
                  children: [
                    Icon(
                       Icons.keyboard_backspace,
                      size: 100,
                      color: Colors.blue,
                    ),
                    Text("Go Back")
                  ],
                ),
              ),

            ]),
          ),
        ),
      ),
    );
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      statusText = "Recording...";
      recordFilePath = await getFilePath();
      isComplete = false;
      RecordMp3.instance.start(recordFilePath, (type) {
        statusText = "Record error--->$type";
        setState(() {});
      });
    } else {
      statusText = "No microphone permission";
    }
    setState(() {});
  }

  void pauseRecord() {
    if (RecordMp3.instance.status == RecordStatus.PAUSE) {
      bool s = RecordMp3.instance.resume();
      if (s) {
        statusText = "Recording...";
        setState(() {});
      }
    } else {
      bool s = RecordMp3.instance.pause();
      if (s) {
        statusText = "Recording pause...";
        setState(() {});
      }
    }
  }

  void stopRecord() {
    bool s = RecordMp3.instance.stop();
    if (s) {
      statusText = "Record complete";
      isComplete = true;
      setState(() {});
    }
  }

  void resumeRecord() {
    bool s = RecordMp3.instance.resume();
    if (s) {
      statusText = "Recording...";
      setState(() {});
    }
  }



  void play() {
    if (recordFilePath != null && File(recordFilePath).existsSync()) {
      audioPlayer.play(recordFilePath, isLocal: true);
    }
  }

  /*void pause() {

      audioPlayer.play(recordFilePath, isLocal: true);

  }*/

  setStatusGallery(String message) {
    setState(() {
      galleryStatus = message;
    });
  }

  upload() async {

    setStatusGallery('Uploading Audio...');
    String url;

    final idKey = 'loginId';
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      idValue = prefs.getString(idKey) ?? null;
    });

    base64ImageGallery = base64Encode(File(recordFilePath).readAsBytesSync());
    galleryName = recordFilePath.split("/").last;
    setState(() {
      galleryName =   uuid.v1() +idValue+galleryName;
    });


    if(widget.type == "Topic")
      {
        url = uploadEndPointTopic;
      }
    else if(widget.type == "Assignment")
    {
      url = uploadEndPointAssignment;
    }
    else
      {
          setStatusGallery("Error While Uploading Audio do it Again.");
      }
    //print(url);
    //print(galleryName);

    http.post(url, body: {
      "audio": base64ImageGallery,
      "name": galleryName,
    }).then((result) {
      setStatusGallery(result.statusCode == 200 ? result.body : errMessageGallery);
    }).catchError((error) {
      setStatusGallery(error);
    });
  }


  int i = 0;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test_.mp3";
  }

  /*Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new InkWell(
        onTap: ()
        {
          audioPlayer.pause();
          //print(galleryName);
          //print("1");
          Navigator.pop(context,galleryName);
        },
      )
    ) ??
        false;
  }*/
  Future<bool> onBackPressed() {
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