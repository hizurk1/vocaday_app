import 'dart:async';

import 'package:flutter/material.dart';

import '../themes/app_text_theme.dart';
import 'text.dart';

class TimeCountDownWidget extends StatefulWidget {
  const TimeCountDownWidget({
    super.key,
    required this.durationInSeconds,
    required this.onFinish,
    this.style,
    this.textAlign = TextAlign.end,
  });

  final int durationInSeconds;
  final VoidCallback onFinish;
  final TextStyle? style;
  final TextAlign textAlign;

  @override
  State<TimeCountDownWidget> createState() => _TimeCountDownWidgetState();
}

class _TimeCountDownWidgetState extends State<TimeCountDownWidget> {
  late Timer _timer;
  late int _durationInSeconds;
  String _timerText = '';

  @override
  void initState() {
    super.initState();
    _durationInSeconds = widget.durationInSeconds;
    _updateTimerText();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _durationInSeconds--;
        _updateTimerText();
        if (_durationInSeconds <= 0) {
          widget.onFinish();
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTimerText() {
    final minutes = (_durationInSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_durationInSeconds % 60).toString().padLeft(2, '0');
    _timerText = '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return TextCustom(
      _timerText,
      textAlign: widget.textAlign,
      style: widget.style ?? context.textStyle.bodyS.bw,
    );
  }
}
