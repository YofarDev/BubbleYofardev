import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/canvas_cubit.dart';
import 'bubble_shape_picker.dart';
import 'bubble_text_field.dart';

class BottomOverlay extends StatelessWidget {
  const BottomOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CanvasCubit, CanvasState>(
      builder: (BuildContext context, CanvasState state) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            BubbleTextField(
              font: state.font,
              controller: context.read<CanvasCubit>().textController,
              setMaxWidthBubble: state.setMaxWidthBubble,
              onMaxWidthBubbleChanged:
                  context.read<CanvasCubit>().changeMaxWidthBubble,
              onSetMaxWidthBubbleChanged: (bool? value) {
                if (value != null) {
                  context.read<CanvasCubit>().toggleSetMaxWidthBubble(value);
                }
              },
              maxWidthBubble: state.maxWidthBubble,
            ),
            const SizedBox(width: 16),
            BubbleShapePicker(
              selected: state.selectedBubbleType,
            ),
          ],
        );
      },
    );
  }
}
