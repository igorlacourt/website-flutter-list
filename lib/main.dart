import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Firestore'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ExpenseList(),
    );
  }
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}



class ExpenseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("produtos").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          var snap = Firestore.instance.collection("produtos").snapshots();
          var docs = Firestore.instance.collection("produtos").getDocuments();
          if (!snapshot.hasData) return Text("There is no expense");
          return ListView(children: getExpenseItems(snapshot));
        });
  }

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((doc) => ListTile(title: new Text(doc["nome"]), subtitle: new Text(doc["id"].toString())))
        .toList();
  }
}

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}



class _ListPageState extends State<ListPage> {

  Future getProdutos() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("produtos").getDocuments();
    var i = qn.documents;
    var j = 0;
    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getProdutos(),
        builder: (_, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text("Loading..."),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, index){
                  return ListTile(
                      title: Text(snapshot.data[index].data["nome"])
                  );
                });
          }
        });
  }
}

