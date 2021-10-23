import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayers extends ChangeNotifier{

  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();
PlayerState state = PlayerState.PAUSED;
  playLocalSound() async {
     await audioCache.load("sound/achievement.wav");
     await audioCache.play("sound/achievement.wav");
  }

  stopSound() async {
    await audioCache.clear(Uri.parse("sound/achievement.wav"));
  }
}