import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

import '../models/bubble.dart';

part 'canvas_state.dart';

class CanvasCubit extends Cubit<CanvasState> {
  CanvasCubit() : super(const CanvasState());

  void init() {
    emit(
      state.copyWith(
        isYellowBg: false,
        isEditMode: false,
        isRoundBubble: true,
        font: 'Anime',
        fontSize: 16,
        bubbleTalkingPointMode: false,
        widthBaseTriangle: 10,
        background: const Color.fromARGB(0, 255, 255, 255),
        strokeImage: 0,
        creatingBubble: false,
        maxWidthBubble: 300,
        setMaxWidthBubble: false,
        centerImage: false,
      ),
    );
    _getPackageInfo();
  }

  void _getPackageInfo() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    emit(state.copyWith(packageInfo: packageInfo));
  }

  void loadImage(Uint8List imageBytes) {
    emit(state.copyWith(image: imageBytes, isEmpty: false));
  }

  void loadBubblesFromCsv(String csvData, {required bool centerImage}) {
    final List<String> rows = csvData.split("\n");
    final List<Bubble> bubbles = <Bubble>[];
    int i = 0;
    for (final String row in rows) {
      if (i > 0 && row.isNotEmpty) {
        bubbles.add(Bubble.fromCsv(row.split(';')));
      }
      i++;
    }
    emit(state.copyWith(
        bubbles: bubbles, centerImage: centerImage, isEmpty: false));
  }

  void startCreatingBubble(Offset position, String text) {
    final Bubble newBubble = Bubble(
      type: state.selectedBubbleType,
      uuid: const Uuid().v4(),
      body: text,
      isRound: state.isRoundBubble,
      isYellowBg: state.isYellowBg,
      position: position,
      font: state.font,
      fontSize: state.fontSize,
      maxWidthBubble: state.setMaxWidthBubble ? state.maxWidthBubble : null,
    );

    final List<Bubble> bubbles = <Bubble>[...state.bubbles, newBubble];
    emit(
      state.copyWith(
        bubbles: bubbles,
        creatingBubble: true,
        bubbleUuid: newBubble.uuid,
        isEmpty: false,
      ),
    );
  }

  void moveBubble(String uuid, Offset position) {
    final List<Bubble> updatedBubbles = state.bubbles.map((Bubble bubble) {
      if (bubble.uuid == uuid) {
        return bubble.copyWith(position: position);
      }
      return bubble;
    }).toList();
    emit(state.copyWith(bubbles: updatedBubbles));
  }

  void stopCreatingBubble() {
    if (state.creatingBubble) {
      final Bubble bubble = state.bubbles
          .firstWhere((Bubble element) => element.uuid == state.bubbleUuid);
      final Bubble updatedBubble = bubble.copyWith(
        centerPoint: Offset(
          bubble.position.dx + (bubble.bubbleSize?.width ?? 0) / 2,
          bubble.position.dy + (bubble.bubbleSize?.height ?? 0) / 2,
        ),
      );
      final List<Bubble> updatedBubbles = state.bubbles.map((Bubble b) {
        if (b.uuid == updatedBubble.uuid) {
          return updatedBubble;
        }
        return b;
      }).toList();

      emit(
        state.copyWith(
          creatingBubble: false,
          bubbleTalkingPointMode: true,
          bubbles: updatedBubbles,
        ),
      );
    }
  }

  void addTalkingPoint(String bubbleUuid, Offset talkingPoint) {
    final List<Bubble> updatedBubbles = state.bubbles.map((Bubble bubble) {
      if (bubble.uuid == bubbleUuid) {
        return bubble.copyWith(
          talkingPoint: talkingPoint,
          hasTalkingShape: true,
        );
      }
      return bubble;
    }).toList();
    emit(state.copyWith(bubbles: updatedBubbles));
  }

  void cancelLastBubble() {
    if (state.bubbles.isNotEmpty) {
      final List<Bubble> bubbles = <Bubble>[...state.bubbles];
      bubbles.removeLast();
      emit(
        state.copyWith(
          bubbles: bubbles,
          bubbleTalkingPointMode: false,
        ),
      );
    }
  }

  void toggleYellowBg(bool value) {
    emit(state.copyWith(isYellowBg: value, bubbleTalkingPointMode: false));
  }

  void toggleBubbleMode(bool value) {
    emit(state.copyWith(
        isRoundBubble: value,
        isYellowBg: false,
        bubbleTalkingPointMode: false));
  }

  void changeWidthBaseTriangle(double value) {
    emit(state.copyWith(widthBaseTriangle: value));
  }

  void changeBubbleType(BubbleType type) {
    if (type == BubbleType.thought) {
      emit(state.copyWith(selectedBubbleType: type, isRoundBubble: true));
    }  else {
      emit(state.copyWith(selectedBubbleType: type));
    }
  }

  void changeStrokeImage(double value) {
    emit(state.copyWith(strokeImage: value, bubbleTalkingPointMode: false));
  }

  void hideYoutubeFrame() {
    emit(state.copyWith(isEmpty: false));
  }

  void changeBackgroundColor(Color value) {
    emit(state.copyWith(background: value, bubbleTalkingPointMode: false));
  }

  void confirmBubble() {
    final List<Bubble> updatedBubbles = state.bubbles.map((Bubble bubble) {
      if (bubble.uuid == state.bubbleUuid) {
        return bubble.copyWith(widthBaseTriangle: state.widthBaseTriangle);
      }
      return bubble;
    }).toList();
    emit(
      state.copyWith(
        bubbles: updatedBubbles,
        bubbleTalkingPointMode: false,
      ),
    );
  }

  void changeFont(String value) {
    emit(state.copyWith(font: value, bubbleTalkingPointMode: false));
  }

  void removeImage() {
    emit(state.copyWith(clearImage: true, bubbleTalkingPointMode: false));
  }

  void changeFontSize(double value) {
    emit(state.copyWith(
        fontSize: value.roundToDouble(), bubbleTalkingPointMode: false));
  }

  void toggleCenterImage() {
    emit(state.copyWith(
        centerImage: !state.centerImage, bubbleTalkingPointMode: false));
  }

  void changeMaxWidthBubble(double value) {
    emit(state.copyWith(maxWidthBubble: value, bubbleTalkingPointMode: false));
  }

  void toggleSetMaxWidthBubble(bool value) {
    emit(state.copyWith(
        setMaxWidthBubble: value, bubbleTalkingPointMode: false));
  }

  void selectBubble(String? uuid) {
    emit(state.copyWith(bubbleMovingUuid: uuid));
  }

  void selectBubbleAtPosition(Offset position) {
    if (state.bubbles.isEmpty) return;

    Bubble closestBubble = state.bubbles.first;
    double closestDistance = double.infinity;

    for (final Bubble bubble in state.bubbles) {
      final double distance = (bubble.centerPoint! - position).distance;
      if (distance < closestDistance) {
        closestDistance = distance;
        closestBubble = bubble;
      }
    }
    emit(state.copyWith(
      bubbleMovingUuid: closestBubble.uuid,
      dragOffset: position - closestBubble.position,
    ));
  }

  void toggleEditMode() {
    emit(state.copyWith(
        isEditMode: !state.isEditMode, bubbleTalkingPointMode: false));
  }

  void removeBubble() {
    if (state.bubbleMovingUuid != null) {
      final List<Bubble> bubbles = <Bubble>[...state.bubbles]
        ..removeWhere((Bubble b) => b.uuid == state.bubbleMovingUuid);
      emit(state.copyWith(bubbles: bubbles));
    }
  }

  void updateBubbleSize(String uuid, Size size) {
    final List<Bubble> updatedBubbles = state.bubbles.map((Bubble bubble) {
      if (bubble.uuid == uuid) {
        return bubble.copyWith(bubbleSize: size);
      }
      return bubble;
    }).toList();
    emit(state.copyWith(bubbles: updatedBubbles));
  }

  void moveSelectedBubble(Offset position) {
    if (state.dragOffset == null) return;
    final List<Bubble> updatedBubbles = state.bubbles.map((Bubble bubble) {
      if (bubble.uuid == state.bubbleMovingUuid) {
        final Offset newPosition = position - state.dragOffset!;
        final Offset newCenterPoint = Offset(
          newPosition.dx + (bubble.bubbleSize?.width ?? 0) / 2,
          newPosition.dy + (bubble.bubbleSize?.height ?? 0) / 2,
        );
        final Offset? newTalkingPoint = bubble.relativeTalkingPoint != null
            ? newCenterPoint + bubble.relativeTalkingPoint!
            : null;
        return bubble.copyWith(
          position: newPosition,
          centerPoint: newCenterPoint,
          talkingPoint: newTalkingPoint,
        );
      }
      return bubble;
    }).toList();
    emit(state.copyWith(bubbles: updatedBubbles));
  }

  void moveTalkingPoint(Offset position) {
    final List<Bubble> updatedBubbles = state.bubbles.map((Bubble bubble) {
      if (bubble.uuid == state.bubbleUuid) {
        return bubble.copyWith(talkingPoint: position);
      }
      return bubble;
    }).toList();
    emit(state.copyWith(bubbles: updatedBubbles));
  }

  void setTalkingPoint(Offset position) {
    final List<Bubble> updatedBubbles = state.bubbles.map((Bubble bubble) {
      if (bubble.uuid == state.bubbleUuid) {
        return bubble.copyWith(
          talkingPoint: position,
          hasTalkingShape: true,
          relativeTalkingPoint: position - bubble.centerPoint!,
        );
      }
      return bubble;
    }).toList();
    emit(state.copyWith(
      bubbles: updatedBubbles,
    ));
  }
}
