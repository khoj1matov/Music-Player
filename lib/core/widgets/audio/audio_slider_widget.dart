import 'dart:math';

import 'package:audioplayer/core/components/text_style_comp.dart';
import 'package:audioplayer/core/constants/color_const.dart';
import 'package:audioplayer/provider/audio_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AudioSliderWidget extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  const AudioSliderWidget({
    Key? key,
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
  }) : super(key: key);

  @override
  AudioSliderWidgetState createState() => AudioSliderWidgetState();
}

class AudioSliderWidgetState extends State<AudioSliderWidget> {
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    context.read<AudioProvider>().timeOut(remaining);
    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            inactiveTrackColor: ColorConst.black38,
            thumbColor: ColorConst.kPrimaryBlack,
            activeTrackColor: ColorConst.kPrimaryBlack,
          ),
          child: Slider(
            min: 0.0,
            max: widget.duration.inMilliseconds.toDouble(),
            value: min(
              _dragValue ?? widget.position.inMilliseconds.toDouble(),
              widget.duration.inMilliseconds.toDouble(),
            ),
            onChanged: (value) {
              setState(() {
                _dragValue = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(Duration(milliseconds: value.round()));
              }
            },
            onChangeEnd: (value) {
              if (widget.onChangeEnd != null) {
                widget.onChangeEnd!(Duration(milliseconds: value.round()));
              }
              _dragValue = null;
            },
          ),
        ),
        Text(
          RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                  .firstMatch(
                    "$remaining",
                  )
                  ?.group(1) ??
              '$remaining',
          style: MyTextStyleComp.myTextStyle(
            color: ColorConst.kPrimaryBlack,
            fontSize: 20,
            weight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Duration get remaining => widget.duration - widget.position;
}
