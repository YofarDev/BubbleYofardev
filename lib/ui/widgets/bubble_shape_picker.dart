import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/canvas_cubit.dart';
import '../../models/bubble.dart';

class BubbleShapePicker extends StatefulWidget {
  final BubbleType selected;
  const BubbleShapePicker({
    super.key,
    required this.selected,
  });

  @override
  State<BubbleShapePicker> createState() => _BubbleShapePickerState();
}

class _BubbleShapePickerState extends State<BubbleShapePicker> {
  bool _isExpanded = false;
  static const double _buttonSize = 76.0;

  void _togglePicker() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _onShapeSelected(BubbleType shape) {
    context.read<CanvasCubit>().changeBubbleType(shape);
    setState(() {
      _isExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<BubbleType> otherOptions = BubbleType.values
        .where((BubbleType e) => e != widget.selected)
        .toList();

    final double expandedHeight = _isExpanded
        ? ((_buttonSize + 8.0) * (otherOptions.length + 1))
        : _buttonSize;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: <Widget>[
        if (_isExpanded)
          Positioned.fill(
            child: GestureDetector(
              onTap: _togglePicker,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        SizedBox(
          width: _buttonSize,
          height: expandedHeight,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              _buildExpandedOptions(),
              Positioned(
                bottom: 0,
                child: _buildSelectedItem(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedItem() {
    return _buildItem(
      shape: widget.selected,
      isSelected: true,
      onTap: _togglePicker,
    );
  }

  Widget _buildExpandedOptions() {
    final List<BubbleType> otherOptions = BubbleType.values
        .where((BubbleType e) => e != widget.selected)
        .toList();

    if (!_isExpanded) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: _buttonSize + 8.0,
      child: Column(
        children: otherOptions
            .map(
              (BubbleType shape) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _buildItem(
                  shape: shape,
                  isSelected: false,
                  onTap: () => _onShapeSelected(shape),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildItem({
    required BubbleType shape,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: "Pick Bubble type",
      child: InkWell(
        onTap: () {
          context.read<CanvasCubit>().confirmBubble();
          onTap();
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: _buttonSize,
          height: _buttonSize,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: <BoxShadow>[
              if (!isSelected)
                BoxShadow(
                  color: Colors.black.withAlpha(15),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                )
            ],
          ),
          child: Image.asset(
            'assets/${shape.name}.webp',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
