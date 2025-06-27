import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/canvas_cubit.dart';

class HideUiButton extends StatelessWidget {
  const HideUiButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CanvasCubit, CanvasState>(
      builder: (BuildContext context, CanvasState state) {
        return IconButton(
          icon: Icon(state.hideUi ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            context.read<CanvasCubit>().toggleHideUi();
          },
        );
      },
    );
  }
}
