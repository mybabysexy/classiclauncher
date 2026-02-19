import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class AppInfo implements Equatable {
  final String packageName;
  final String title;
  final Uint8List icon;

  AppInfo({required this.packageName, required this.title, required this.icon});

  @override
  List<Object?> get props => [packageName, title];

  @override
  bool? get stringify => true;
}
