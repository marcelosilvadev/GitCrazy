import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Repositories extends StatelessWidget {
  final String user;
  final List repo;
  Repositories(this.user, this.repo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Repositorios"),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 15.0),
                  itemCount: repo.length,
                  itemBuilder: (context, index) {
                    return _repositoriesCard(context, index, repo);
                  }),
            )
          ],
        ));
  }

  Widget _repositoriesCard(BuildContext context, int index, List repo) {
    return InkWell(
        onTap: () {},
        child: Card(
          child: Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${repo[index]["name"]}",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${repo[index]["description"] == null ? "Sem Descriçao" : repo[index]["description"]}",
                        style: TextStyle(fontSize: 15),
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.language, size: 15,),
                          Text("${repo[index]["language"]}"),
                          Divider(
                            color: Colors.red,
                          ),
                          Icon(Icons.star, size: 15,),
                          Text("${repo[index]["watchers_count"]}"),
                          Icon(Icons.device_hub, size: 15,),
                          Text("${repo[index]["forks_count"]}"),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
