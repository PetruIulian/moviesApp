// ignore_for_file: depend_on_referenced_packages, always_specify_types, avoid_dynamic_calls

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.red,
      ),
      home: const MoviesPage(title: 'Movies'),
    );
  }
}

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key, required this.title});

  final String title;

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {

  List<dynamic> _movies = <dynamic>[];
  bool _loading = true;

  Future<void> getMovies() async{
    final http.Response response = await http.get(Uri.parse('https://yts.torrentbay.to/api/v2/list_movies.json'));
    if(response.statusCode == 200){
      final  jsonData = jsonDecode(response.body);
      setState(() {
        _movies = [jsonData['data']['movies']];
        _loading = false;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    getMovies();
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        drawer: const Drawer(),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Center(child: Text('Movies'),
          ),
          actions: <Widget>[IconButton(onPressed: (){}, icon: const Icon(Icons.search))],
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: PageView.builder(itemBuilder: (BuildContext context, int index){
            return DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Colors.blueAccent,
                      Colors.blue,
                      Colors.blueGrey
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: _loading ?
                const CircularProgressIndicator() :

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 300,
                      height: 450,
                      decoration: BoxDecoration(
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: Offset(11,10)
                          ,)
                        ],
                        image: DecorationImage(
                            fit: BoxFit.cover, image: NetworkImage('${_movies[0][index]['medium_cover_image']}'),),
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: Center(
                        child: Text("${_movies[0][index]['title']}",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 36,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                    ),
                    Center(
                      child: Text(
                        "${_movies[0][index]['genres'][0]} | ${_movies[0][index]['rating']} / 10",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white12
                        ,),
                      ),
                    )
                  ],
                )
            ,);
        },)
      ,);
    }
}
