part of 'canvas_cubit.dart';

enum CanvasStatus { idle, loading, saving }

class CanvasState extends Equatable {
  final CanvasStatus status;
  final bool isEmpty;
  final List<Bubble> bubbles;
  final Uint8List? image;
  final bool isEditMode;
  final String font;
  final double fontSize;
  final bool bubbleTalkingPointMode;
  final String? bubbleUuid;
  final double widthBaseTriangle;
  final String? bubbleMovingUuid;
  final Color background;
  final double strokeImage;
  final bool creatingBubble;
  final double maxWidthBubble;
  final bool setMaxWidthBubble;
  final bool centerImage;
  final Offset? dragOffset;
  final BubbleType selectedBubbleType;
  final PackageInfo? packageInfo;
  final bool hideUi;
  final bool trim;

  const CanvasState({
    this.status = CanvasStatus.idle,
    this.isEmpty = true,
    this.selectedBubbleType = BubbleType.talk,
    this.bubbles = const <Bubble>[],
    this.image,
    this.isEditMode = false,
    this.font = 'OpenSans',
    this.fontSize = 24,
    this.bubbleTalkingPointMode = false,
    this.bubbleUuid,
    this.widthBaseTriangle = 10,
    this.bubbleMovingUuid,
    this.background = Colors.white,
    this.strokeImage = 0,
    this.creatingBubble = false,
    this.maxWidthBubble = 300,
    this.setMaxWidthBubble = false,
    this.centerImage = false,
    this.dragOffset,
    this.packageInfo,
    this.hideUi = false,
    this.trim = false,
  });

  CanvasState copyWith(
      {CanvasStatus? status,
      bool? isEmpty,
      List<Bubble>? bubbles,
      Uint8List? image,
      bool? isYellowBg,
      bool? isEditMode,
      bool? isRoundBubble,
      String? font,
      double? fontSize,
      bool? bubbleTalkingPointMode,
      String? bubbleUuid,
      double? widthBaseTriangle,
      String? bubbleMovingUuid,
      Color? background,
      double? strokeImage,
      bool? creatingBubble,
      double? maxWidthBubble,
      bool? setMaxWidthBubble,
      bool? centerImage,
      bool? clearImage,
      Offset? dragOffset,
      BubbleType? selectedBubbleType,
      PackageInfo? packageInfo,
      bool? hideUi,
      bool? trim}) {
    return CanvasState(
        status: status ?? this.status,
        isEmpty: isEmpty ?? this.isEmpty,
        selectedBubbleType: selectedBubbleType ?? this.selectedBubbleType,
        bubbles: bubbles ?? this.bubbles,
        image: clearImage == true ? null : image ?? this.image,
        isEditMode: isEditMode ?? this.isEditMode,
        font: font ?? this.font,
        fontSize: fontSize ?? this.fontSize,
        bubbleTalkingPointMode:
            bubbleTalkingPointMode ?? this.bubbleTalkingPointMode,
        bubbleUuid: bubbleUuid ?? this.bubbleUuid,
        widthBaseTriangle: widthBaseTriangle ?? this.widthBaseTriangle,
        bubbleMovingUuid: bubbleMovingUuid ?? this.bubbleMovingUuid,
        background: background ?? this.background,
        strokeImage: strokeImage ?? this.strokeImage,
        creatingBubble: creatingBubble ?? this.creatingBubble,
        maxWidthBubble: maxWidthBubble ?? this.maxWidthBubble,
        setMaxWidthBubble: setMaxWidthBubble ?? this.setMaxWidthBubble,
        centerImage: centerImage ?? this.centerImage,
        dragOffset: dragOffset ?? this.dragOffset,
        packageInfo: packageInfo ?? this.packageInfo,
        hideUi: hideUi ?? this.hideUi,
        trim: trim ?? this.trim);
  }

  @override
  List<Object?> get props => <Object?>[
        status,
        isEmpty,
        bubbles,
        image,
        isEditMode,
        font,
        fontSize,
        bubbleTalkingPointMode,
        bubbleUuid,
        widthBaseTriangle,
        bubbleMovingUuid,
        background,
        strokeImage,
        creatingBubble,
        maxWidthBubble,
        setMaxWidthBubble,
        centerImage,
        dragOffset,
        selectedBubbleType,
        packageInfo,
        hideUi,
        trim
      ];

  bool get isTalkBubble => selectedBubbleType == BubbleType.talk;

  bool get hasTrailMode =>
      selectedBubbleType == BubbleType.talk ||
      selectedBubbleType == BubbleType.thought;
}
