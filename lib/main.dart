import 'package:flutter/material.dart';
import 'app/family_tree_app.dart';
import 'di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const FamilyTreeApp());
}
