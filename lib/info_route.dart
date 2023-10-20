import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

import './widgets/data_widget.dart';
import './utils/open_url.dart';

/// Route for showing info about the app
///
/// {@nodoc}
class InfoRoute extends StatelessWidget {
  const InfoRoute({super.key});
  static const List<Map<String, String>> _libraries = [
    {
      'name': 'Flutter',
      'url': 'https://flutter.dev/',
    },
    {
      'name': 'flutter_localizations',
      'url': 'https://pub.dev/packages/flutter_localization',
    },
    {
      'name': 'intl',
      'url': 'https://pub.dev/packages/intl',
    },
    {
      'name': 'sqflite',
      'url': 'https://pub.dev/packages/sqflite',
    },
    {
      'name': 'image_picker',
      'url': 'https://pub.dev/packages/image_picker',
    },
    {
      'name': 'path_provider',
      'url': 'https://pub.dev/packages/path_provider',
    },
    {
      'name': 'provider',
      'url': 'https://pub.dev/packages/provider',
    },
    {
      'name': 'pdf_render',
      'url': 'https://pub.dev/packages/pdf_render',
    },
    {
      'name': 'file_picker',
      'url': 'https://pub.dev/packages/file_picker',
    },
    {
      'name': 'path',
      'url': 'https://pub.dev/packages/path',
    },
    {
      'name': 'share_plus',
      'url': 'https://pub.dev/packages/share_plus',
    },
    {
      'name': 'after_layout',
      'url': 'https://pub.dev/packages/after_layout',
    },
    {
      'name': 'pdf',
      'url': 'https://pub.dev/packages/pdf',
    },
    {
      'name': 'package_info_plus',
      'url': 'https://pub.dev/packages/package_info_plus',
    },
    {
      'name': 'url_launcher',
      'url': 'https://pub.dev/packages/url_launcher',
    },
  ];

  List<Widget> _libraryBuilder(BuildContext context) {
    final list = <Widget>[];
    for (var package in _libraries) {
      list.add(TextButton(
          onPressed: () {
            openUrl(package['url']!);
          },
          child: Text(package['name']!)));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context);
    final packageInfo = PackageInfo.fromPlatform();
    return Scaffold(
      appBar: AppBar(
        title: Text(locals!.infoRouteTitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            locals.infoRouteContribute,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 20,
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                // Opening chrome on android emulator freezes
                                // the emulator so don't use this button there
                                openUrl('https://github.com/Ben-PP/easymoney');
                              },
                              child: const SizedBox(
                                width: double.infinity,
                                child: Text(
                                  'Github',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      DataWidget(
                          title: locals.infoRouteDeveloper,
                          content: 'Karel Parkkola'),
                      FutureBuilder(
                          future: packageInfo,
                          builder: (BuildContext context,
                              AsyncSnapshot<PackageInfo> snapshot) {
                            return DataWidget(
                              title: locals.infoRouteVersion,
                              content: snapshot.hasData
                                  ? snapshot.data!.version
                                  : '',
                            );
                          }),
                    ],
                  ),
                ),
                Text(
                  locals.infoRouteLibraries,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ..._libraryBuilder(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
