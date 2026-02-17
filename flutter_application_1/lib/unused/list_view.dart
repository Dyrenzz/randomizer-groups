import 'package:flutter/material.dart';

void tes_2() {
  runApp(MaterialApp(title: 'Listview and Widget', home: Home()));
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(
          'ListView and Widget',
          style: TextStyle(color: Colors.deepPurple[100]),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          ListTutorial(iconData: Icons.radio_button_unchecked, title: 'Kelas 2 SADSADASDSADSADASDASD', subTitle: 'Acak bangku'),
          ListTutorial(iconData: Icons.radio_button_unchecked, title: 'Kelas Sebelah', subTitle: 'Acak bangku'),
          ListTutorial(iconData: Icons.radio_button_unchecked, title: 'Projek P5', subTitle: 'Acak siswa'),
          ListTutorial(iconData: Icons.radio_button_unchecked, title: 'Pilih Meja', subTitle: 'Wise Option'),
          ListTutorial(iconData: Icons.radio_button_unchecked, title: 'Pilih Makan', subTitle: 'Makan Enak'),
          ListTutorial(iconData: Icons.radio_button_unchecked, title: 'Good Choice', subTitle: 'Minat banget'),
          ListTutorial(iconData: Icons.radio_button_unchecked, title: 'Studi Kasus', subTitle: 'Acak anggota'),
          ListTutorial(iconData: Icons.radio_button_unchecked, title: 'Panitia SUO', subTitle: 'Acak Kelompok'),
          ListTutorial(iconData: Icons.radio_button_unchecked, title: 'Minum Apa?', subTitle: 'Minum SINGA'),
        ],
      ),
    );
  }
}

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
              Text(title, style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1),
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
