import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:measured_size/measured_size.dart';

import '../../logic/canvas_cubit.dart';
import '../../models/bubble.dart';
import 'bubble_container.dart';
import 'scream_bubble/scream_bubble.dart';
import 'talking_triangle_of_bubble.dart';
import 'thought_bubble/thought_bubble.dart';
import 'thought_bubble/thought_bubble_tail.dart';

class BubbleItem extends StatelessWidget {
  final Bubble bubble;

  const BubbleItem({
    super.key,
    required this.bubble,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CanvasCubit, CanvasState>(
      builder: (BuildContext context, CanvasState state) {
        return Stack(
          children: <Widget>[
            Positioned(
              left: bubble.position.dx,
              top: bubble.position.dy,
              child: MeasuredSize(
                onChange: (Size size) {
                  context
                      .read<CanvasCubit>()
                      .updateBubbleSize(bubble.uuid, size);
                },
                child: _buildBubbleContent(bubble, state),
              ),
            ),
            if (bubble.bubbleSize != null &&
                bubble.centerPoint != null &&
                bubble.talkingPoint != null)
              if (bubble.type == BubbleType.talk)
                TalkingTriangleOfBubble(
                  center: bubble.centerPoint!,
                  talkingPoint: bubble.talkingPoint!,
                  sizeBubble: bubble.bubbleSize!,
                  widthBaseTriangle: bubble.bubbleSize!.width /
                      (bubble.widthBaseTriangle ?? state.widthBaseTriangle),
                  movingMode:
                      state.isEditMode && bubble.uuid == state.bubbleMovingUuid,
                )
              else if (bubble.type == BubbleType.thought)
                ThoughtBubbleTail(
                  start: _getIntersectionPoint(
                    bubble.centerPoint!,
                    bubble.talkingPoint!,
                    bubble.bubbleSize!,
                  ),
                  end: bubble.talkingPoint!,
                  isSelected:
                      state.isEditMode && bubble.uuid == state.bubbleMovingUuid,
                ),
          ],
        );
      },
    );
  }

    Widget _buildBubbleContent(Bubble item, CanvasState state) {
    switch (item.type) {
      case BubbleType.thought:
        return ThoughtBubble(
          isSelected: state.isEditMode && item.uuid == state.bubbleMovingUuid,
          maxWidth: item.maxWidthBubble,
          text: item.body,
          randomSeed: item.seed,
          textStyle: TextStyle(
              fontFamily: item.font,
              fontSize: item.fontSize,
              fontWeight: FontWeight.normal),
        );
      case BubbleType.scream:
        return ScreamBubble(
          isSelected: state.isEditMode && item.uuid == state.bubbleMovingUuid,
          text: item.body,
          maxWidth: item.maxWidthBubble,
          textStyle: TextStyle(
              fontFamily: item.font,
              fontSize: item.fontSize,
              fontWeight: FontWeight.bold),
        );
      case BubbleType.talk || BubbleType.yellowNarrate || BubbleType.narrate:
        return BubbleContainer(
          isYellowBg: item.type == BubbleType.yellowNarrate,
          txt: item.body,
          font: item.font,
          fontSize: item.fontSize,
          isRoundBubble: item.type == BubbleType.talk,
          movingMode: state.isEditMode && item.uuid == state.bubbleMovingUuid,
          maxWidth: item.maxWidthBubble,
        );
    }
  }


  Offset _getIntersectionPoint(Offset center, Offset end, Size size) {
  final double dx = end.dx - center.dx;
  final double dy = end.dy - center.dy;
  final double halfWidth = size.width / 2;
  final double halfHeight = size.height / 2;
  final double tx = halfWidth / dx.abs();
  final double ty = halfHeight / dy.abs();
  final double t = tx < ty ? tx : ty;
  return Offset(center.dx + t * dx, center.dy + t * dy);
}
}
