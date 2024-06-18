import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isBoy = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isBoy = (prefs.getBool('isBoy') ?? true);
    });
  }

  _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isBoy', isBoy);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Für Jungen'),
              value: isBoy,
              onChanged: (value) {
                setState(() {
                  isBoy = value;
                });
                _savePreferences();
              },
            ),
            SwitchListTile(
              title: const Text('Für Mädchen'),
              value: !isBoy,
              onChanged: (value) {
                setState(() {
                  isBoy = !value;
                });
                _savePreferences();
              },
            ),
          ],
        ),
      ),
    );
  }
}
