import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

void main() {
  runApp(EcolesHarakaApp());
}

class EcolesHarakaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مدارس المغرب',
      home: SchoolSearchPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SchoolSearchPage extends StatefulWidget {
  @override
  _SchoolSearchPageState createState() => _SchoolSearchPageState();
}

class _SchoolSearchPageState extends State<SchoolSearchPage> {
  List<List<dynamic>> _data = [];
  List<List<dynamic>> _filteredData = [];
  bool _loading = true;
  String query = "";

  @override
  void initState() {
    super.initState();
    loadCSV();
  }

  Future<void> loadCSV() async {
    final rawData = await rootBundle.loadString('assets/ecoles_haraka_2023.csv');
    List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);
    setState(() {
      _data = listData;
      _filteredData = listData;
      _loading = false;
    });
  }

  void updateSearch(String text) {
    setState(() {
      query = text;
      _filteredData = _data.where((row) {
        return row.join(' ').contains(text);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text('تحميل...')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('البحث في المدارس')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: updateSearch,
              decoration: InputDecoration(
                hintText: 'ابحث عن مدرسة أو مديرية أو أكاديمية...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredData.length - 1,
              itemBuilder: (context, index) {
                final row = _filteredData[index + 1];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text('${row[5]} - ${row[3]}'),
                    subtitle: Text('${row[0]} | ${row[1]} | ${row[2]} | ${row[4]}'),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}