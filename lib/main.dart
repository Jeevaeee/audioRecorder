import 'dart:async';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  String audioPath = '';
  late AnimationController controller;
  bool year2023 = true;
  int timeleft =10;
  bool url=false;


  void _startCoutDown(){
    Timer.periodic(Duration(seconds: 1), (timer){
      if(timeleft>0)
        {
          setState(() {
            timeleft--;
          });
        }

      else{
        timer.cancel();
        stopRecording();
      }
    });}




  @override
  void initState() {
    // TODO: implement initState
    audioPlayer = AudioPlayer();
    audioRecord = Record();
    controller = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
      setState(() {});
    })
    ..repeat(reverse: false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    audioRecord.dispose();
    audioPlayer.dispose();
    controller.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    try {
      if (await audioRecord.hasPermission()) {
        await audioRecord.start();
        setState(() {
          isRecording = true;
        });
        _startCoutDown();

      }

    } catch (e) {
      print("Error Start Recording : $e");
    }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await audioRecord.stop();
      setState(() {
        isRecording = false;
        audioPath = path!;

      });


    } catch (e) {
      print("Error stop Recording : $e");
    }
  }

  Future<void> playRecording() async {
    try {
      Source urlSource = UrlSource(audioPath);

      url=true;
      setState(() {
        bool value=false;
        year2023 = value;
        if (isRecording) {
          controller.stop();
        } else {
          controller
            ..forward(from: controller.value)
            ..repeat();
        }
      });
      await audioPlayer.play(urlSource);
    } catch (e) {
      print("Error Play Recording : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Audio Recorder")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16.0,
          children: <Widget>[
            Text(timeleft.toString(),style: TextStyle(fontSize: 20),),
            if(isRecording)
              Text("Audio is Recording" ,style: TextStyle(fontSize: 20),),


            ElevatedButton(
              onPressed: isRecording ? stopRecording : startRecording,
              child:
                  isRecording
                      ? Text("Stop Recording")
                      : Text("Start Recording"),
            ),
            SizedBox(height: 25),

            if (url)
              Padding(
                padding: const EdgeInsets.only(left: 80,right: 80),
                child: LinearProgressIndicator(
                  year2023: year2023,
                  value: controller.value,
                ),
              ),
            //if(isRecording && audioPath !=null)

            ElevatedButton(
              onPressed: playRecording,
              child: Text("Play Recording"),
            ),

          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

