import 'package:flutter/material.dart';
import 'package:vizsga_projekt/pages/QuizPage.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    List<String> categories = [
      'Történelem',
      'Matematika',
      'Tudomány',
      'Irodalom'
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Üdvözöllek Kvízjátékunkban!'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Válasszon egy kategóriát!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(categories[index]),
                  leading: Radio<String>(
                    value: categories[index],
                    groupValue: selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: selectedCategory != null
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuizPage(category: selectedCategory!),
                      ),
                    );
                  }
                : null,
            child: const Text('Induljon a játék'),
          ),
        ],
      ),
    );
  }
}
