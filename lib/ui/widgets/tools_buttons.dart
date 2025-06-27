// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';

import '../../logic/canvas_cubit.dart';
import '../../models/bubble.dart';
import '../../res/app_colors.dart';
import '../../res/app_constants.dart';
import 'load_image_button.dart';
import 'tools_icon_button.dart';

class ToolsButtons extends StatelessWidget {
  const ToolsButtons({
    super.key,
  });

  void _onLoadCsvPressed(BuildContext context) async {
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

  void _onBackgroundColorPickerPressed(BuildContext context) {
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
              if (state.image != null)
                _button(
                  "Remove image",
                  context.read<CanvasCubit>().removeImage,
                  color: Colors.red[400],
                ),
              if (state.image != null) _strokeImageSlider(context, state),
              _button("Background color",
                  () => _onBackgroundColorPickerPressed(context)),
              const SizedBox(height: 16),
              _fontPicker(context, state),
              const SizedBox(height: 8),
              _fontSizePicker(context, state),
              const SizedBox(height: 8),
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
              _getCheckbox(context, 'Trim when saving',
                  (_) => context.read<CanvasCubit>().toggleTrim(), state.trim),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const LoadImageButton(
                    iconOnly: true,
                  ),
                  const SizedBox(width: 16),
                  ToolsIconButton(
                    icon: Icons.file_copy,
                    tag: 'Load previous csv',
                    onPressed: () => _onLoadCsvPressed(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ToolsIconButton(
                    icon: Icons.restart_alt,
                    tag: 'Restore default settings',
                    onPressed: context.read<CanvasCubit>().init,
                    color: Colors.red[400],
                  ),
                  const SizedBox(width: 16),
                  ToolsIconButton(
                    icon: Icons.subdirectory_arrow_left,
                    tag: 'Cancel last',
                    onPressed: context.read<CanvasCubit>().cancelLastBubble,
                  ),
                  if (!state.bubbleTalkingPointMode) const SizedBox(width: 16),
                  if (state.status == CanvasStatus.saving)
                    const CircularProgressIndicator()
                  else if (!state.bubbleTalkingPointMode)
                    ToolsIconButton(
                        icon: Icons.save,
                        tag: 'Save png + csv',
                        onPressed: () => context
                            .read<CanvasCubit>()
                            .updateStatus(CanvasStatus.saving)),
                ],
              ),
              if (state.bubbleTalkingPointMode || state.isEditMode)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (state.isEditMode)
                        ToolsIconButton(
                          icon: Icons.delete,
                          tag: 'Remove bubble',
                          onPressed: context.read<CanvasCubit>().removeBubble,
                          color: AppColors.yellow,
                        ),
                      if (!state.isEditMode && state.isTalkBubble)
                        _sliderWidthBaseTriangle(context, state),
                      if (!state.isEditMode &&
                          state.selectedBubbleType != BubbleType.scream)
                        ToolsIconButton(
                          icon: Icons.check,
                          tag: 'Confirm bubble',
                          onPressed: context.read<CanvasCubit>().confirmBubble,
                          color: AppColors.yellow,
                        ),
                    ],
                  ),
                ),
              _contact(context),
              const SizedBox(height: 8),
              if (state.packageInfo != null)
                Text("v${state.packageInfo!.version}",
                    style: const TextStyle(color: Colors.grey, fontSize: 9)),
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

  Widget _fontPicker(BuildContext context, CanvasState state) =>
      DropdownButton<dynamic>(
        items: AppConstants.availableFonts
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

  void _onEmailTap(BuildContext context, String email) {
    Clipboard.setData(ClipboardData(text: email)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email address copied to clipboard")),
      );
    });
  }
}
