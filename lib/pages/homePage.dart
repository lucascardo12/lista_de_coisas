import 'package:flutter/material.dart';
import 'package:listadecoisa/pages/listasPage.dart';
import 'package:listadecoisa/services/global.dart' as global;

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
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                Color.fromRGBO(255, 64, 111, 1),
                Color.fromRGBO(255, 128, 111, 1)
              ])),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child: Text('Listas',
                      style: TextStyle(color: Colors.white, fontSize: 28))),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: global.lisCoisa.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ListasPage(
                                            coisas: global.lisCoisa[index],
                                          ))).then((value) {
                                setState(() {
                                  global.lisCoisa[index] = value;
                                });
                              });
                            },
                            child: Card(
                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(global.lisCoisa[index].nome)),
                            ));
                      }))
            ],
          )),
      persistentFooterButtons: [
        Container(
          color: Colors.white,
          width: MediaQuery.of(context).copyWith().size.width,
          child: Row(
            children: [
              Expanded(
                child: FlatButton(
                  child: Text(
                    'Criar Nova Lista',
                    style: TextStyle(color: Color.fromRGBO(255, 64, 111, 1)),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ListasPage())).then((value) {
                      if (value != null) {
                        setState(() {
                          global.lisCoisa.add(value);
                        });
                      }
                    });
                  },
                ),
              )
            ],
          ),
        )
      ], // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
