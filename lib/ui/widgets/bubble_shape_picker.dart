import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/canvas_cubit.dart';
import '../../models/bubble.dart';

class BubbleShapePicker extends StatelessWidget {
  final BubbleType selected;

  const BubbleShapePicker({
    super.key,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ...BubbleType.values.map((BubbleType e) => _buildItem(context, e)),
      ],
    );
  }

  Widget _buildItem(BuildContext context, BubbleType e) => InkWell(
        onTap: () => context.read<CanvasCubit>().changeBubbleType(e),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected == e ? Colors.black : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(20),
            color: selected == e
                ? const Color.fromARGB(255, 255, 204, 0)
                : Colors.transparent,
          ),
          child: Image.asset('assets/${e.name}.webp',
              width: 60, height: 60, fit: BoxFit.contain),
        ),
      );
}
