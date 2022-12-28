import 'package:flutter/material.dart';
import 'package:pagination/json_data_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(
        title: 'Pagination',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController _scrollController = ScrollController();
  List<String> items = [];
  bool loading = false, allLoaded = false;

  fatchData() async {
    if (allLoaded) {
      return;
    }
    setState(() {
      loading = true;
    });
    await Future.delayed(const Duration(milliseconds: 1000));

    List<String> newData = items.length >= 60
        ? []
        : List.generate(20, (index) => "Лист ${index + items.length + 1}");
    if (newData.isNotEmpty) {
      items.addAll(newData);
    }

    setState(() {
      loading = false;
      allLoaded = newData.isEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    fatchData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !loading) {
        fatchData();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: LayoutBuilder(builder: (context, constraint) {
        if (items.isNotEmpty) {
          return Stack(children: [
            ListView.separated(
                controller: _scrollController,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(items[index]),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 1,
                  );
                },
                itemCount: items.length),
            if (loading) ...[
              Positioned(
                left: 0,
                right: 0,
                child: SizedBox(
                  width: constraint.maxWidth,
                  height: 80,
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
            ]
          ]);
        } else {
          return Container(
              child: const Center(
            child: CircularProgressIndicator(),
          ));
        }
      }),
    );
  }
}
