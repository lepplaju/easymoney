import 'package:flutter/material.dart';

import '../../../utils/create_route.dart';
import 'receipt_route.dart';
import '../domain/receipt.dart';

/// Card to show receipt info in the receipt list
///
/// Requires [receipt] to be shown.
class ReceiptCard extends StatelessWidget {
  final Receipt receipt;
  const ReceiptCard({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(createRoute(ReceiptRoute(receipt: receipt)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.pink,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          receipt.dateOnly,
                          style: textTheme.headlineSmall,
                        ),
                        Text(
                          receipt.store,
                          style: textTheme.headlineMedium,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${receipt.euros}€',
                    style: textTheme.headlineSmall,
                  )
                ],
              ),
              //Text(receipt.description)
            ],
          ),
        ),
      ),
    );
  }
}
