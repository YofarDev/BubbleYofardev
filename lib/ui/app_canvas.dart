import 'package:flutter/foundation.dart' show Uint8List;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';

import '../logic/canvas_cubit.dart';
import '../models/bubble.dart';
import '../utils/image_utils.dart';
import '../utils/save_file_web.dart';
import 'widgets/bubble_item.dart';

class AppCanvas extends StatelessWidget {
  const AppCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    final ScreenshotController screenshotController = ScreenshotController();
    return BlocConsumer<CanvasCubit, CanvasState>(
      listenWhen: (CanvasState previous, CanvasState current) =>
          previous.status != current.status,
      listener: (BuildContext context, CanvasState state) {
        if (state.status == CanvasStatus.saving) {
          _onSavePressed(context, screenshotController, trim: state.trim);
        }
      },
      builder: (BuildContext context, CanvasState state) {
        return Screenshot(
          controller: screenshotController,
          child: Listener(
            onPointerDown: (PointerDownEvent e) {
              if (state.isEditMode) {
                context
                    .read<CanvasCubit>()
                    .selectBubbleAtPosition(e.localPosition);
              } else if (state.bubbleTalkingPointMode) {
                context.read<CanvasCubit>().setTalkingPoint(e.localPosition);
              } else {
                context.read<CanvasCubit>().startCreatingBubble(e.localPosition,
                    context.read<CanvasCubit>().textController.text);
              }
            },
            onPointerUp: (PointerUpEvent e) {
              if (state.isEditMode) {
                context.read<CanvasCubit>().selectBubble(null);
              } else if (state.bubbleTalkingPointMode) {
                context.read<CanvasCubit>().setTalkingPoint(e.localPosition);
              } else if (state.creatingBubble) {
                context.read<CanvasCubit>().stopCreatingBubble();
              }
            },
            onPointerMove: (PointerMoveEvent e) {
              if (state.isEditMode) {
                context.read<CanvasCubit>().moveSelectedBubble(e.localPosition);
              } else if (state.bubbleTalkingPointMode) {
                context.read<CanvasCubit>().moveTalkingPoint(e.localPosition);
              } else if (state.creatingBubble) {
                context
                    .read<CanvasCubit>()
                    .moveBubble(state.bubbleUuid!, e.localPosition);
              }
            },
            child: ColoredBox(
              color: state.background,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    if (state.image != null)
                      Align(
                        alignment: state.centerImage
                            ? Alignment.topCenter
                            : Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(64),
                          // ignore: use_decorated_box
                          child: Container(
                            key: GlobalKey(),
                            decoration: state.strokeImage == 0
                                ? null
                                : BoxDecoration(
                                    border:
                                        Border.all(width: state.strokeImage),
                                  ),
                            child: Image.memory(state.image!),
                          ),
                        ),
                      ),
                    ...state.bubbles
                        .map((Bubble bubble) => BubbleItem(bubble: bubble)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onSavePressed(
      BuildContext context, ScreenshotController screenshotController,
      {bool trim = false}) async {
    final String filename =
        "BubbleYofardev_${DateTime.now().millisecondsSinceEpoch}";
    Uint8List? bytes = await screenshotController.capture(pixelRatio: 2);
    if (bytes != null) {
      if (trim) {
        bytes = await ImageUtils.trimTransparentPixels(bytes);
      }
      SaveFileWeb.saveImage(bytes, filename);
    }
    if (context.read<CanvasCubit>().state.bubbles.isNotEmpty) {
      SaveFileWeb.saveCsv(context.read<CanvasCubit>().state.bubbles, filename);
    }
    context.read<CanvasCubit>().updateStatus(CanvasStatus.idle);
  }
}
