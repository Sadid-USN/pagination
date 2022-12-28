import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  int _page = 0;

  final int _limit = 20;

  bool _isFirstLoadRunning = false;
  bool _hasNextPage = true;

  bool _isLoadMoreRunning = false;

  List _posts = [];

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });

      _page += 1; // Increase _page by 1

      try {
        final res =
            await http.get(Uri.parse("$_baseUrl?_page=$_page&_limit=$_limit"));

        final List fetchedPosts = json.decode(res.body);
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            _posts.addAll(fetchedPosts);
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      final res =
          await http.get(Uri.parse("$_baseUrl?_page=$_page&_limit=$_limit"));
      setState(() {
        _posts = json.decode(res.body);
      });
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  late ScrollController _controller;
  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Your news',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: _isFirstLoadRunning
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _posts.length,
                      controller: _controller,
                      itemBuilder: (_, index) => Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        child: ListTile(
                          title: Text(_posts[index]['title']),
                          subtitle: Text(_posts[index]['body']),
                        ),
                      ),
                    ),
                  ),
                  if (_isLoadMoreRunning == true)
                    const Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 40),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  if (_hasNextPage == false)
                    Container(
                      padding: const EdgeInsets.only(top: 30, bottom: 40),
                      color: Colors.amber,
                      child: const Center(
                        child: Text('You have fetched all of the content'),
                      ),
                    ),
                ],
              ));
  }
}
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final _baseUrl = 'https://jsonplaceholder.typicode.com/posts';
//   int _page = 0;
//   final int _limit = 20;

//   bool _isFirstFetch = false;
//   bool _isFirstLoading = false;

//   bool hasNextPage = true;
//   bool isLoadMoreData = false;
//   List _posts = [];

//   Future<void> _firstLoad() async {
//     setState(() {
//       _isFirstFetch = true;
//     });

//     try {
//       final response =
//           await http.get(Uri.parse("$_baseUrl?_page=$_page&_limit=$_limit"));
//       setState(() {
//         _posts = json.decode(response.body);
//       });
//     } catch (error) {
//       if (kDebugMode) {
//         print('Something went wrong');
//       }
//     }

//     setState(() {
//       _isFirstLoading = false;
//     });
//   }

//   Future<void> _loadMoreDta() async {
//     if (hasNextPage == true &&
//         _isFirstLoading == false &&
//         isLoadMoreData == false &&
//         _scrollController.position.extentAfter < 300) {
//       setState(() {
//         isLoadMoreData = true; // ? Display a progress indicatro at the bottom
//       });
//     }

//     _page += 1; // ? Increase _page by one

//     try {
//       final response =
//           await http.get(Uri.parse("$_baseUrl?_page=$_page&_limit=$_limit"));

//       final List newPosts = json.decode(response.body);
//       if (newPosts.isNotEmpty) {
//         setState(() {
//           _posts.addAll(newPosts);
//         });
//       } else {
//         setState(() {
//           hasNextPage = false;
//         });
//       }
//     } catch (error) {
//       if (kDebugMode) {
//         print('Something went wrong');
//       }
//     }

//     setState(() {
//       isLoadMoreData = false;
//     });
//   }

//   late ScrollController _scrollController;
//   @override
//   void initState() {
//     super.initState();
//     _firstLoad();

//     _scrollController = ScrollController()
//       ..addListener(() {
//         _loadMoreDta();
//       });
//   }

//   @override
//   void dispose() {
//     super.dispose();

//     _scrollController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(widget.title),
//         ),
//         body: _isFirstLoading
//             ? const Center(
//                 child: CircularProgressIndicator(),
//               )
//             : Column(
//                 children: [
//                   Expanded(
//                     child: ListView.builder(
//                         controller: _scrollController,
//                         padding: const EdgeInsets.all(16),
//                         itemCount: _posts.length,
//                         itemBuilder: (_, index) {
//                           return Card(
//                             child: ListTile(
//                               title: Text(_posts[index]['title']),
//                               subtitle: Text(_posts[index]['body']),
//                             ),
//                           );
//                         }),
//                   ),
//                   if (isLoadMoreData == true)
//                     const Center(child: CircularProgressIndicator()),
//                   // if (hasNextPage == false)
//                   //   Container(
//                   //     color: Colors.indigo,
//                   //     padding: const EdgeInsets.only(top: 30, bottom: 40),
//                   //     child: const Center(
//                   //       child: Text(
//                   //         'There is no data anymore',
//                   //         style: TextStyle(
//                   //           color: Colors.white,
//                   //           fontSize: 18,
//                   //         ),
//                   //       ),
//                   //     ),
//                   //   )
//                 ],
//               ));
//   }
// }
