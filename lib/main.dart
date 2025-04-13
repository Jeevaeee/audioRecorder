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

class _MyHomePageState extends State<MyHomePage> {
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  String audioPath = '';

  @override
  void initState() {
    // TODO: implement initState
    audioPlayer = AudioPlayer();
    audioRecord = Record();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    audioRecord.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    try {
      if (await audioRecord.hasPermission()) {
        await audioRecord.start();
        setState(() {
          isRecording = true;
        });
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

  Future<void>playRecording()async{
    try{
      Source urlSource =UrlSource(audioPath);
      await audioPlayer.play(urlSource);
    }
    catch (e) {
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
          children: <Widget>[
            if(isRecording)Text("Recording in process",style: TextStyle(fontSize: 20),),
            ElevatedButton(
              onPressed: isRecording ? stopRecording : startRecording,
              child:
                  isRecording
                      ? Text("Stop Recording")
                      : Text("Start Recording"),
            ),
            SizedBox(height: 25),

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
