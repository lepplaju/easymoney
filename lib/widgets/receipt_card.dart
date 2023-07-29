import 'package:flutter/material.dart';

import '../objects/receipt.dart';

class ReceiptCard extends StatelessWidget {
  final Receipt receipt;
  const ReceiptCard({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${receipt.date.day}.${receipt.date.month}.${receipt.date.year}',
                      style: textTheme.headlineSmall,
                    ),
                    Text(
                      receipt.store,
                      style: textTheme.headlineMedium,
                    ),
                  ],
                ),
                Text(
                  '${receipt.amount}€',
                  style: textTheme.headlineSmall,
                )
              ],
            ),
            //Text(receipt.description)
          ],
        ),
      ),
    );
  }
}
