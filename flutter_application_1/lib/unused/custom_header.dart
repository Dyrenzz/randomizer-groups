import 'package:flutter/material.dart';
import 'size_config.dart';
import 'colors.dart';


class CustomHeader extends StatefulWidget {
  const CustomHeader({super.key});
  
  @override
  State<CustomHeader> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
  bool isDark = false;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      SizeConfig.init(context);
      _initialized = true;
    }
  }
  
  void toggleTheme() {
    setState(() {
      isDark = !isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Header(isDark: isDark, onToggleTheme: toggleTheme)
    );
  }
}

// App Bar
class Header extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const Header({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
    });

  @override
  Widget build(BuildContext context) {
    double left = SizeConfig.w(11);
    double top = SizeConfig.h(7);
    double right = SizeConfig.w(11);
    double bottom = SizeConfig.h(6);
    double fontSize(percentage) => SizeConfig.fs(1.0) * percentage;

    
    return Container(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      decoration: BoxDecoration(
        color: isDark ? darkMode[500]: lightMode[300],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(SizeConfig.w(11)),
          bottomRight: Radius.circular(SizeConfig.w(11)),
        )
        ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Teks Grid
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Randomizer", 
                  style: TextStyle(
                    fontSize: fontSize(2.4),
                    fontWeight: FontWeight.w500,
                    )),
                Text(
                  "Hello there,",
                  style: TextStyle(
                    fontSize: fontSize(5.5),
                    fontWeight: FontWeight.w600,
                  )),
              ],
            ),
          ),

          // Button Grid
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
            // Theme Button
            ElevatedButton(
              onPressed: onToggleTheme,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(3), vertical: SizeConfig.h(1.2)),
                backgroundColor:  isDark ? darkMode.shade300 : lightMode.shade200,
              ),
              child: Row(
                children: [
                  Icon(
                      isDark ?  Icons.nights_stay : Icons.sunny,
                      size: fontSize(5),
                      color: isDark ? AcccentColors.moonColor : AcccentColors.sunColor,
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(1))),
                    Text(isDark ? "Dark" : "Light", style: TextStyle(
                      fontSize: fontSize(2.1),
                      fontWeight: FontWeight.w400,
                      color: isDark ?darkMode[1300]: lightMode[1100]
                    ))
                ],
              )
            ),

            Padding(padding: EdgeInsets.symmetric(vertical: SizeConfig.h(1.2)))
          ]),
        ],
      ),
    );
  }
}