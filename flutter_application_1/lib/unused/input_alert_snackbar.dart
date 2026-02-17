import 'package:flutter/material.dart';

void tes_1() {
  runApp(
    MaterialApp(title: 'Input Text, Alert, and Snackbar', home:  Home()),
  );
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String teks = "";

  TextEditingController controllerInput = TextEditingController();
  TextEditingController controllerAlert = TextEditingController();
  TextEditingController controllerSnackBar = TextEditingController();



  void _snackbar(String str) {
    if(str.isEmpty) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(str, style: TextStyle(fontSize: 20.0),),
      duration: Duration(seconds: 3),
      ));
  }


  void _alertdialog(String str) {
    if (str.isEmpty) return;

    AlertDialog alertDialog = AlertDialog(
      content: Text(str, style: TextStyle(fontSize: 20.0)),
      title: const Text('Just alert'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Input Text, Alert, Snackbar"),
        backgroundColor: Colors.amber[200],
      ),
      body: Column(
        children: [
          Column(
            children: [
              TextField(
                controller: controllerInput,
                decoration: InputDecoration(hintText: "Input Text..."),
                onSubmitted: (String str) {
                  setState(() {
                    teks = '$str\n$teks';
                    controllerInput.text = '';
                  });
                },
              ),
              Text(teks, style: TextStyle(fontSize: 20.0)),
            ],
          ),
          Column(
            children: [
              TextField(
                controller: controllerAlert,
                decoration: InputDecoration(hintText: "Input Alert..."),
                onSubmitted: (String str) {
                  _alertdialog(str);
                  controllerAlert.text = '';
                },
              ),
            ],
          ),
          Column(
            children: [
              TextField(
                controller: controllerSnackBar,
                decoration: InputDecoration(hintText: "Input SnackBar..."),
                onSubmitted: (String str) {
                  _snackbar(str);
                  controllerSnackBar.text = '';
                },
              ),
            ],
          ),
        ],
      )
    );
  }
}
