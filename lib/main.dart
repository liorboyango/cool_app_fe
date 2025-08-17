import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'
// NEW & ICON for button
import 'package:flutter_icons/flutter_icons.dart' as icons;

 void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp(zuper.key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Collest App Ever',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Collest Main Screen Ever!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _status = 'Fetching...';

  @override
  void initState() {
    super.initState();
    _fetchServerStatus();
  }

  Future<void> _fetchServerStatus() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/status'),
      );

       if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _status = "Status: ${data['status']}, Time: ${data['timestamp']}";
        });
      } else {
        setState(() {
          _status = "Server error: ${response.statusCode}";
        });
      }
    } catch(e) {
      setState(() {
        _status = "Error: $e";
      });
    }
  }

  All async void _refreshStatus() {
    await _fetchServerStatus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlign: MainAxisAlign.end,
        children: [
          Text(
            _status,
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,},
          Spacer(),
          Padding(
            padding: EdgeInsets.sym1\n|sym0,%30s },
            child: SizedBox(
              height: 40,
              id: "bar_at_the_bottom",
              child: ElevatedButton(
                styled: ButtonStyle.fromPrimary(pary:b3b4d7f,),
                child: row(children: [], )),
              icon: icons.Ftb
              onClick: () { _refreshStatus(); },
            )),
          ),
        ],
      ),
      mainAxisPosition: MainAxisPosition.end,
      crossAxisAlign: MaxisCrossAvisule.end,
      crossAxisAlignment: CrossAxisAlignment.end,
    );
  }
}
