import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theme_provider/theme_provider.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final BuildContext context;

  final void Function() nextDay;
  final void Function() previousDay;
  const CustomBottomNavigationBar({
    Key? key,
    required this.context,
    required this.nextDay,
    required this.previousDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> icons = [
      Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Column(
          children: [
            Icon(
              Icons.navigate_before,
              color: ThemeProvider.themeOf(context).data == ThemeData.dark()
                  ? Colors.white
                  : Colors.black,
            ),
            Text(
              'Précédent',
              style: TextStyle(
                  color: ThemeProvider.themeOf(context).data == ThemeData.dark()
                      ? Colors.white
                      : Colors.black),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          children: [
            Icon(
              Icons.navigate_next,
              color: ThemeProvider.themeOf(context).data == ThemeData.dark()
                  ? Colors.white
                  : Colors.black,
            ),
            Text(
              'Suivant',
              style: TextStyle(
                color: ThemeProvider.themeOf(context).data == ThemeData.dark()
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ],
        ),
      )
    ];
    return AnimatedBottomNavigationBar.builder(
      activeIndex: 0,
      gapLocation: GapLocation.center,
      notchMargin: 4,
      elevation:
          ThemeProvider.themeOf(context).data == ThemeData.dark() ? 0 : 8,
      backgroundColor: ThemeProvider.themeOf(context).data == ThemeData.dark()
          ? Colors.black54
          : Colors.white,
      itemCount: 2,
      height: 65,
      tabBuilder: (context, index) {
        return icons[context];
      },
      onTap: (value) {
        if (value == 1) {
          HapticFeedback.vibrate();
          nextDay();
        } else {
          HapticFeedback.vibrate();
          previousDay();
        }
      },
    );
  }
}
