import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/canvas_cubit.dart';
import '../../res/app_colors.dart';
import 'tools_icon_button.dart';

class LoadImageButton extends StatelessWidget {
  final bool iconOnly;

  const LoadImageButton({
    super.key,
    this.iconOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!iconOnly) {
      return Center(
        child: InkWell(
          onTap: () => _onLoadImagePressed(context),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 204, 0),
              border: Border.all(),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              children: <Widget>[
                Icon(Icons.image, color: Colors.white),
                Text("Load an image", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      );
    } else {
      return ToolsIconButton(
        icon: Icons.image,
        tag: 'Load image',
        onPressed: () => _onLoadImagePressed(context),
        color: AppColors.yellow,
      );
    }
  }

  void _onLoadImagePressed(BuildContext context) async {
    final FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      context.read<CanvasCubit>().loadImage(result.files.single.bytes!);
    }
  }
}
