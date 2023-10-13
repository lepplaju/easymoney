import 'package:flutter/material.dart';

import './widgets/data_widget.dart';

/// Route for showing info about the app
///
/// {@nodoc}
class InfoRoute extends StatelessWidget {
  const InfoRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // FIXME Localization
        title: const Text('About EasyMoney'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(10),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              // FIXME Localization
              DataWidget(title: 'Developer', content: 'Karel Parkkola'),
              DataWidget(
                  title: 'Github',
                  content: 'https://github.com/Ben-PP/easymoney'),
              DataWidget(title: 'Version', content: 'Work In Progress'),
            ],
          ),
        ),
      ),
    );
  }
}
