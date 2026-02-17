import 'package:flutter/material.dart';
import 'package:flutter_application_1/unused/custom_bot_navbar.dart';
// import 'package:flutter_application_1/home/home.dart';
import 'package:flutter_application_1/unused/input_alert_snackbar.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyPage(),
      routes: <String, WidgetBuilder> {
        '/Home' : (BuildContext context) => Home(),
        '/Navbar' : (BuildContext context) => CustomTabBar(),
      }
    );
  }
}

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contoh Bottom Bar")),
      
      // Bagian utama yang bisa discroll
      body: Container(
        // BACKGROND
        // padding: EdgeInsets.only(bottom: 8.0),
        color: Color(0xFFDCDFE4),

        child: Container(
          // BODY DECORATION
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.only(bottom: 8.0),
          decoration: BoxDecoration(
            color: Color(0xFFF7F8F9),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(56.0),
              bottomRight: Radius.circular(56.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(120),
                blurRadius: 10.0,
              ),
            ],
          ),

          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            // BODY CONTENT
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(64.0), bottomRight: Radius.circular(64.0)),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                // clipBehavior: Clip.antiAlias,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTutorial(iconData: Icons.radio_button_unchecked_rounded, title: 'Item ${index + 1}', subTitle: 'Sub ${index + 1}');
                },
              ),
            ),
          ),
        ),
      ),

      // Bottom bar tetap di bawah
      bottomNavigationBar: BottomAppBar(
        height: 115.0,
        color: Color(0xFFDCDFE4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 90.0,
              width: 90.0,
              child: TextButton(
                onPressed: () => Navigator.pushNamed(context, '/Navbar'),
                child: Column(
                  children: [
                    Icon(Icons.people, size: 40.0),
                    Text("List", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500))
                  ],
                )), 
            ),
            SizedBox(
              height: 90.0,
              width: 90.0,
              child: TextButton(
                onPressed: (){}, 
                child: Column(
                  children: [
                    Icon(Icons.add, size: 40.0),
                    Text("Create", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500))
                  ],
                )), 
            ),
            SizedBox(
              height: 90.0,
              width: 90.0,
              child: TextButton(
                onPressed: (){}, 
                child: Column(
                  children: [
                    Icon(Icons.info_outline, size: 40.0),
                    Text("Info", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500))
                  ],
                )), 
            ),
          ],
        ),
      ),
    );
  }
}



// CustomWidget
class ListTutorial extends StatelessWidget {
  final IconData iconData;
  final String title;
  final String subTitle;
  final double iconSize;
  final double textSize;

  const ListTutorial({
    super.key,
    required this.iconData,
    required this.title,
    required this.subTitle,
    this.iconSize = 24.0,
    this.textSize = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey[200], // Container Background color,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: [
          Icon(iconData, size: iconSize),
          const SizedBox(width: 12.0), // Spasi antar icon dan teks
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis, maxLines: 1),
              Text(subTitle, style: const TextStyle(fontSize: 12.0)),
            ],
           ),
          ),
          const SizedBox(width: 20.0), // Spasi antar icon dan teks
          const Icon(Icons.chevron_right, size: 28.0),
        ],
      ),
    );
  }
}
