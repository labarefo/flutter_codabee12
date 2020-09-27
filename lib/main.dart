import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:dart.';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    if(Platform.isIOS){

    }
    return MaterialApp(
      title: 'Calculateur de calories',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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

  double poids;
  final bool feminin = true;
  bool genre = false;
  double age;
  double taille = 170.0;

  int radioSelectionne = 0;
  Map mapActivite = {
    0: "Faible" ,
    1: "Moderée",
    2: "Forte"
  };

  int calorieBase;
  int calorieAvecActivite;

  @override
  Widget build(BuildContext context) {

    return new GestureDetector(
        onTap: (() => FocusScope.of(context).requestFocus(new FocusNode())),
        child: Platform.isIOS
            ? new CupertinoPageScaffold(
            navigationBar: new CupertinoNavigationBar(
              backgroundColor: setColor(),
              middle: texteAvecStyle(widget.title),
            ),
            child: body())
            : Scaffold(
            appBar: AppBar(
              backgroundColor: setColor(),
              title: Text(widget.title),
            ),
            body: body()
        )

    );

  }

  Widget body() {
    return new SingleChildScrollView(
      padding: EdgeInsets.all(15.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          padding(),
          texteAvecStyle("Remplissez tous les champs pour obtenir votre besoin journalier en calorie"),
          padding(),
          new Card(
            elevation: 10.0,
            child: new Column(
              children: [
                padding(),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    texteAvecStyle("Femme", color: Colors.pink),
                    switchSelonPlateforme(),
                    texteAvecStyle("Homme", color: Colors.blue),
                  ],
                ),
                padding(),
                ageButton(),
                padding(),
                texteAvecStyle("Votre taille est de: ${taille.toInt()} cm", color: setColor()),
                padding(),
                sliderSelonPlateforme(),
                padding(),
                new TextField(
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(labelText: "Entrez votre poids en kilos"),
                  onChanged: (String str){
                    setState(() {
                      poids = double.tryParse(str);
                    });
                  },
                ),

                padding(),

                texteAvecStyle("Quelle est votre activité sportive", color: setColor()),
                padding(),
                radio(),
              ],
            ),
          ),
          padding(),
          calcButton()
        ],
      ),
    );
  }

  Widget calcButton(){
    if(Platform.isIOS){
      return new CupertinoButton(
        color: setColor(),
          child: texteAvecStyle("Calculer", color: Colors.white, ),
          onPressed: calculerNombreDeCalories
      );
    }else {
      return new RaisedButton(
        color: setColor(),
        onPressed: calculerNombreDeCalories,
        child: texteAvecStyle("Calculer", color: Colors.white, ),

      );
    }
  }

  Widget ageButton(){
    if(Platform.isIOS){
      return new CupertinoButton(
          color: setColor(),
          child: texteAvecStyle(age == null ? "Entrer votre âge" : " Votre âge est de: ${age.toInt()}",
              color: Colors.white
          ),
          onPressed: montrerPiker
      );
    }else {
      return new RaisedButton(
          color: setColor(),
          child: texteAvecStyle(age == null ? "Appuyez pour entrer votre âge" : " Votre âge est de: ${age.toInt()}",
              color: Colors.white
          ),
          onPressed: montrerPiker
      );
    }
  }

  Row radio(){
    List<Widget> l = [];
    mapActivite.forEach((key, value) {
      Column colonne = new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Radio(value: key, groupValue: radioSelectionne,
              activeColor: setColor(),
              onChanged: (Object i){
                setState(() {
                  radioSelectionne = i;
                });

              }
          ),
          texteAvecStyle(value, color: setColor())
        ],
      );
      l.add(colonne);
    });
    return new Row(
      mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
      children: l,
    );
  }

  Padding padding(){
    return new Padding(padding: EdgeInsets.only(top: 20.0));
  }

  Color setColor(){
    if(genre){
      return Colors.blue;
    }else{
      return Colors.pink;
    }
  }


  Widget sliderSelonPlateforme (){
    if(Platform.isIOS){
      return new CupertinoSlider(
          max: 215.0,
          min: 100.0,
          activeColor: setColor(),
          value: taille,
          onChanged: (double d){
            setState(() {
              taille = d;
            });
          }
      );
    }else{
      return new Slider(value: taille,
          max: 215.0,
          min: 100.0,
          activeColor: setColor(),
          onChanged: (double d){
            setState(() {
              taille = d;
            });
          });
    }
  }
  Widget switchSelonPlateforme (){
    if(Platform.isIOS){
      return new CupertinoSwitch(
          value: genre,
          activeColor: Colors.blue,
          onChanged: (bool b){
            setState(() {
              genre = b;
            });
          });
    } else {
      return new Switch(
          inactiveTrackColor: Colors.pink,
          activeTrackColor: Colors.blue,
          value: genre, onChanged: (bool b){
        setState(() {
          genre = b;
        });
      });
    }
  }

  Widget texteAvecStyle(String data, {color: Colors.black, fontSize: 15.0}){
    if(Platform.isIOS){
      return new DefaultTextStyle(
          style: new TextStyle(color: color, fontSize: fontSize),
          child: new Text(data,
          textAlign: TextAlign.center,));
    } else {
      return new Text(
          data,
          textAlign: TextAlign.center,
          style: new TextStyle(color: color,
              fontSize: fontSize)
      );
    }


  }

  Future<Null> montrerPiker() async{
    DateTime choix = await showDatePicker(context: context,
        initialDate: DateTime.now() , firstDate: new DateTime(1900), lastDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.year);
    if(choix != null){
      var difference = DateTime.now().difference(choix);
      var jours = difference.inDays;
      var ans = jours / 365;
      setState(() {
        age = ans;
      });
    }
  }

  calculerNombreDeCalories() {
    if(age != null && poids != null && radioSelectionne != null){
      //  calculer
      if(genre){
        calorieBase = (66.4730 + (13.7516 * poids) + (5.0033 * taille) - (6.7550 * age)).toInt();
      }else{
        calorieBase = (655.0955 + (9.5634 * poids) + (1.8496 * taille) - (4.6756 * age)).toInt();
      }
      switch(radioSelectionne){
        case 0:
          calorieAvecActivite = (calorieBase * 1.2).toInt();
          break;
        case 1:
          calorieAvecActivite = (calorieBase * 1.5).toInt();
          break;
        case 2:
          calorieAvecActivite = (calorieBase * 1.8).toInt();
          break;
        default:
          calorieAvecActivite = calorieBase;
          break;
      }
      setState(() {
        dialogue();
      });
    }else{
      alerte();
    }
  }

  Future<Null> dialogue() async {
    return showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext bc){
          return SimpleDialog(
            title: texteAvecStyle("Votre besoin en calories"),
            contentPadding: EdgeInsets.all(15.0),
            children: [
              padding(),
              texteAvecStyle("Votre besoin de base est de: $calorieBase"),
              padding(),
              texteAvecStyle("Votre besoin avec activité sportive est de: $calorieAvecActivite"),
              new RaisedButton(
                color: setColor(),
                onPressed: ()=> Navigator.pop(bc),
                child: texteAvecStyle("OK", color: Colors.white),
              ),

            ],
          );
        }
    );
  }

  Future<Null> alerte() async {
    return showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext){
          if(Platform.isIOS){
            return new CupertinoAlertDialog(
              title: texteAvecStyle("Erreur"),
              content: texteAvecStyle("Tous les champs ne sont pas remplis"),
              actions: [
                new CupertinoButton(
                    child: texteAvecStyle("OK", color: Colors.red),
                    onPressed: () => Navigator.pop(buildContext),
                  color: Colors.white,
                )
              ],
            );
          }else {
            return new AlertDialog(
              title: texteAvecStyle("Erreur"),
              content: texteAvecStyle("Tous les champs ne sont pas remplis"),
              actions: [
                new FlatButton(
                    onPressed: () => Navigator.pop(buildContext),
                    child: texteAvecStyle("OK", color: Colors.red))
              ],
            );
          }

        }

    );
  }
}
