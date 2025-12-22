import 'package:flutter/material.dart';
import 'screens/face_rd_demo_page.dart';

void main() {
  runApp(const FaceRDExampleApp());
}

class FaceRDExampleApp extends StatelessWidget {
  const FaceRDExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aadhaar FaceRD Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const FaceRdDemoPage(),
    );
  }
}
