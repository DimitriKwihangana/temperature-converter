import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(TemperatureConverterApp());
}

class TemperatureConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyText1: TextStyle(fontSize: 18.0, color: Colors.teal),
          bodyText2: TextStyle(fontSize: 18.0, color: Colors.teal),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal),
          ),
          labelStyle: TextStyle(color: Colors.teal),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.teal),
            padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            ),
            textStyle: MaterialStateProperty.all(
              TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => TemperatureConverterScreen(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => TemperatureConverterScreen(),
        ));
      },
      child: Scaffold(
        body: Center(
          child: Icon(
            Icons.thermostat,
            size: 100,
            color: Colors.teal,
          ),
        ),
      ),
    );
  }
}

class TemperatureConverterScreen extends StatefulWidget {
  @override
  _TemperatureConverterScreenState createState() =>
      _TemperatureConverterScreenState();
}

class _TemperatureConverterScreenState
    extends State<TemperatureConverterScreen> {
  final _controller = TextEditingController();
  String _selectedConversion = 'Fahrenheit to Celsius';
  String _result = '';
  List<String> _history = [];

  void _convertTemperature() {
    final input = double.tryParse(_controller.text);
    if (input == null) {
      return;
    }
    double converted;
    String conversion;
    String inputUnit;
    String outputUnit;
    if (_selectedConversion == 'Fahrenheit to Celsius') {
      converted = (input - 32) * 5 / 9;
      conversion = 'Fahrenheit to Celsius';
      inputUnit = '°F';
      outputUnit = '°C';
    } else {
      converted = input * 9 / 5 + 32;
      conversion = 'Celsius to Fahrenheit';
      inputUnit = '°C';
      outputUnit = '°F';
    }
    setState(() {
      _result =
          '$_selectedConversion: $input$inputUnit => ${converted.toStringAsFixed(1)}$outputUnit';
      _history.add(
          '$input$inputUnit is equal to ${converted.toStringAsFixed(1)}$outputUnit');
    });
  }

  void _clearResult() {
    setState(() {
      _result = '';
    });
  }

  void _clearHistory() {
    setState(() {
      _history.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.thermostat),
            SizedBox(width: 10),
            Text(
              'Temperature Converter',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Enter temperature value',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _clearResult(),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedConversion,
                  items: <String>[
                    'Fahrenheit to Celsius',
                    'Celsius to Fahrenheit'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Select conversion type',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedConversion = value!;
                      _clearResult();
                    });
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _convertTemperature,
                  child: Text('Convert', style: TextStyle(color: Colors.black)),
                ),
                SizedBox(height: 16),
                Text(
                  _result.isEmpty ? 'Result will be shown here' : _result,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _clearHistory,
                  child: Text('Clear History', style: TextStyle(color: Colors.black)),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    textStyle: MaterialStateProperty.all(
                      TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 300, // Adjusted height
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Background color
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _history.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_history[index]),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
