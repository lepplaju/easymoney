import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../application/provider_profiles.dart';
import '../../snacks/application/send_snack.dart';

/// Route for adding a new profile
class AddProfileRoute extends StatefulWidget {
  const AddProfileRoute({super.key, this.allowReturn = true});
  final bool allowReturn;

  @override
  State<AddProfileRoute> createState() => _AddProfileRouteState();
}

/// State for [AddProfileRoute]
class _AddProfileRouteState extends State<AddProfileRoute> {
  late final ProviderProfiles providerProfiles;
  late final AppLocalizations locals;
  final profileNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final ibanController = TextEditingController();
  final targetController = TextEditingController();

  var isInitialized = false;

  @override
  void didChangeDependencies() {
    if (!isInitialized) {
      providerProfiles = Provider.of<ProviderProfiles>(context);
      locals = AppLocalizations.of(context)!;
      isInitialized = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    profileNameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    ibanController.dispose();
    targetController.dispose();
    super.dispose();
  }

  /// Add a new profile using current values from the UI
  _addProfile({required String successSnack}) async {
    // TODO Don't allow empty values
    await providerProfiles.addProfile(
      profileName: profileNameController.text.trim(),
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      // TODO Check iban
      iban: ibanController.text.trim(),
      target: targetController.text.trim(),
    );

    if (context.mounted) {
      sendSnack(context: context, content: successSnack);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => widget.allowReturn,
      child: Scaffold(
        appBar: AppBar(
          title: Text(locals.addProfileRouteAppBarTitle),
          centerTitle: true,
          automaticallyImplyLeading: widget.allowReturn,
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Text(
                  locals.addProfileRouteDescription,
                  textAlign: TextAlign.center,
                ),
                TextField(
                  controller: profileNameController,
                  decoration: InputDecoration(
                    label: Text(locals.addProfileRouteProfileName),
                    hintText: locals.addProfileRouteProfileNameHint,
                    isDense: true,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                ),
                TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    label: Text(locals.addProfileRouteFirstName),
                    hintText: 'Ben, Jake, Rose, Sophie...',
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                ),
                TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    label: Text(locals.addProfileRouteLastName),
                    hintText: 'Anderson, Patel, Smith...',
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                ),
                TextField(
                  controller: targetController,
                  decoration: InputDecoration(
                    label: Text(locals.addProfileRouteReference),
                    hintText: 'Korttelikylä, Asuva, Harju...',
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                ),
                TextField(
                  controller: ibanController,
                  decoration: InputDecoration(
                    label: Text(locals.addProfileRouteIBAN),
                    hintText: 'FI83 4978 8259 0005 97...',
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                ),
                ElevatedButton(
                    onPressed: () {
                      _addProfile(
                        successSnack: locals.addProfileRouteSuccessSnack,
                      );
                    },
                    child: Text(locals.addProfileRouteSubmitButton))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
