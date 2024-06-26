// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:measured_size/measured_size.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../models/bubble.dart';
import '../res/app_colors.dart';
import '../utils/constants.dart';
import '../utils/save_file_web.dart';
import 'widgets/bubble_container.dart';
import 'widgets/bubble_text_field.dart';
import 'widgets/talking_triangle_of_bubble.dart';
import 'widgets/tools_buttons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey _imageKey = GlobalKey();

  final List<Bubble> _bubbles = <Bubble>[];
  final TextEditingController _textController = TextEditingController();
  final ScreenshotController _screenshotController = ScreenshotController();
  Uint8List? _image;
  late bool _isYellowBg;
  late bool _isEditMode;
  late bool _isRoundBubble;
  late String _font;
  late double _fontSize;
  late bool _bubbleTalkingPointMode;
  late String _bubbleUuid;
  late double _widthBaseTriangle;
  String? _bubbleMovingUuid;
  late Color _background;
  late double _strokeImage;
  bool _creatingBubble = false;
  late double _maxWidthBubble;
  late bool _setMaxWidthBubble;
  late bool _centerImage;

  @override
  void initState() {
    super.initState();
    _listenerTextField();
    _initVariables();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _screenshotableCanvas(),
          BubbleTextField(
            font: _font,
            controller: _textController,
            setMaxWidthBubble: _setMaxWidthBubble,
            onMaxWidthBubbleChanged: _onMaxWidthBubbleChanged,
            onSetMaxWidthBubbleChanged: _onSetMaxWidthBubbleChanged,
            maxWidthBubble: _maxWidthBubble,
          ),
          _buttons(),
          if (_image == null) _youtubeFrame(),
        ],
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
          const SizedBox(height: 64),
          _centeredLoadBtn(),
        ],
      );

  Widget _centeredLoadBtn() => Center(
        child: InkWell(
          onTap: _onLoadImagePressed,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.yellowTransparent,
              border: Border.all(),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text("Load an image"),
          ),
        ),
      );

  Widget _screenshotableCanvas() => Screenshot(
        controller: _screenshotController,
        child: Listener(
          onPointerUp: (PointerUpEvent e) {
            _onScreenPressed(e);
          },
          onPointerMove: (PointerMoveEvent e) {
            _onScreenPressing(e);
          },
          child: ColoredBox(
            color: _background,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  if (_image != null)
                    Align(
                      alignment: _centerImage
                          ? Alignment.topCenter
                          : Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(64),
                        // ignore: use_decorated_box
                        child: Container(
                          key: _imageKey,
                          decoration: _strokeImage == 0
                              ? null
                              : BoxDecoration(
                                  border: Border.all(width: _strokeImage),
                                ),
                          child: Image.memory(_image!),
                        ),
                      ),
                    ),
                  // ..._bubbles,
                  ..._bubbles.map((Bubble item) => _getBubble(item)),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _getBubble(Bubble item) {
    return GestureDetector(
      onTap: () => _onBubbleTap(item),
      onTapDown: (_) => _onBubbleTap(item),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: item.position.dx,
            top: item.position.dy,
            child: MeasuredSize(
              onChange: (Size size) {
                setState(() {
                  item.bubbleSize = size;
                });
              },
              child: BubbleContainer(
                isYellowBg: item.isYellowBg,
                txt: item.body,
                font: item.font,
                fontSize: item.fontSize,
                isRoundBubble: item.isRound,
                movingMode: _isEditMode && item.uuid == _bubbleMovingUuid,
                widthBubble: item.maxWidthBubble,
              ),
            ),
          ),
          if (item.hasTalkingShape &&
              item.bubbleSize != null &&
              item.centerPoint != null &&
              item.talkingPoint != null)
            TalkingTriangleOfBubble(
              center: item.centerPoint!,
              talkingPoint: item.talkingPoint!,
              sizeBubble: item.bubbleSize!,
              widthBaseTriangle: item.bubbleSize!.width /
                  (item.widthBaseTriangle ?? _widthBaseTriangle),
              movingMode: _isEditMode && item.uuid == _bubbleMovingUuid,
            ),
        ],
      ),
    );
  }

  Widget _buttons() => Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ToolsButtons(
            onLoadImagePressed: _onLoadImagePressed,
            onLoadDialogsCsvPressed: _onLoadCsvPressed,
            onCancelLastPressed: _onCancelLastPressed,
            onSavePressed: _onSavePressed,
            onResetPressed: _onResetPressed,
            onMoveModeCheckboxPressed: _onMovingModeCheckboxPressed,
            onYellowBgCheckboxPressed: _onYellowBgCheckboxPressed,
            isMoveModeEnabled: _isEditMode,
            isYellowBg: _isYellowBg,
            font: _font,
            onFontChanged: _onFontChanged,
            fontSize: _fontSize,
            onFontSizedChanged: _onFontSizeChanged,
            isBubbleMode: _isRoundBubble,
            onBubbleModelCheckboxPressed: _onBubbleModeCheckboxPressed,
            displayConfirmBubble: _bubbleTalkingPointMode,
            onConfirmBubblePressed: _onConfirmBubbleBtnPressed,
            displayRemoveBtn: _bubbleMovingUuid != null,
            onRemovedPressed: _onRemoveBubblePressed,
            widthBaseTriangle: _widthBaseTriangle,
            onWidthBaseTriangleChanged: _onWidthBaseTriangle,
            onBackgroundColorPickerPressed: _onBackgroundColorPickerPressed,
            hasImage: _image != null,
            onStrokeChanged: _onStrokeImageChanged,
            strokeImage: _strokeImage,
            onRemoveImageBtnPressed: _onRemoveImageBtnPressed,
            centerImage: _centerImage,
            onCenterImagePressed: _onCenterImagePressed,
          ),
        ),
      );

//////////////////////////////// LISTENERS ////////////////////////////////

  void _onScreenPressing(
    PointerMoveEvent details,
  ) {
    // Edit mode
    if (_isEditMode) {
      _moveOldBubble(details.position);
      return;
    }

    // Bubble talking point
    if (_bubbleTalkingPointMode && !_creatingBubble) {
      _moveTalkingPoint(details.position);
      return;
    }

    // Bubble init
    if (!_creatingBubble) {
      _bubbleUuid = const Uuid().v4();
      final Bubble bubble = Bubble(
        uuid: _bubbleUuid,
        body: _textController.text,
        isRound: _isRoundBubble,
        isYellowBg: _isYellowBg,
        position: details.position,
        font: _font,
        fontSize: _fontSize,
        maxWidthBubble: _setMaxWidthBubble ? _maxWidthBubble : null,
      );

      _bubbles.add(bubble);

      setState(() {
        _creatingBubble = true;
      });

      // Bubble moving
    } else {
      final Bubble bubble =
          _bubbles.firstWhere((Bubble element) => element.uuid == _bubbleUuid);

      setState(() {
        bubble.position = details.position;
      });
    }
  }

  void _onScreenPressed(
    PointerUpEvent details,
  ) {
    if (_isEditMode) {
      return;
    }

    // After creating talking point
    if (_bubbleTalkingPointMode && !_creatingBubble) {
      _moveTalkingPoint(details.position, isPressing: false);
    }

    // After creating a bubble
    if (_creatingBubble) {
      if (_isRoundBubble) {
        setState(() {
          _bubbleTalkingPointMode = true;
        });
      }
      final Bubble bubble =
          _bubbles.firstWhere((Bubble element) => element.uuid == _bubbleUuid);
      if (bubble.bubbleSize != null) {
        bubble.centerPoint = Offset(
          bubble.position.dx + bubble.bubbleSize!.width / 2,
          bubble.position.dy + bubble.bubbleSize!.height / 2,
        );
      }
      _creatingBubble = false;
    }
  }

  void _onCancelLastPressed() {
    if (_bubbles.isEmpty) return;
    setState(() {
      _bubbles.removeLast();
      _bubbleTalkingPointMode = false;
      _bubbleMovingUuid = null;
    });
  }

  void _onLoadImagePressed() async {
    final FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      _image = result.files.single.bytes;
      setState(() {});
    }
  }

  void _onLoadCsvPressed() async {
    final FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowedExtensions: <String>['csv'], type: FileType.custom);
    if (result != null) {
      _centerImage = result.files.single.name.contains('_centeredImage');
      final String csv = utf8.decode(result.files.single.bytes!);
      final List<String> rows = csv.split("\n");
      final List<Bubble> list = <Bubble>[];
      int i = 0;
      for (final String row in rows) {
        if (i > 0 && row.isNotEmpty) {
          list.add(Bubble.fromCsv(row.split(';')));
        }
        i++;
      }

      setState(() {
        _bubbles.clear();
        _bubbles.addAll(list);
      });
    }
  }

  void _onSavePressed() async {
    final String uuid = const Uuid().v4();
    final String filename = "bubble_yofardev_$uuid";

    final Uint8List? bytes = await _screenshotController.capture(pixelRatio: 2);
    if (bytes != null) {
      SaveFileWeb.saveImage(bytes, filename);
    }
    if (_bubbles.isNotEmpty) {
      SaveFileWeb.saveCsv(_bubbles, filename);
    }
  }

  void _onYellowBgCheckboxPressed(bool value) {
    setState(() {
      _isYellowBg = value;
    });
  }

  void _onBubbleModeCheckboxPressed(bool value) {
    setState(() {
      _isRoundBubble = value;
      if (_isRoundBubble) _isYellowBg = false;
    });
  }

  void _onWidthBaseTriangle(double value) {
    setState(() {
      _widthBaseTriangle = value;
    });
  }

  void _onStrokeImageChanged(double value) {
    setState(() {
      _strokeImage = value;
    });
  }

  void _onBackgroundColorPickerPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Background color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _background,
            onColorChanged: (Color value) {
              setState(() {
                _background = value;
              });
            },
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

  void _onConfirmBubbleBtnPressed() {
    setState(() {
      _bubbles
          .firstWhere((Bubble element) => element.uuid == _bubbleUuid)
          .widthBaseTriangle = _widthBaseTriangle;
      _bubbleTalkingPointMode = false;
    });
  }

  void _onFontChanged(String value) {
    setState(() {
      _font = value;
    });
  }

  void _onRemoveImageBtnPressed() {
    setState(() {
      _image = null;
    });
  }

  void _onFontSizeChanged(double value) {
    setState(() {
      _fontSize = value.roundToDouble();
    });
  }

  void _onCenterImagePressed(bool? value) {
    setState(() {
      _centerImage = !_centerImage;
    });
  }

  void _onMovingModeCheckboxPressed(bool value) {
    setState(() {
      _isEditMode = value;
      _bubbleTalkingPointMode = false;
      if (!value) {
        _bubbleMovingUuid = null;
      }
    });
  }

  void _onResetPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            "Restore default settings?\n\n(keep the image and the bubbles)",
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _initVariables();
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  void _onRemoveBubblePressed() {
    setState(() {
      _bubbles
          .removeWhere((Bubble element) => element.uuid == _bubbleMovingUuid);
      _bubbleMovingUuid = null;
    });
  }

  void _onBubbleTap(Bubble bubble) {
    if (!_isEditMode) return;
    setState(() {
      _bubbleMovingUuid = bubble.uuid;
      _textController.text = bubble.body;
    });
  }

  void _onMaxWidthBubbleChanged(double maxWidth) {
    setState(() {
      _maxWidthBubble = maxWidth.toInt().toDouble();
    });
  }

  void _onSetMaxWidthBubbleChanged(bool? value) {
    setState(() {
      _setMaxWidthBubble = !_setMaxWidthBubble;
      if (!_setMaxWidthBubble) {
        _maxWidthBubble = 300;
      }
    });
  }

//////////////////////////////// FUNCTIONS ////////////////////////////////

  void _initVariables() {
    _isYellowBg = false;
    _isEditMode = false;
    _isRoundBubble = true;
    _font = Constants.availableFonts.first;
    _fontSize = 16;
    _bubbleTalkingPointMode = false;
    _widthBaseTriangle = 10;
    _background = const Color.fromARGB(0, 255, 255, 255);
    _strokeImage = 0;
    _creatingBubble = false;
    _maxWidthBubble = 300;
    _setMaxWidthBubble = true;
    _centerImage = false;
    setState(() {});
  }

  void _moveOldBubble(Offset position) {
    final Bubble bubble = _bubbles
        .firstWhere((Bubble element) => element.uuid == _bubbleMovingUuid);
    setState(() {
      bubble.position = position;
      if (bubble.hasTalkingShape) {
        bubble.centerPoint = Offset(
          position.dx + bubble.bubbleSize!.width / 2,
          position.dy + bubble.bubbleSize!.height / 2,
        );
        bubble.talkingPoint = bubble.position - bubble.relativeTalkingPoint;
      }
    });
  }

  void _moveTalkingPoint(Offset position, {bool isPressing = true}) {
    final Bubble bubble =
        _bubbles.firstWhere((Bubble element) => element.uuid == _bubbleUuid);
    setState(() {
      bubble.talkingPoint = position;
      bubble.hasTalkingShape = true;
    });

    if (!isPressing) {
      bubble.relativeTalkingPoint = Offset(
        bubble.position.dx - bubble.talkingPoint!.dx,
        bubble.position.dy - bubble.talkingPoint!.dy,
      );
    }
  }

  void _listenerTextField() {
    _textController.addListener(() {
      if (!_isEditMode) return;
      final Bubble bubble = _bubbles
          .firstWhere((Bubble element) => element.uuid == _bubbleMovingUuid);
      setState(() {
        bubble.body = _textController.text;
      });
    });
  }
}
