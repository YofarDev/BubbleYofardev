// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:measured_size/measured_size.dart';
import 'package:screenshot/screenshot.dart';
import 'package:uuid/uuid.dart';
import 'package:zoom_widget/zoom_widget.dart';

import '../models/bubble.dart';
import '../res/app_colors.dart';
import '../utils/constants.dart';
import '../utils/save_file_web.dart';
import 'widgets/bubble_container.dart';
import 'widgets/talking_triangle_of_bubble.dart';
import 'widgets/tools_buttons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Bubble> _bubbles = <Bubble>[];
  final TextEditingController _textController = TextEditingController();
  final ScreenshotController _screenshotController = ScreenshotController();
  Uint8List? _image;
  late bool _isYellowBg;
  late bool _isMovingModeEnabled;
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
          _textField(),
          _buttons(),
        ],
      ),
    );
  }

//////////////////////////////// WIDGETS ////////////////////////////////

  Widget _screenshotableCanvas() => Screenshot<dynamic>(
        controller: _screenshotController,
        child: Zoom(
          maxZoomWidth: MediaQuery.of(context).size.width,
          maxZoomHeight: MediaQuery.of(context).size.height,
          backgroundColor: _background,
          initScale: 0.5,
          enableScroll: _isMovingModeEnabled,
          canvasColor: _background,
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
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(64),
                          // ignore: use_decorated_box
                          child: Container(
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
                  item.centerPoint = Offset(
                    item.position.dx + size.width / 2,
                    item.position.dy + size.height / 2,
                  );
                  item.bubbleSize = size;
                });
              },
              child: BubbleContainer(
                isYellowBg: item.isYellowBg,
                txt: item.body,
                font: item.font,
                fontSize: item.fontSize,
                isRoundBubble: item.isRound,
                movingMode:
                    _isMovingModeEnabled && item.uuid == _bubbleMovingUuid,
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
              movingMode:
                  _isMovingModeEnabled && item.uuid == _bubbleMovingUuid,
            )
        ],
      ),
    );
  }

  Widget _textField() => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(),
              color: AppColors.greyTransparent,
            ),
            width: 300,
            height: 60,
            child: TextField(
              maxLines: 3,
              controller: _textController,
              cursorColor: Colors.black,
              style: TextStyle(fontFamily: _font),
              decoration: const InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),
        ),
      );

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
            isMoveModeEnabled: _isMovingModeEnabled,
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
          ),
        ),
      );

//////////////////////////////// LISTENERS ////////////////////////////////

  void _onScreenPressing(
    PointerMoveEvent details,
  ) {
    if (_isMovingModeEnabled) {
      _moveOldBubble(details.position);
      return;
    }
    if (_bubbleTalkingPointMode) {
      final Bubble bubble =
          _bubbles.firstWhere((Bubble element) => element.uuid == _bubbleUuid);
      setState(() {
        bubble.talkingPoint = details.position;
        bubble.hasTalkingShape = true;
      });
    } else {
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
        );

        _bubbles.add(bubble);

        setState(() {
          _creatingBubble = true;
        });
      } else {
        final Bubble bubble = _bubbles
            .firstWhere((Bubble element) => element.uuid == _bubbleUuid);
        setState(() {
          bubble.position = details.position;
        });
      }
    }
  }

  void _onScreenPressed(
    PointerUpEvent details,
  ) {
    if (_isMovingModeEnabled) {
      return;
    }
    if (_bubbleTalkingPointMode) {
      final Bubble bubble =
          _bubbles.firstWhere((Bubble element) => element.uuid == _bubbleUuid);
      setState(() {
        bubble.talkingPoint = details.position;
        bubble.hasTalkingShape = true;
        bubble.relativeTalkingPoint = Offset(
          bubble.position.dx - bubble.talkingPoint!.dx,
          bubble.position.dy - bubble.talkingPoint!.dy,
        );
      });
    } else {
      _creatingBubble = false;
    }
    setState(() {
      if (_isRoundBubble) _bubbleTalkingPointMode = true;
    });
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
    if (kIsWeb) {
      final String filename = "bubbles_${DateTime.now()}";
      final Uint8List? bytes =
          await _screenshotController.capture(pixelRatio: 2);
      if (bytes != null) SaveFileWeb.saveImage(bytes, filename);
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

  void _onRemoveImageBtnPressed(){
    setState(() {
      _image = null;
    });
  }

  void _onFontSizeChanged(double value) {
    setState(() {
      _fontSize = value.roundToDouble();
    });
  }

  void _onMovingModeCheckboxPressed(bool value) {
    setState(() {
      _isMovingModeEnabled = value;
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
          content: const Text("Reset all?"),
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
    //   _initVariables();
  }

  void _onRemoveBubblePressed() {
    setState(() {
      _bubbles
          .removeWhere((Bubble element) => element.uuid == _bubbleMovingUuid);
      _bubbleMovingUuid = null;
    });
  }

  void _onBubbleTap(Bubble bubble) {
    if (!_isMovingModeEnabled) return;
    setState(() {
      _bubbleMovingUuid = bubble.uuid;
      _textController.text = bubble.body;
    });
  }

//////////////////////////////// FUNCTIONS ////////////////////////////////

  void _initVariables() {
    _image = null;
    _isYellowBg = false;
    _isMovingModeEnabled = false;
    _isRoundBubble = true;
    _font = Constants.availableFonts.first;
    _fontSize = 16;
    _bubbleTalkingPointMode = false;
    _widthBaseTriangle = 10;
    _background = const Color.fromARGB(0, 255, 255, 255);
    _strokeImage = 0;
    _bubbles.clear();
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

  void _listenerTextField() {
    _textController.addListener(() {
      if (!_isMovingModeEnabled) return;
      final Bubble bubble = _bubbles
          .firstWhere((Bubble element) => element.uuid == _bubbleMovingUuid);
      setState(() {
        bubble.body = _textController.text;
      });
    });
  }
}
