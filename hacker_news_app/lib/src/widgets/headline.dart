import 'package:flutter/material.dart';


const Duration headlineAnimationDuration = const Duration(milliseconds: 400);
const List<Color> headlineTextColors = [Colors.blue, Colors.deepOrange];

class Headline extends ImplicitlyAnimatedWidget {
  final String text;
  final int index;

  Color get targetColor => index == 0 ? Colors.red : Colors.blue;

  Headline({@required this.text, @required this.index, Key key})
      : super(key: key, duration: headlineAnimationDuration);

  @override
  _HeadlineState createState() => _HeadlineState();
}

class _HeadlineState extends AnimatedWidgetBaseState<Headline> {
  GhostFadeTween _colorTween;
  _SwitchStringTween _switchStringTween;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${_switchStringTween.evaluate(animation)}',
      style: TextStyle(color: _colorTween.evaluate(animation)),
    );
  }

  @override
  void forEachTween(visitor) {
    _colorTween = visitor(
      _colorTween,
      widget.targetColor,
      (color) => GhostFadeTween(begin: color),
    );

    _switchStringTween = visitor(_switchStringTween, widget.text,
        (value) => _SwitchStringTween(begin: value));
  }
}

@visibleForTesting
class GhostFadeTween extends Tween<Color> {
  final Color middle = Colors.white;

  GhostFadeTween({Color begin, Color end}) : super(begin: begin, end: end);

  Color lerp(double t) {
    if (t < 0.5) {
      return Color.lerp(begin, middle, t * 2);
    } else {
      return Color.lerp(middle, end, (t - 0.5) * 2);
    }
  }
}

class _SwitchStringTween extends Tween<String> {
  final Color middle = Colors.white;

  _SwitchStringTween({String begin, String end}) : super(begin: begin, end: end);

  String lerp(double t) {
    if (t < 0.5) {
      return begin;
    } else {
      return end;
    }
  }
}
