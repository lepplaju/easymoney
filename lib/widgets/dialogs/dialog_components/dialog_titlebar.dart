import 'package:flutter/material.dart';

/// Title bar for building custom dialogs
///
/// Takes [title] and it is displayed in the center of the title bar.
/// If no [title] is given, there will be only x button on the right side
/// of the bar. Visibility of the x button can be chosen with [showX].
/// [backgroundColor] will be used to override default color.
class DialogTitleBar extends StatelessWidget {
  const DialogTitleBar({
    Key? key,
    this.title,
    this.showX = true,
    this.backgroundColor,
  }) : super(key: key);
  final String? title;
  final bool showX;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: backgroundColor ?? Theme.of(context).colorScheme.primary,
      ),
      width: double.infinity,
      height: 40,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          if (title != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.15),
                  child: Text(
                    title!,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              ),
            ),
          if (showX)
            Positioned(
              right: 5,
              child: IconButton(
                padding: const EdgeInsets.all(0),
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
        ],
      ),
    );
  }
}
