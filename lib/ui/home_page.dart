// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:measured_size/measured_size.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../logic/canvas_cubit.dart';
import '../models/bubble.dart';
import '../utils/save_file_web.dart';
import 'widgets/bubble_container.dart';
import 'widgets/bubble_text_field.dart';
import 'widgets/talking_triangle_of_bubble.dart';
import 'widgets/thought_bubble/thought_bubble.dart';
import 'widgets/thought_bubble/thought_bubble_tail.dart';
import 'widgets/tools_buttons.dart';
import 'widgets/transparent_grid.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeView();
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  final GlobalKey _imageKey = GlobalKey();
  final TextEditingController _textController = TextEditingController();
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CanvasCubit, CanvasState>(
        builder: (BuildContext context, CanvasState state) {
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              const TransparentGrid(),
              _screenshotableCanvas(state),
              if (!state.isEditMode)
                BubbleTextField(
                  font: state.font,
                  controller: _textController,
                  setMaxWidthBubble: state.setMaxWidthBubble,
                  onMaxWidthBubbleChanged:
                      context.read<CanvasCubit>().changeMaxWidthBubble,
                  onSetMaxWidthBubbleChanged: (bool? value) {
                    if (value != null) {
                      context
                          .read<CanvasCubit>()
                          .toggleSetMaxWidthBubble(value);
                    }
                  },
                  maxWidthBubble: state.maxWidthBubble,
                ),
              _buttons(state),
              if (state.isEmpty) _youtubeFrame(),
            ],
          );
        },
      ),
    );
  }

  //////////////////////////////// WIDGETS ////////////////////////////////

  Widget _youtubeFrame() => Column(
        children: <Widget>[
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              launchUrl(
                Uri.parse('https://github.com/YofarDev/BubbleYofardev'),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/github_logo.png',
                  width: 30,
                ),
                const SizedBox(width: 8),
                const Text(
                  "Code source of the project",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          const Text(
            "Quick youtube presentation :",
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              child: Container(
                decoration: BoxDecoration(border: Border.all()),
                width: 600,
                child: YoutubePlayer(
                  controller: YoutubePlayerController.fromVideoId(
                    videoId: 'F8dt5BEC8as',
                    params:
                        const YoutubePlayerParams(showFullscreenButton: true),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: Colors.greenAccent.withAlpha(50),
                borderRadius: BorderRadius.circular(8)),
            child: const Text(
                "Update 25/06/2025 : Code refactoring + small UI changes",
                style: TextStyle(fontFamily: 'OpenSans', fontSize: 12)),
          ),
          const SizedBox(height: 64),
          _centeredLoadBtn(),
        ],
      );

  Widget _centeredLoadBtn() => Center(
        child: InkWell(
          onTap: _onLoadImagePressed,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 204, 0),
              border: Border.all(),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              children: <Widget>[
                Icon(Icons.image, color: Colors.white),
                Text("Load an image", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      );

  Widget _screenshotableCanvas(CanvasState state) => Screenshot(
        controller: _screenshotController,
        child: Listener(
          onPointerDown: (PointerDownEvent e) {
            if (state.isEditMode) {
              context
                  .read<CanvasCubit>()
                  .selectBubbleAtPosition(e.localPosition);
            } else if (state.bubbleTalkingPointMode) {
              context.read<CanvasCubit>().setTalkingPoint(e.localPosition);
            } else {
              context
                  .read<CanvasCubit>()
                  .startCreatingBubble(e.localPosition, _textController.text);
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
                          key: _imageKey,
                          decoration: state.strokeImage == 0
                              ? null
                              : BoxDecoration(
                                  border: Border.all(width: state.strokeImage),
                                ),
                          child: Image.memory(state.image!),
                        ),
                      ),
                    ),
                  ...state.bubbles
                      .map((Bubble item) => _getBubble(item, state)),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _getBubble(Bubble item, CanvasState state) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: item.position.dx,
          top: item.position.dy,
          child: MeasuredSize(
            onChange: (Size size) {
              context.read<CanvasCubit>().updateBubbleSize(item.uuid, size);
            },
            child: item.type == BubbleType.thought
                ? ThoughtBubble(
                    movingMode:
                        state.isEditMode && item.uuid == state.bubbleMovingUuid,
                    child: Text(
                      item.body,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: item.font, fontSize: item.fontSize),
                    ),
                  )
                : BubbleContainer(
                    isYellowBg: item.isYellowBg,
                    txt: item.body,
                    font: item.font,
                    fontSize: item.fontSize,
                    isRoundBubble: item.isRound,
                    movingMode:
                        state.isEditMode && item.uuid == state.bubbleMovingUuid,
                    widthBubble: item.maxWidthBubble,
                  ),
          ),
        ),
        if (item.bubbleSize != null &&
            item.centerPoint != null &&
            item.talkingPoint != null)
          if (item.type == BubbleType.talk)
            TalkingTriangleOfBubble(
              center: item.centerPoint!,
              talkingPoint: item.talkingPoint!,
              sizeBubble: item.bubbleSize!,
              widthBaseTriangle: item.bubbleSize!.width /
                  (item.widthBaseTriangle ?? state.widthBaseTriangle),
              movingMode:
                  state.isEditMode && item.uuid == state.bubbleMovingUuid,
            )
          else
            ThoughtBubbleTail(
              start: _getIntersectionPoint(
                item.centerPoint!,
                item.talkingPoint!,
                item.bubbleSize!,
              ),
              end: item.talkingPoint!,
              isSelected:
                  state.isEditMode && item.uuid == state.bubbleMovingUuid,
            ),
      ],
    );
  }

  Widget _buttons(CanvasState state) => Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ToolsButtons(
            onLoadImagePressed: _onLoadImagePressed,
            onLoadDialogsCsvPressed: _onLoadCsvPressed,
            onSavePressed: _onSavePressed,
            onBackgroundColorPickerPressed: _onBackgroundColorPickerPressed,
          ),
        ),
      );

  //////////////////////////////// LISTENERS ////////////////////////////////

  void _onLoadImagePressed() async {
    final FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      context.read<CanvasCubit>().loadImage(result.files.single.bytes!);
    }
  }

  void _onLoadCsvPressed() async {
    final FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowedExtensions: <String>['csv'], type: FileType.custom);
    if (result != null) {
      final bool centerImage =
          result.files.single.name.contains('_centeredImage');
      final String csv = utf8.decode(result.files.single.bytes!);
      context
          .read<CanvasCubit>()
          .loadBubblesFromCsv(csv, centerImage: centerImage);
    }
  }

  void _onSavePressed() async {
    const String filename = "bubble_yofardev";

    final Uint8List? bytes = await _screenshotController.capture(pixelRatio: 2);
    if (bytes != null) {
      SaveFileWeb.saveImage(bytes, filename);
    }
    if (context.read<CanvasCubit>().state.bubbles.isNotEmpty) {
      SaveFileWeb.saveCsv(context.read<CanvasCubit>().state.bubbles, filename);
    }
  }

  void _onBackgroundColorPickerPressed() {
    context.read<CanvasCubit>().hideYoutubeFrame();
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Background color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: context.read<CanvasCubit>().state.background,
            onColorChanged: context.read<CanvasCubit>().changeBackgroundColor,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
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
