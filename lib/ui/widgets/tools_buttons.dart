// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../res/app_colors.dart';
import '../../utils/constants.dart';

class ToolsButtons extends StatelessWidget {
  final Function() onLoadImagePressed;
  final Function() onLoadDialogsCsvPressed;
  final Function() onCancelLastPressed;
  final Function() onSavePressed;
  final Function() onResetPressed;
  final Function() onRemovedPressed;
  final Function(bool value) onMoveModeCheckboxPressed;
  final Function(bool value) onYellowBgCheckboxPressed;
  final Function(bool value) onBubbleModelCheckboxPressed;
  final Function(String font) onFontChanged;
  final Function(double value) onFontSizedChanged;
  final Function(double value) onWidthBaseTriangleChanged;
  final double widthBaseTriangle;
  final String font;
  final double fontSize;
  final bool isMoveModeEnabled;
  final bool isYellowBg;
  final bool isBubbleMode;
  final bool displayConfirmBubble;
  final bool displayRemoveBtn;
  final Function() onConfirmBubblePressed;
  final Function() onBackgroundColorPickerPressed;
  final Function(double value) onStrokeChanged;
  final bool hasImage;
  final double strokeImage;
  final Function() onRemoveImageBtnPressed;

  const ToolsButtons({
    super.key,
    required this.onLoadImagePressed,
    required this.onLoadDialogsCsvPressed,
    required this.onCancelLastPressed,
    required this.onSavePressed,
    required this.onResetPressed,
    required this.onRemovedPressed,
    required this.onMoveModeCheckboxPressed,
    required this.onYellowBgCheckboxPressed,
    required this.onBubbleModelCheckboxPressed,
    required this.onFontChanged,
    required this.onFontSizedChanged,
    required this.onWidthBaseTriangleChanged,
    required this.widthBaseTriangle,
    required this.font,
    required this.fontSize,
    required this.isMoveModeEnabled,
    required this.isYellowBg,
    required this.isBubbleMode,
    required this.displayConfirmBubble,
    required this.displayRemoveBtn,
    required this.onConfirmBubblePressed,
    required this.onBackgroundColorPickerPressed,
    required this.onStrokeChanged,
    required this.hasImage,
    required this.strokeImage,
    required this.onRemoveImageBtnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(20),
        color: AppColors.greyTransparent,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              if (hasImage)
                _button(
                  "Remove image",
                  onRemoveImageBtnPressed,
                  color: AppColors.yellow,
                ),
              if (hasImage) const SizedBox(height: 16),
              if (hasImage) _strokeImageSlider(),
              if (hasImage) const SizedBox(height: 16),
              _button("Background color", onBackgroundColorPickerPressed),
              const SizedBox(height: 16),
              _fontPicker(),
              const SizedBox(height: 8),
              _fontSizePicker(),
              const SizedBox(height: 8),
              _getCheckbox(
                context,
                'Round bubble',
                onBubbleModelCheckboxPressed,
                isBubbleMode,
              ),
              const SizedBox(height: 8),
              _getCheckbox(
                context,
                'Yellow background',
                onYellowBgCheckboxPressed,
                isYellowBg,
                color: AppColors.yellow,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.edit, size: 16, color: Colors.black54),
                  const SizedBox(width: 4),
                  _getCheckbox(
                    context,
                    'Edit mode',
                    onMoveModeCheckboxPressed,
                    isMoveModeEnabled,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _floatingBtn(
                    Icons.restart_alt,
                    'Reset all',
                    onResetPressed,
                    color: Colors.red[400],
                  ),
                  const SizedBox(width: 16),
                  _floatingBtn(Icons.image, 'Load image', onLoadImagePressed),
                  const SizedBox(width: 16),
                  _floatingBtn(
                    Icons.file_copy,
                    'Load previous csv',
                    onLoadDialogsCsvPressed,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (displayRemoveBtn)
                    _floatingBtn(
                      Icons.delete,
                      'Remove bubble',
                      onRemovedPressed,
                      color: AppColors.yellow,
                    ),
                  const SizedBox(width: 16),
                  _floatingBtn(
                    Icons.subdirectory_arrow_left,
                    'Cancel last',
                    onCancelLastPressed,
                  ),
                  const SizedBox(width: 16),
                  _floatingBtn(Icons.save, 'Save png + csv', onSavePressed),
                ],
              ),
              if (displayConfirmBubble) const SizedBox(height: 16),
              if (displayConfirmBubble)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _sliderWidthBaseTriangle(),
                    _floatingBtn(
                      Icons.check,
                      'Confirm bubble',
                      onConfirmBubblePressed,
                      color: AppColors.yellow,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

//////////////////////////////// WIDGETS ////////////////////////////////

  Widget _button(String tag, Function() onPressed, {Color? color}) =>
      MaterialButton(
        onPressed: onPressed,
        color: color ?? AppColors.primary,
        child: Text(
          tag,
          style: const TextStyle(color: Colors.white),
        ),
      );

  Widget _fontPicker() => DropdownButton<dynamic>(
        items: Constants.availableFonts
            .map(
              (String e) => DropdownMenuItem<dynamic>(value: e, child: Text(e)),
            )
            .toList(),
        value: font,
        onChanged: (dynamic value) => onFontChanged(value as String),
      );

  Widget _strokeImageSlider() => Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 150,
            child: Slider(
              divisions: 16,
              max: 16,
              activeColor: AppColors.primary,
              inactiveColor: AppColors.primaryTransparent,
              value: strokeImage,
              onChanged: onStrokeChanged,
            ),
          ),
          Text("Stroke image : $strokeImage")
        ],
      );

  Widget _getCheckbox(
    BuildContext context,
    String txt,
    Function(bool value) onPressed,
    bool value, {
    Color color = AppColors.primary,
  }) =>
      Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(txt),
          Checkbox(
            activeColor: color,
            value: value,
            onChanged: (bool? value) {
              if (value != null) onPressed(value);
            },
          ),
        ],
      );

  Widget _fontSizePicker() => Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 150,
            child: Slider(
              activeColor: AppColors.primary,
              inactiveColor: AppColors.primaryTransparent,
              value: fontSize,
              onChanged: onFontSizedChanged,
              min: 10,
              max: 80,
              divisions: 80,
            ),
          ),
          Text("Font size : $fontSize"),
        ],
      );

  Widget _floatingBtn(
    IconData icon,
    String tag,
    Function() onPressed, {
    Color? color,
  }) =>
      FloatingActionButton(
        onPressed: onPressed,
        heroTag: tag,
        tooltip: tag,
        backgroundColor: color ?? AppColors.primary,
        child: Icon(icon),
      );

  Widget _sliderWidthBaseTriangle() => SizedBox(
        width: 100,
        child: Slider(
          value: widthBaseTriangle,
          onChanged: onWidthBaseTriangleChanged,
          min: 4,
          max: 40,
          activeColor: AppColors.yellow,
          inactiveColor: AppColors.yellowTransparent,
        ),
      );

//////////////////////////////// LISTENERS ////////////////////////////////

//////////////////////////////// FUNCTIONS ////////////////////////////////
}
