import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/image_state.dart';
import 'ui/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ImageState(),
      child: const MaterialApp(
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}

