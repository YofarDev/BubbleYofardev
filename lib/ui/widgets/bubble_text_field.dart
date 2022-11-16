// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../res/app_colors.dart';

class BubbleTextField extends StatelessWidget {
  final String font;
  final TextEditingController controller;
  final double? maxWidthBubble;
  final bool setMaxWidthBubble;
  final Function(double width) onMaxWidthBubbleChanged;
  final Function(bool? value) onSetMaxWidthBubbleChanged;

  const BubbleTextField({
    super.key,
    required this.font,
    required this.controller,
    this.maxWidthBubble,
    required this.setMaxWidthBubble,
    required this.onMaxWidthBubbleChanged,
    required this.onSetMaxWidthBubbleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _checkboxWidthBubble(context),
            _textField(),
          ],
        ),
      ),
    );
  }

//////////////////////////////// WIDGETS ////////////////////////////////

  Widget _textField() => Container(
        constraints:
            BoxConstraints(maxWidth: maxWidthBubble ?? double.infinity),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 2),
          color: AppColors.greyTransparent,
        ),
        child: TextField(
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 5,
          controller: controller,
          cursorColor: Colors.black,
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: font),
          decoration: const InputDecoration(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.all(16),
            hintText: "Type your bubble text here...",
          ),
        ),
      );

  Widget _checkboxWidthBubble(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Set max width", style: TextStyle(fontSize: 13)),
            Checkbox(
              onChanged: onSetMaxWidthBubbleChanged,
              value: setMaxWidthBubble,
              activeColor: AppColors.yellow,
            ),
            if (setMaxWidthBubble) _widthBubbleSlider(context),
            if (setMaxWidthBubble) Text("$maxWidthBubble"),
          ],
        ),
      );

  Widget _widthBubbleSlider(BuildContext context) => Slider(
        value: maxWidthBubble ?? 300,
        onChanged: onMaxWidthBubbleChanged,
        label: "$maxWidthBubble",
        min: 50,
        activeColor: AppColors.yellow,
        inactiveColor: AppColors.yellowTransparent,
        max: MediaQuery.of(context).size.width - 128,
      );

//////////////////////////////// LISTENERS ////////////////////////////////

//////////////////////////////// FUNCTIONS ////////////////////////////////
}
