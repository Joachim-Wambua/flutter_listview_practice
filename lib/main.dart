// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Name Generator',
      // Changing the app's theme using ThemeData class
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: RandomWords(),
    );
  }
}

// Created a new Stateful Widget for generating Random words
class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  // Initialising a list to hold all randomly generated word pairs
  final _wordSuggestions = <WordPair>[];
  // Variable to hold Saved Words swa
  final _favourites = Set<WordPair>();
  // variable to hold font size information
  final _biggerFont = TextStyle(fontSize: 18.0);
  @override

  // Building The App's Basic Structure...
  Widget build(BuildContext context) {
    return Scaffold(
      // Create the app bar of the App
      appBar: AppBar(
        title: Text('Random Name Generator'),
        actions : [
          // Adding a List Icon button to the AppBar...
          // which when pressed moved to the page with saved favourites
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      // Calling the function that generates the word pairs while placing them
      // In the List View array
      body: _buildSuggestions(),
    );
  }

  // Widget function to create the content layout of a single word suggestion row
  Widget _buildRow(WordPair pair){
    // Variable to hold word pairs that have already been marked as favourites
    final _alreadyFavourite = _favourites.contains(pair);
    //Returns a list tile...
    return ListTile(
      // ...with a Text Widget
      title: Text(
        // Words are in PascalCase
        pair.asPascalCase,
        // Using font initialised earlier
        style: _biggerFont,
      ),
      //  Adding a trailing icon
      trailing: Icon(
        // Initialised two favourite icons one for 'active' and another for 'inactive'
        _alreadyFavourite ? Icons.favorite : Icons.favorite_border,
        color: _alreadyFavourite ? Colors.red : null,
      ),
      // When user taps on an word pair in the list view...
      onTap: () {
        // responsible for changing state
        setState(() {
          // If word is already a favourite..
          if (_alreadyFavourite) {
            // Then remove it from the favourites array
            _favourites.remove(pair);
          }
          // Else if word is not a favourite, then add to favourites
          else {
            _favourites.add(pair);
          }
        });
      },
    );

  }

  // Widget function to build a list view of randomly generated words
  Widget _buildSuggestions() {
    return ListView.builder(
      // Creates padding all round the list views of 16 pixels
        padding: EdgeInsets.all(16.0),
        // Item builder is called once per word pair suggestion
        itemBuilder: /*1 Places each suggestion to the ListTile Row */ (context, i) {
          if (i.isOdd) return Divider(); /*2 Adds a divider between the word pairs*/
          // Returns Integer value of i divided by 2
          //Calculates the actual number of word pairings without the divider widgets
          final index = i ~/ 2;
          // If the list view reaches the end of available words...
          if (index >= _wordSuggestions.length) {
            //...then, generate 10 more and add them to the list view.
            _wordSuggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_wordSuggestions[index]);
        });
  }

  // Function to change pages from main page to favourites list page
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        // Builds List of favourited words...
        builder: (BuildContext context) {
          final tiles = _favourites.map(
                (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          // adds horizontal spacing between each ListTile
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Favourites'),
            ),
            body: ListView(children: divided),
          );
        }, // ...to here.
      ),
    );
  }
}