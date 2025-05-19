import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../providers/poi_provider.dart';

class POIListScreen extends StatelessWidget {
  const POIListScreen({super.key});

  double _calculateDistance(
      double startLat, double startLng, double endLat, double endLng) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  @override
  Widget build(BuildContext context) {
    final pois = Provider.of<POIProvider>(context).pois;
    final currentPosition = Provider.of<Position?>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('POIs Cadastrados')),
      body: ListView.builder(
        itemCount: pois.length,
        itemBuilder: (context, index) {
          final poi = pois[index];
          double distance = currentPosition != null
              ? _calculateDistance(
                  currentPosition.latitude,
                  currentPosition.longitude,
                  poi.latitude,
                  poi.longitude,
                )
              : 0;

          return ListTile(
            title: Text(poi.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(poi.description),
                Text('Coordenadas: ${poi.latitude.toStringAsFixed(6)}, '
                    '${poi.longitude.toStringAsFixed(6)}'),
                if (currentPosition != null)
                  Text('Distância: ${distance >= 1000 ? '${(distance / 1000).toStringAsFixed(2)} km' : '${distance.toStringAsFixed(2)} metros'}'),
              ],
            ),
          );
        },
      ),
    );
  }
}