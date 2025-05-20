import 'package:flutter/material.dart';
import '../../widgets/custom_appbar.dart';

class ExplorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Explore'),
      body: Center(child: Text('Explore Page')),
    );
  }
}
