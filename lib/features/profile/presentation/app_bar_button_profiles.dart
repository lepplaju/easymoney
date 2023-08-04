import 'package:flutter/material.dart';

class AppBarButtonProfiles extends StatelessWidget {
  const AppBarButtonProfiles({
    super.key,
    required this.firstName,
    required this.lastName,
  });
  final String firstName;
  final String lastName;

  @override
  Widget build(BuildContext context) {
    final nameLetters = firstName.substring(0, 1).toUpperCase() +
        lastName.substring(0, 1).toUpperCase();
    return DropdownButton(
      onChanged: (_) {},
      onTap: () {
        // TODO Change profile
      },
      items: [
        DropdownMenuItem(
          child: Row(
            children: [
              Text(nameLetters),
              const Icon(Icons.person),
            ],
          ),
        ),
      ],
    );
  }
}
