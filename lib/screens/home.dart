import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _search = "";

  Future<Map> _getUsers() async {
    http.Response response;
    response = await http
        .get("https://api.github.com/search/users?q=${_search}&per_page=10");
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

//    _getUsers().then((map) {
//      print(map);
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Git Crazy"),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
              child: TextField(
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _search == "" ? Icons.search : Icons.close,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        setState(() {
                          _search = "";
                        });
                      },
                    ),
                    labelText: "Pesquisar",
                    labelStyle: TextStyle(color: Colors.black, fontSize: 18.0),
                    border: OutlineInputBorder()),
                style: TextStyle(color: Colors.black, fontSize: 18.0),
                textAlign: TextAlign.start,
                onChanged: (text) {
                  setState(() {
                    _search = text;
                  });
                },
              ),
            ),
            _search != ""
                ? Expanded(
                    child: FutureBuilder<Map>(
                        future: _getUsers(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                            case ConnectionState.none:
                              return Container(
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black),
                                  strokeWidth: 5.0,
                                ),
                              );
                            default:
                              if (snapshot.hasError)
                                return Container();
                              else
                                return _createGitTable(context, snapshot);
                          }
                        }),
                  )
                : Container()
          ],
        ));
  }

  Widget _createGitTable(BuildContext context, AsyncSnapshot snapshot) {
    print("Quantidade ${snapshot.data["items"].length}");
    print("Snapshot ${snapshot.data}");
    return GridView.builder(
        padding: EdgeInsets.all(4.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              2, //Quantidade de users na vertical (Cross = Vertical --- Main = Horizontal)
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          childAspectRatio: 0.65,
        ),
        itemCount: snapshot.data["items"].length,
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () {},
              child: Card(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 0.8,
                    child: Image.network(
                      snapshot.data["items"][index]["avatar_url"],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        snapshot.data["items"][index]["login"],
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              )));
        });
  }
}
