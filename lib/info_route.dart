import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import './widgets/data_widget.dart';

class InfoRoute extends StatelessWidget {
  const InfoRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final packageInfo = PackageInfo.fromPlatform();
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
