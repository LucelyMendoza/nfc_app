import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('GPS en Flutter')),
        body: Center(child: LocationScreen()),
      ),
    );
  }
}

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String _locationText = 'Obteniendo ubicación...';
  Position? _currentPosition;

  Future<void> _getLocation() async {
    try {
      // Verificar permisos
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _locationText = 'Permisos denegados');
          return;
        }
      }

      // Obtener ubicación
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _locationText = '''
        Latitud: ${position.latitude.toStringAsFixed(4)}
        Longitud: ${position.longitude.toStringAsFixed(4)}
        ''';
      });
    } catch (e) {
      setState(() => _locationText = 'Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_locationText, style: TextStyle(fontSize: 18)),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _getLocation,
          child: Text('Actualizar ubicación'),
        ),
      ],
    );
  }
}