import 'package:audioplayer/core/components/position_data_comp.dart';
import 'package:audioplayer/core/mock/songs_data_mock.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioProvider extends ChangeNotifier {
  AudioPlayer player = AudioPlayer();
  List<String> path = SongsDataMock.path;
  int index = 0;
  bool showPlay = false;

  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        player.positionStream,
        player.bufferedPositionStream,
        player.durationStream,
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );

  refresh() {
    player.seek(const Duration());
  }

  previous() {
    player.seekToPrevious();
    if (index <= 0) {
      index = path.length - 1;
    } else {
      index -= 1;
    }
    setAsset();
    notifyListeners();
  }

  playPause() {
    if (showPlay) {
      player.pause();
      showPlay = !showPlay;
    } else {
      player.play();
      showPlay = !showPlay;
    }
    notifyListeners();
  }

  next() {
    player.seekToNext();
    if (index >= 3) {
      index = 0;
    } else {
      index += 1;
    }
    setAsset();
    notifyListeners();
  }

  setAsset() {
    player.setAsset(path[index]);
  }

  onTap(int i) {
    index = i;
    player.play();
    setAsset();
    notifyListeners();
  }
}
