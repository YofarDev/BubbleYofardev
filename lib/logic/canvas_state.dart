part of 'canvas_cubit.dart';

class CanvasState extends Equatable {
  final bool isEmpty;
  final List<Bubble> bubbles;
  final Uint8List? image;
  final bool isYellowBg;
  final bool isEditMode;
  final bool isRoundBubble;
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

  const CanvasState({
    this.isEmpty = true,
    this.selectedBubbleType = BubbleType.talk,
    this.bubbles = const <Bubble>[],
    this.image,
    this.isYellowBg = false,
    this.isEditMode = false,
    this.isRoundBubble = true,
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
  });

  CanvasState copyWith({
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
  }) {
    return CanvasState(
      isEmpty: isEmpty ?? this.isEmpty,
      selectedBubbleType: selectedBubbleType ?? this.selectedBubbleType,
      bubbles: bubbles ?? this.bubbles,
      image: clearImage == true ? null : image ?? this.image,
      isYellowBg: isYellowBg ?? this.isYellowBg,
      isEditMode: isEditMode ?? this.isEditMode,
      isRoundBubble: isRoundBubble ?? this.isRoundBubble,
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
    );
  }

  @override
  List<Object?> get props => <Object?>[
        isEmpty,
        bubbles,
        image,
        isYellowBg,
        isEditMode,
        isRoundBubble,
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
        packageInfo
      ];


      bool get isTalkBubble => selectedBubbleType == BubbleType.talk;
}
