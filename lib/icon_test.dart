import 'package:flutter/material.dart';
import 'package:flutter_dynamic_launcher_icon/flutter_dynamic_launcher_icon.dart';


class IconTest extends StatefulWidget {
  const IconTest({super.key});

  @override
  State<IconTest> createState() => _IconTestState();
}

class _IconTestState extends State<IconTest> {
  String? _currentIcon;

  @override
  void initState() {
    super.initState();
    _loadCurrentIcon();
  }

  Future<void> _loadCurrentIcon() async {
    final icon = await FlutterDynamicLauncherIcon.alternateIconName;
    setState(() => _currentIcon = icon);
  }

  Future<void> _changeIcon(String? iconName) async {
    await FlutterDynamicLauncherIcon.changeIcon(iconName);
    await _loadCurrentIcon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dynamic Icon Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Current Icon: ${_currentIcon ?? "Default"}'),
            ElevatedButton(
              onPressed: () => _changeIcon('udyog'),
              child: Text('Switch to udyog Icon'),
            ),
            ElevatedButton(
              onPressed: () => _changeIcon('maha'),
              child: Text('Switch to maha Icon'),
            ),
            ElevatedButton(
              onPressed: () => _changeIcon(null),
              child: Text('Reset to Default'),
            ),
          ],
        ),
      ),
    );
  }
}
