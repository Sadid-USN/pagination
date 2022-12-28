import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JsonDataScreen extends StatefulWidget {
  const JsonDataScreen({Key? key}) : super(key: key);
  @override
  State<JsonDataScreen> createState() => _JsonDataScreenState();
}

class _JsonDataScreenState extends State<JsonDataScreen> {
  Future<String> _rootBundleDta() async {
    return await rootBundle.loadString('assets/json/family.json');
  }

  // Future loadData() async {
  //   String jsonString = await _rootBundleDta();
  //   final jsonResponse = jsonDecode(jsonString);
  //   Famaly famaly = Famaly.fromJson(jsonResponse);

  //   print("Father name ${famaly.father} age ${famaly.fatherAge}");
  //   print("Mother name ${famaly.mother} age ${famaly.motherAge}");
  //   print(
  //       "Son name ${famaly.children![0].son} age ${famaly.children![0].sonAge}");
  //   print(
  //       "daughter name ${famaly.children![0].daughter} age ${famaly.children![0].daughterAge}");
  // }

  @override
  void initState() {
    //  loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Json Data Screen'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: DefaultAssetBundle.of(context)
            .loadString('assets/json/family.json'),
        builder: (context, snapshot) {
          var familyDta = json.decode(snapshot.data.toString());
          return ListView.builder(
              itemCount: familyDta == null ? 0 : familyDta.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ListTile(
                      title: const Text(
                        'Age',
                      ),
                      leading: Text(
                        familyDta[index]['father'],
                      ),
                      trailing: Text(
                        familyDta[index]['fatherAge'].toString(),
                      ),
                    ),
                    Text(
                      familyDta[index]['mother'],
                    ),
                    Text(
                      familyDta[index]['children'][index]['son'],
                    ),
                    Text(
                      familyDta[index]['children'][index]['daughter'],
                    ),
                  ],
                );
              });
        },
      ),
    );
  }
}
