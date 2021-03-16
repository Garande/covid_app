import 'package:flutter/material.dart';
// import 'package:lawapp/blocs/learning/learning_bloc.dart';
// import 'package:lawapp/utils/app_theme.dart';
// import 'package:lawapp/utils/helpers.dart';
// import 'package:video_player/video_player.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class VideoProgressBar extends StatefulWidget {
//   VideoProgressBar(
//       {Key key, this.colors, this.isExpanded, this.videoPlayerController})
//       : super(key: key);

//   final ProgressBarColors colors;
//   final bool isExpanded;
//   final VideoPlayerController videoPlayerController;

//   @override
//   _VideoProgressBarState createState() => _VideoProgressBarState();
// }

// class _VideoProgressBarState extends State<VideoProgressBar> {
//   VideoPlayerController _videoPlayerController;

//   Offset _touchPoint = Offset.zero;

//   double _playedValue = 0.0;
//   double _bufferedValue = 0.0;

//   bool _touchDown = false;
//   Duration _position;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (_videoPlayerController == null) {
//       assert(widget.videoPlayerController != null);
//       _videoPlayerController = widget.videoPlayerController;
//     }
//     _videoPlayerController.addListener(positionListener);
//     positionListener();
//   }

//   @override
//   void dispose() {
//     _videoPlayerController?.removeListener(positionListener);
//     super.dispose();
//   }

//   void positionListener() {
//     int _totalDuration = _videoPlayerController.value.duration?.inMilliseconds;
//     if (mounted && !_totalDuration.isNaN && _totalDuration != 0) {
//       setState(() {
//         _playedValue = _videoPlayerController.value.position.inMilliseconds /
//             _totalDuration;
//         // _bufferedValue = _videoPlayerController.value.buffered;
//       });
//     }
//   }

//   void _setValue() {
//     _playedValue = _touchPoint.dx / context.size.width;
//   }

//   void _checkTouchPoint() {
//     if (_touchPoint.dx <= 0) _touchPoint = Offset(0, _touchPoint.dy);
//     if (_touchPoint.dx >= context.size.width)
//       _touchPoint = Offset(context.size.width, _touchPoint.dy);
//   }

//   void _seekToRelativePosition(Offset globalPosition) {
//     final RenderBox box = context.findRenderObject();
//     _touchPoint = box.globalToLocal(globalPosition);
//     _checkTouchPoint();
//     final relative = _touchPoint.dx / box.size.width;
//     _position = _videoPlayerController.value.duration * relative;
//     _videoPlayerController.seekTo(_position);
//   }

//   void _dragEndActions() {
//     _videoPlayerController.seekTo(_position);
//     setState(() {
//       _touchDown = false;
//     });
//     _videoPlayerController.play();
//   }

//   Widget _buildBar() {
//     return GestureDetector(
//       onHorizontalDragDown: (details) {
//         _seekToRelativePosition(details.globalPosition);
//         setState(() {
//           _setValue();
//           _touchDown = true;
//         });
//       },
//       onHorizontalDragUpdate: (details) {
//         _seekToRelativePosition(details.globalPosition);
//         setState(_setValue);
//       },
//       onHorizontalDragEnd: (details) {
//         _dragEndActions();
//       },
//       onHorizontalDragCancel: _dragEndActions,
//       child: Container(
//         color: Colors.transparent,
//         constraints: BoxConstraints.expand(height: 7.0 * 2),
//         child: CustomPaint(
//           painter: _ProgressBarPainter(
//             progressWidth: 2.0,
//             handleRadius: 7.0,
//             playedValue: _playedValue,
//             bufferedValue: _bufferedValue,
//             colors: widget.colors,
//             touchDown: _touchDown,
//             themeData: Theme.of(context),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) => widget.isExpanded
//       ? Expanded(
//           child: _buildBar(),
//         )
//       : _buildBar();
// }

// class QuizProgressBar extends StatelessWidget {
//   const QuizProgressBar({
//     Key key,
//     @required this.learningBloc,
//   }) : super(key: key);
//   final LearningBloc learningBloc;

//   double _getPlayedValue(played) {
//     int time = learningBloc.quizTotalTime - played;
//     return (time / learningBloc.quizTotalTime);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<int>(
//         stream: learningBloc.quizTimeStream,
//         builder: (context, snapshot) {
//           return Row(
//             children: <Widget>[
//               Text(
//                 "${quizDurationFormatter(snapshot.data != null ? snapshot?.data : 0)}",
//                 style: TextStyle(
//                   // color: Colors.white,
//                   fontSize: 16.0,
//                 ),
//               ),
//               SizedBox(
//                 width: 8.0,
//               ),
//               Expanded(
//                 child: Container(
//                   color: Colors.transparent,
//                   constraints: BoxConstraints.expand(height: 7.0 * 2),
//                   child: CustomPaint(
//                     painter: _ProgressBarPainter(
//                       progressWidth: 4.0,
//                       handleRadius: 5.0,
//                       playedValue: snapshot.data != null
//                           ? _getPlayedValue(snapshot.data)
//                           : 0.0,
//                       bufferedValue: 0.0,
//                       colors: ProgressBarColors(
//                           backgroundColor:
//                               AppTheme.nearlyDarkBlue.withOpacity(0.4),
//                           playedColor: AppTheme.nearlyDarkBlue),
//                       touchDown: false,
//                       themeData: Theme.of(context),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 8.0,
//               ),
//               Text(
//                 "${learningBloc.playedQuestions}/${learningBloc.noOfQuestions}",
//                 style: TextStyle(
//                   // color: Colors.white,
//                   fontSize: 16.0,
//                 ),
//               ),
//             ],
//           );
//         });
//   }
// }

class _ProgressBarPainter extends CustomPainter {
  final double progressWidth;
  final double handleRadius;
  final double playedValue;
  final double bufferedValue;
  final ProgressBarColors colors;
  final bool touchDown;
  final ThemeData themeData;

  _ProgressBarPainter({
    this.progressWidth,
    this.handleRadius,
    this.playedValue,
    this.bufferedValue,
    this.colors,
    this.touchDown,
    this.themeData,
  });

  @override
  bool shouldRepaint(_ProgressBarPainter old) {
    return playedValue != old.playedValue ||
        bufferedValue != old.bufferedValue ||
        touchDown != old.touchDown;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.square
      ..strokeWidth = progressWidth;

    final centerY = size.height / 2.0;
    final barLength = size.width - handleRadius * 2.0;

    final startPoint = Offset(handleRadius, centerY);
    final endPoint = Offset(size.width - handleRadius, centerY);
    final progressPoint =
        Offset(barLength * playedValue + handleRadius, centerY);
    final secondProgressPoint =
        Offset(barLength * bufferedValue + handleRadius, centerY);

    paint.color =
        colors?.backgroundColor ?? themeData.accentColor.withOpacity(0.38);
    canvas.drawLine(startPoint, endPoint, paint);

    paint.color = colors?.bufferedColor ?? Colors.white70;
    canvas.drawLine(startPoint, secondProgressPoint, paint);

    paint.color = colors?.playedColor ?? themeData.accentColor;
    canvas.drawLine(startPoint, progressPoint, paint);

    final handlePaint = Paint()..isAntiAlias = true;

    handlePaint.color = Colors.transparent;
    canvas.drawCircle(progressPoint, centerY, handlePaint);

    final _handleColor = colors?.handleColor ?? themeData.accentColor;

    if (touchDown) {
      handlePaint.color = _handleColor.withOpacity(0.4);
      canvas.drawCircle(progressPoint, handleRadius * 3, handlePaint);
    }

    handlePaint.color = _handleColor;
    canvas.drawCircle(progressPoint, handleRadius, handlePaint);
  }
}

/// Defines different colors for [ProgressBar].
class ProgressBarColors {
  /// Defines background color of the [ProgressBar].
  final Color backgroundColor;

  /// Defines color for played portion of the [ProgressBar].
  final Color playedColor;

  /// Defines color for buffered portion of the [ProgressBar].
  final Color bufferedColor;

  /// Defines color for handle of the [ProgressBar].
  final Color handleColor;

  /// Creates [ProgressBarColors].
  const ProgressBarColors({
    this.backgroundColor,
    this.playedColor,
    this.bufferedColor,
    this.handleColor,
  });
}
