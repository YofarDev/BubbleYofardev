import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/canvas_cubit.dart';
import 'app_canvas.dart';
import 'widgets/bottom_overlay.dart';
import 'widgets/hide_ui_button.dart';
import 'widgets/tools_buttons.dart';
import 'widgets/transparent_grid.dart';
import 'widgets/welcome_panel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeView();
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CanvasCubit, CanvasState>(
        builder: (BuildContext context, CanvasState state) {
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              const TransparentGrid(),
              const AppCanvas(),
              if (state.isEmpty) const WelcomePanel(),
              if (!state.isEditMode && !state.hideUi)
                const Positioned(
                    left: 0, right: 0, bottom: 16, child: BottomOverlay()),
              if (!state.hideUi)
                const Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: ToolsButtons(),
                  ),
                ),
              const Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                      padding: EdgeInsets.all(8), child: HideUiButton()))
            ],
          );
        },
      ),
    );
  }
}
