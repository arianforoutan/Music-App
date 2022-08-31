import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(Application());
}

class Application extends StatefulWidget {
  Application({Key? key}) : super(key: key);

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  double value = 0;

  bool playing = false;

  final player = AudioPlayer();

  Duration? duration = Duration(seconds: 0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAsset();
  }

  void initAsset() async {
    await player.setSource(AssetSource("sk.mp3"));
    duration = await player.getDuration();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color.fromARGB(255, 220, 240, 41),
                  Color.fromARGB(255, 15, 205, 219),
                ]),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 150,
              ),
              Center(
                child: Container(
                  width: 280.0,
                  height: 280.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    image: DecorationImage(
                      image: AssetImage('images/13.png'),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Smokey's Lounge",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'TrackTribe',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Color.fromARGB(248, 230, 235, 232),
                          Color.fromARGB(151, 236, 239, 240),
                        ],
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Stack(
                        children: [
                          BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 50.0,
                              sigmaY: 50.0,
                            ),
                            child: SizedBox(
                              height: 250,
                              width: 395,
                            ),
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${(value / 60).floor()}:${(value % 60).floor()}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Slider.adaptive(
                                      onChanged: (v) {
                                        value = v;
                                      },
                                      min: 0.0,
                                      max: duration!.inSeconds.toDouble(),
                                      value: value,
                                      onChangeEnd: ((value1) async {
                                        setState(() {
                                          value = value1;
                                        });
                                        player.pause();
                                        await player.seek(
                                            Duration(seconds: value1.toInt()));
                                        await player.resume();
                                        playing = true;
                                      }),
                                      activeColor:
                                          Color.fromARGB(255, 85, 83, 172),
                                      inactiveColor:
                                          Color.fromARGB(255, 200, 189, 238)),
                                  Text(
                                    '${duration!.inMinutes}:${duration!.inSeconds % 60}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 25),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.skip_previous_outlined,
                                        size: 50,
                                        color: Color.fromARGB(255, 85, 83, 172),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        if (playing) {
                                          await player.pause();
                                          setState(() {
                                            playing = false;
                                          });
                                        } else {
                                          await player.resume();

                                          setState(() {
                                            playing = true;
                                          });

                                          player.onPositionChanged.listen(
                                            (event) {
                                              setState(() {
                                                value =
                                                    event.inSeconds.toDouble();
                                              });
                                            },
                                          );
                                        }
                                      },
                                      icon: Icon(
                                        playing
                                            ? Icons.pause_circle_outline
                                            : Icons.play_circle_fill_outlined,
                                        size: 60,
                                        color: Color.fromARGB(255, 85, 83, 172),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.skip_next_outlined,
                                        size: 50,
                                        color: Color.fromARGB(255, 85, 83, 172),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
