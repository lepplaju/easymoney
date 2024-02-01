import 'package:flutter/material.dart';

List<String> locations = [
  'Ainola',
  'Ainolankaari',
  'Auvilankuja',
  'Etelä-Kekkola',
  'Heikinsilta',
  'Hospa',
  'Humppa',
  'Kankaantorni',
  'Kangas',
  'Kotiraide',
  'Laajavuori',
  'Letkutie',
  'Myllyjärvi',
  'Palstatie',
  'Rantapolku',
  'Ratapiha',
  'Ristonmaa',
  'Seminaarinmäki',
  'Sillanpää',
  'Taitoniekantie',
  'Tango',
  'Veturi',
  'korttelikylä',
  'Harju',
  'Muu',
];

class LocationsDropdown extends StatefulWidget {
  const LocationsDropdown({super.key});

  @override
  State<LocationsDropdown> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<LocationsDropdown> {
  String dropdownValue = locations.last;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: DropdownButton<String>(
      value: dropdownValue,
      //icon: const Icon(Icons.arrow_downward),
      //elevation: 16,
      //style: const TextStyle(color: Colors.deepPurple),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: locations.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    ));
  }
}
