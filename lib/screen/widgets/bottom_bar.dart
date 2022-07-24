import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class CustomBottomBar extends StatelessWidget {
  final void Function() onNextDay;
  final void Function() onPreviousDay;

  const CustomBottomBar(
      {Key? key, required this.onNextDay, required this.onPreviousDay})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBottomNavigationBar.builder(
      activeIndex: 0,
      gapLocation: GapLocation.center,
      notchMargin: 4,
      shadow: ThemeProvider.themeOf(context).data == ThemeData.dark()
          ? const Shadow(color: Colors.white, blurRadius: 0.4)
          : const Shadow(color: Colors.black, blurRadius: 0.4),
      backgroundColor: ThemeProvider.themeOf(context).data == ThemeData.dark()
          ? Colors.black54
          : Colors.white,
      itemCount: 2,
      height: 65,
      tabBuilder: (index, isActive) {
        final icons = [
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
                    color:
                        ThemeProvider.themeOf(context).data == ThemeData.dark()
                            ? Colors.white
                            : Colors.black,
                  ),
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
                    color:
                        ThemeProvider.themeOf(context).data == ThemeData.dark()
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
              ],
            ),
          )
        ];
        return icons[index];
      },
      onTap: (value) {
        if (value == 1) {
          onNextDay();
        } else {
          onPreviousDay();
        }
      },
    );
  }
}
