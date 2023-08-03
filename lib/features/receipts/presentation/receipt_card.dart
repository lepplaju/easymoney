import 'package:flutter/material.dart';

import 'receipt_route.dart';
import '../domain/receipt.dart';

/// Card to show receipt info in the receipt list
class ReceiptCard extends StatelessWidget {
  final Receipt receipt;
  const ReceiptCard({super.key, required this.receipt});

  /// Creates a ReceiptRoute route
  PageRouteBuilder _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ReceiptRoute(
        receipt: receipt,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(_createRoute());
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        receipt.dateOnly,
                        style: textTheme.headlineSmall,
                      ),
                      Text(
                        receipt.store,
                        style: textTheme.headlineMedium,
                      ),
                    ],
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
