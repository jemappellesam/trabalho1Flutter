import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/poi_provider.dart';
import '../models/poi.dart';

class AddPOIDialog extends StatefulWidget {
  final double? currentLat;
  final double? currentLng;

  const AddPOIDialog({super.key, this.currentLat, this.currentLng});

  @override
  State<AddPOIDialog> createState() => _AddPOIDialogState();
}

class _AddPOIDialogState extends State<AddPOIDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();

  void _useCurrentLocation() {
    if (widget.currentLat != null && widget.currentLng != null) {
      _latController.text = widget.currentLat!.toStringAsFixed(6);
      _lngController.text = widget.currentLng!.toStringAsFixed(6);
    }
  }

  String? _validateCoordinate(String? value, String type) {
    if (value == null || value.isEmpty) return 'Insira a $type';
    final num? number = double.tryParse(value);
    if (number == null) return '$type inválida';
    
    if (type == 'Latitude' && (number < -90 || number > 90)) {
      return 'Latitude deve ser entre -90 e 90';
    }
    
    if (type == 'Longitude' && (number < -180 || number > 180)) {
      return 'Longitude deve ser entre -180 e 180';
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar POI'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                    value!.isEmpty ? 'Insira um nome' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _latController,
                      decoration: const InputDecoration(labelText: 'Latitude'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) => _validateCoordinate(value, 'Latitude'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _lngController,
                      decoration: const InputDecoration(labelText: 'Longitude'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) => _validateCoordinate(value, 'Longitude'),
                    ),
                  ),
                ],
              ),
              if (widget.currentLat != null && widget.currentLng != null)
                TextButton(
                  onPressed: _useCurrentLocation,
                  child: const Text('Usar localização atual'),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newPOI = PointOfInterest(
                id: DateTime.now().toString(),
                name: _nameController.text,
                description: _descriptionController.text,
                latitude: double.parse(_latController.text),
                longitude: double.parse(_lngController.text),
              );
              
              Provider.of<POIProvider>(context, listen: false).addPOI(newPOI);
              Navigator.pop(context);
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}