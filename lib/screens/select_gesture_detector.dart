import 'package:flutter/widgets.dart';

class SelectableGestureDetector extends StatelessWidget {
  final Widget child;

  const SelectableGestureDetector({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(child: child);
  }
}
