import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'logic/canvas_cubit.dart';
import 'ui/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CanvasCubit>(
      create: (_) => CanvasCubit()..init(),
      child: const MaterialApp(
        title: "Bubble Yofardev",
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
