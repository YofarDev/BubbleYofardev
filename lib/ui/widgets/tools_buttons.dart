// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';

import '../../logic/canvas_cubit.dart';
import '../../models/bubble.dart';
import '../../res/app_colors.dart';
import '../../utils/constants.dart';
import 'bubble_shape_picker.dart';

class ToolsButtons extends StatelessWidget {
  final Function() onLoadImagePressed;
  final Function() onLoadDialogsCsvPressed;
  final Function() onSavePressed;
  final Function() onBackgroundColorPickerPressed;

  const ToolsButtons({
    super.key,
    required this.onLoadImagePressed,
    required this.onLoadDialogsCsvPressed,
    required this.onSavePressed,
    required this.onBackgroundColorPickerPressed,
  });

  @override
  Widget build(BuildContext context) {
    final CanvasState state = context.watch<CanvasCubit>().state;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              if (state.image != null) _centerImageCheckbox(context),
              const SizedBox(height: 16),
              //  _bubbleTypePicker(context, state),
              BubbleShapePicker(
                selected: state.selectedBubbleType,
              ),
              const SizedBox(height: 16),
              if (state.image != null)
                _button(
                  "Remove image",
                  context.read<CanvasCubit>().removeImage,
                  color: Colors.red[400],
                ),
              if (state.image != null) _strokeImageSlider(context, state),
              _button("Background color", onBackgroundColorPickerPressed),
              const SizedBox(height: 16),
              _fontPicker(context, state),
              const SizedBox(height: 8),
              _fontSizePicker(context, state),
              const SizedBox(height: 8),
              if (state.isTalkBubble)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _getCheckbox(
                    context,
                    'Round bubble',
                    context.read<CanvasCubit>().toggleBubbleMode,
                    state.isRoundBubble,
                  ),
                ),
              if (state.isTalkBubble)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _getCheckbox(
                    context,
                    'Yellow background',
                    context.read<CanvasCubit>().toggleYellowBg,
                    state.isYellowBg,
                    color: AppColors.yellow,
                  ),
                ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.edit, size: 16, color: Colors.black54),
                  const SizedBox(width: 4),
                  _getCheckbox(
                    context,
                    'Edit mode',
                    (_) => context.read<CanvasCubit>().toggleEditMode(),
                    state.isEditMode,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _floatingBtn(
                    Icons.image,
                    'Load image',
                    onLoadImagePressed,
                    color: AppColors.yellow,
                  ),
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
                  _floatingBtn(
                    Icons.restart_alt,
                    'Restore default settings',
                    () => context.read<CanvasCubit>().init(),
                    color: Colors.red[400],
                  ),
                  const SizedBox(width: 16),
                  _floatingBtn(
                    Icons.subdirectory_arrow_left,
                    'Cancel last',
                    context.read<CanvasCubit>().cancelLastBubble,
                  ),
                  if (!state.bubbleTalkingPointMode) const SizedBox(width: 16),
                  if (!state.bubbleTalkingPointMode)
                    _floatingBtn(Icons.save, 'Save png + csv', onSavePressed),
                ],
              ),
              if (state.bubbleTalkingPointMode) const SizedBox(height: 16),
              if (state.bubbleTalkingPointMode)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (state.bubbleMovingUuid != null)
                      _floatingBtn(
                        Icons.delete,
                        'Remove bubble',
                        context.read<CanvasCubit>().removeBubble,
                        color: AppColors.yellow,
                      ),
                    const SizedBox(width: 16),
                    _sliderWidthBaseTriangle(context, state),
                    _floatingBtn(
                      Icons.check,
                      'Confirm bubble',
                      context.read<CanvasCubit>().confirmBubble,
                      color: AppColors.yellow,
                    ),
                  ],
                ),
              _contact(context),
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

  Widget _bubbleTypePicker(BuildContext context, CanvasState state) =>
      ToggleButtons(
        isSelected: BubbleType.values
            .map((BubbleType e) => e == state.selectedBubbleType)
            .toList(),
        onPressed: (int index) => context
            .read<CanvasCubit>()
            .changeBubbleType(BubbleType.values[index]),
        children: const <Widget>[
          Icon(Icons.chat_bubble),
          Icon(Icons.cloud),
        ],
      );

  Widget _fontPicker(BuildContext context, CanvasState state) =>
      DropdownButton<dynamic>(
        items: Constants.availableFonts
            .map(
              (String e) => DropdownMenuItem<dynamic>(value: e, child: Text(e)),
            )
            .toList(),
        value: state.font,
        onChanged: (dynamic value) =>
            context.read<CanvasCubit>().changeFont(value as String),
      );

  Widget _strokeImageSlider(BuildContext context, CanvasState state) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 150,
              child: Slider(
                divisions: 16,
                max: 16,
                activeColor: AppColors.primary,
                inactiveColor: AppColors.primaryTransparent,
                value: state.strokeImage,
                onChanged: context.read<CanvasCubit>().changeStrokeImage,
              ),
            ),
            Text("Stroke image : ${state.strokeImage}"),
          ],
        ),
      );

  Widget _centerImageCheckbox(BuildContext context) {
    final bool centerImage =
        context.select((CanvasCubit cubit) => cubit.state.centerImage);
    return _getCheckbox(
      context,
      "Center image",
      (_) => context.read<CanvasCubit>().toggleCenterImage(),
      centerImage,
      color: AppColors.yellow,
    );
  }

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

  Widget _fontSizePicker(BuildContext context, CanvasState state) => Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 150,
            child: Slider(
              activeColor: AppColors.primary,
              inactiveColor: AppColors.primaryTransparent,
              value: state.fontSize,
              onChanged: context.read<CanvasCubit>().changeFontSize,
              min: 10,
              max: 40,
              divisions: 40,
            ),
          ),
          Text("Font size : ${state.fontSize}"),
        ],
      );

  Widget _floatingBtn(
    IconData icon,
    String tag,
    Function() onPressed, {
    Color? color,
  }) =>
      FloatingActionButton(
        foregroundColor: Colors.white,
        onPressed: onPressed,
        heroTag: tag,
        tooltip: tag,
        backgroundColor: color ?? AppColors.primary,
        child: Icon(icon),
      );

  Widget _sliderWidthBaseTriangle(BuildContext context, CanvasState state) =>
      SizedBox(
        width: 100,
        child: Slider(
          value: state.widthBaseTriangle,
          onChanged: context.read<CanvasCubit>().changeWidthBaseTriangle,
          min: 4,
          max: 40,
          activeColor: AppColors.yellow,
          inactiveColor: AppColors.yellowTransparent,
        ),
      );

  Widget _contact(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 32),
        child: ParsedText(
          text: "Contact : yofardev@gmail.com",
          style: const TextStyle(fontSize: 12),
          parse: <MatchText>[
            MatchText(
              type: ParsedType.EMAIL,
              style: const TextStyle(fontSize: 12, color: Colors.blue),
              onTap: (String email) => _onEmailTap(
                context,
                email,
              ),
            ),
          ],
        ),
      );

//////////////////////////////// LISTENERS ////////////////////////////////

  void _onEmailTap(BuildContext context, String email) {
    Clipboard.setData(ClipboardData(text: email)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email address copied to clipboard")),
      );
    });
  }

//////////////////////////////// FUNCTIONS ////////////////////////////////
}
