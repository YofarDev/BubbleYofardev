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
              const SizedBox(height: 32),
              _backgroundColorPickerBtn(),
              const SizedBox(height: 32),
              _fontPicker(),
              const SizedBox(height: 32),
              _fontSizePicker(),
              const SizedBox(height: 32),
              _getCheckbox(
                context,
                'Round bubble',
                onBubbleModelCheckboxPressed,
                isBubbleMode,
              ),
              const SizedBox(height: 32),
              _getCheckbox(
                context,
                'Yellow background',
                onYellowBgCheckboxPressed,
                isYellowBg,
                color: AppColors.yellow,
              ),
              const SizedBox(height: 32),
              _getCheckbox(
                context,
                'Moving mode',
                onMoveModeCheckboxPressed,
                isMoveModeEnabled,
              ),
              const SizedBox(height: 32),
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
              const SizedBox(height: 32),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (displayConfirmBubble) _sliderWidthBaseTriangle(),
                  if (displayConfirmBubble)
                    _floatingBtn(
                      Icons.check,
                      'Confirm bubble',
                      onConfirmBubblePressed,
                      color: AppColors.yellow,
                    ),
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
              )
            ],
          ),
        ),
      ),
    );
  }

//////////////////////////////// WIDGETS ////////////////////////////////

  Widget _backgroundColorPickerBtn() => MaterialButton(
        onPressed: onBackgroundColorPickerPressed,
        color: AppColors.primary,
        child: const Text(
          'Background color',
          style: TextStyle(color: Colors.white),
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
            width: 100,
            child: Slider(
              activeColor: AppColors.primary,
              inactiveColor: AppColors.primaryTransparent,
              value: fontSize,
              onChanged: onFontSizedChanged,
              min: 10,
              max: 80,
              divisions: 80 - 10,
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

  Widget _sliderWidthBaseTriangle() => Slider(
        value: widthBaseTriangle,
        onChanged: onWidthBaseTriangleChanged,
        min: 4,
        max: 40,
        activeColor: AppColors.yellow,
        inactiveColor: AppColors.yellowTransparent,
      );

//////////////////////////////// LISTENERS ////////////////////////////////

//////////////////////////////// FUNCTIONS ////////////////////////////////
}
